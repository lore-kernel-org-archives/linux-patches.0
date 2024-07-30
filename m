Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AB114831F;
	Tue, 30 Jul 2024 16:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358139; cv=none; b=tIlpg1r0tXhe6F26K+nou++T+7QLdeInZce74Nkh+9oYK7S7+t+4bin41iv6GEB9jtEQy4Fq0eLXogSCycNjHJDdLrblbq5yI1hbQo66bCg6o5Fs2X548GITPUECdcho2LZy9avELSedFUBBznb2LBkQkiB5AJaGAIMaeNDg4nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358139; c=relaxed/simple;
	bh=JF+f3nGfwMXP+QuXF8P/D11J+imsCd5OCrs+/n9ZsZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAcXwgrK7Q2BnJe5bl25rccLkoKCD75X1cc5+1/zMd4s9n2rrLqOfBm8Cn8RGDkaks044GlNRgrW5sLIEsiyEGVyk/Y+YBsPaL8N+LzRP+s9MAv6Y+AcJB4CDkuiQYTHwmJu/RJzIxXQj0MeNCDFjpOSJe7aC3BkcntIHhXicYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMvn4qri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMvn4qri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7D4C32782;
	Tue, 30 Jul 2024 16:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358138;
	bh=JF+f3nGfwMXP+QuXF8P/D11J+imsCd5OCrs+/n9ZsZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMvn4qriU6HYZ/oI4oDZDbgFFYLKCVqE1aMRa1tBInDcXZ5qKVrkQ1rP19EmLWSzW
	 EaBFpVHi+yCpaFojWLncEOMOKLZsl+1ZeEWEI/QoitR16QWfv6TqJHztUkSAqwSk2W
	 X9EAjwh/++9FQo4TQ8LqlJMUHmT+CnR1HgzjwRWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Pan-Doh <pandoh@google.com>,
	Sudheer Dantuluri <dantuluris@google.com>,
	Gary Zibrat <gzibrat@google.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 305/568] iommu/vt-d: Fix identity map bounds in si_domain_init()
Date: Tue, 30 Jul 2024 17:46:52 +0200
Message-ID: <20240730151651.796893522@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Pan-Doh <pandoh@google.com>

[ Upstream commit 31000732d56b43765d51e08cccb68818fbc0032c ]

Intel IOMMU operates on inclusive bounds (both generally aas well as
iommu_domain_identity_map()). Meanwhile, for_each_mem_pfn_range() uses
exclusive bounds for end_pfn. This creates an off-by-one error when
switching between the two.

Fixes: c5395d5c4a82 ("intel-iommu: Clean up iommu_domain_identity_map()")
Signed-off-by: Jon Pan-Doh <pandoh@google.com>
Tested-by: Sudheer Dantuluri <dantuluris@google.com>
Suggested-by: Gary Zibrat <gzibrat@google.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20240709234913.2749386-1-pandoh@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 744e4e6b8d72d..9918af222c516 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2411,7 +2411,7 @@ static int __init si_domain_init(int hw)
 		for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 			ret = iommu_domain_identity_map(si_domain,
 					mm_to_dma_pfn_start(start_pfn),
-					mm_to_dma_pfn_end(end_pfn));
+					mm_to_dma_pfn_end(end_pfn-1));
 			if (ret)
 				return ret;
 		}
-- 
2.43.0



