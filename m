Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA35244393;
	Sun,  1 Sep 2024 16:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209560; cv=none; b=KijF5VaSaiy5nrSlggslV+7JUq1m7Q8rk2MpBBQEYNSuuaRm2wfoSDnzqDNjpERimHtfr2s6xx0Eca1AgHynGSznAslEF9qBMteW4sRILciTfgiuy/tABxG7z8Ud+w0uIBvdFWQ2LDv2fd38RhapipLzdE91hru7cSuO8gus18g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209560; c=relaxed/simple;
	bh=EZPa8LkzmanPLRFK3kcsrJ4CNWlk9EWcmDh/Ya/Qk/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgoeL20mikMmGb4hhiuCZoI2fHWDWaK/GmorlnBJmZRklqthSohKbKbdzM06S6ZQUZ1VGaQsTHSD01n67FI0foh0PsL0kc8FbSLNdZa0cZxXV1TLtTzDuw45aW8ih7HuBW01uqhyFgftplgqZwK3bvbrM/5vKIzCNudtmKidVWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSM7xNOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSM7xNOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B94C4CEC3;
	Sun,  1 Sep 2024 16:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209560;
	bh=EZPa8LkzmanPLRFK3kcsrJ4CNWlk9EWcmDh/Ya/Qk/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSM7xNOwpOnstiJgr+7tGiZFNqCVy9Y3+0UA3wlu08NaEuaB5k7DLFIMEccLgHcKE
	 udyZpaxdBJ2NysaTAfAD0jb/OtHFMX48d/WlJD4GMCOIgODXxgKeOjAZmgiqKuCfX9
	 YpRbmpuVSO5SIE5ixeV9OLgPGmYtfoC+V2P/VsBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/151] s390/iucv: fix receive buffer virtual vs physical address confusion
Date: Sun,  1 Sep 2024 18:17:15 +0200
Message-ID: <20240901160816.935764301@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 4e8477aeb46dfe74e829c06ea588dd00ba20c8cc ]

Fix IUCV_IPBUFLST-type buffers virtual vs physical address confusion.
This does not fix a bug since virtual and physical address spaces are
currently the same.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/iucv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 06770b77e5d22..be5f598acbce2 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -1088,8 +1088,7 @@ static int iucv_message_receive_iprmdata(struct iucv_path *path,
 		size = (size < 8) ? size : 8;
 		for (array = buffer; size > 0; array++) {
 			copy = min_t(size_t, size, array->length);
-			memcpy((u8 *)(addr_t) array->address,
-				rmmsg, copy);
+			memcpy(phys_to_virt(array->address), rmmsg, copy);
 			rmmsg += copy;
 			size -= copy;
 		}
-- 
2.43.0



