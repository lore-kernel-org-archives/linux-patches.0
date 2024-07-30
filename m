Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC511A6166;
	Tue, 30 Jul 2024 16:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356783; cv=none; b=mlOvUKO2TDfqaLgeC/goQIcAbH0tiACzcTRnkz2FI0uU9HUPiC9+hwC7cBxBFxKLRs75rdhe56gbiXf5sfWM0Ma12iuxsTPC42ZQ6+ai5hyQe2MUk5hSUBb9PD8s6kZQ/1ZcB03JLGYQL5H1HRycwoHzYEw6nxrBlC4gAQHg+oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356783; c=relaxed/simple;
	bh=wKYghqB33WCKCBrekGvJFnHumSjwRsmY9u5+zhdYnn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxdHpUy0QL849w+C5BtThW7WYyYrHkbMp/DhDJBq6ScbTdzfLPGXb7QJOgWMZ4PS8AzkG9UW2KvjRTMtBIY4TSxAdSxEoz4tn5UjmcQ6o9HDERnn6yOtS1v1T9Kl+A02DmZrq5JQNFAjmkiJhi3mK1Upk6nI/ag8ZnF28/XQ470=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJ/g09Iq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJ/g09Iq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08717C4AF0C;
	Tue, 30 Jul 2024 16:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356783;
	bh=wKYghqB33WCKCBrekGvJFnHumSjwRsmY9u5+zhdYnn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJ/g09IqBSaHRkf4qjicauj68/STXu6IOLovyTnLcXpTJkgQV9/0HQNb9tTJIH+bA
	 maX5jaVsM2/Zz/lRMsn8FliQw3S8MP7SlzyMtkHImtBHCEPMa3qNMf9hXR0nqNDehh
	 jJKSVsaJnzBVP/7D6Ruan07ORu7tXEO3u3XaEg0Q=
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
Subject: [PATCH 6.1 228/440] iommu/vt-d: Fix identity map bounds in si_domain_init()
Date: Tue, 30 Jul 2024 17:47:41 +0200
Message-ID: <20240730151624.763631078@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e3a95a347c3b9..7b9502c30fe94 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2444,7 +2444,7 @@ static int __init si_domain_init(int hw)
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



