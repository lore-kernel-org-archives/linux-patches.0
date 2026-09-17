Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39817463B63;
	Thu, 17 Sep 2026 16:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660928; cv=none; b=mBlHMXZRwbsOYfu6lv1j0Vhf3Txw7BtpmhT4QDffRgLzYS8phFVAv2DEBcN5Hu/GqiRtcXgXcGpE8pyIGTTdPAi9FiqDZlKRxETT/saKyRTpPj+r9RGDA4fYgK4+zgXFem0gUKJ2m8TFZ+hVR8SnWnDiUE7mDgHnyB7Af3XV24s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660928; c=relaxed/simple;
	bh=t/5QB6dGFxnM9IdQGbxF77XpqXN24xa2a4jdRl7Od/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnp9jbt/tvUI395bjpaV62vb1xrXExHi+WegKsXbBU1P0Y9JdjKZ9yNOwhCQazTXp0gD0JB6lIi+bScx3fyhyyfrzptpPUWhjUi5wkY8Ovujk0cwsos55rLTUdzAWVn5WnkKuHzswtPihCUbkrV8YzNutBxbJumDpBhRoCw2ryA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ek7+OaOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ek7+OaOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2B31F000FF;
	Thu, 17 Sep 2026 16:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660927;
	bh=W9MmPA7yYdryGk1rMJZqHGvBS1YobvJxpPYNWhDe4SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ek7+OaOB7HhimKv6nJ4rPBJdctqahggBUH6OLhIvrKqlOHAhoIazi8ajRsT5Tr3Mt
	 upw52tqvo6G6G5NQYbzbQaSKotMCCkguLRtc4N3HTSDS7sUBAD07NTswRHBAi4FijA
	 oX3LQ7gFMU4dH/EsK8blKwkO4Q1vjruFPpmpgXDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hirokazu Honda <hiroh@chromium.org>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0024/1250] tee: optee: Allow MT_NORMAL_TAGGED shared memory
Date: Thu, 17 Sep 2026 15:56:59 +0100
Message-ID: <20260917151552.582584955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hirokazu Honda <hiroh@chromium.org>

[ Upstream commit 1a6e94a8ff32e7879effd1e4a45bf112e506edc1 ]

On ARM64, shared memory can have MT_NORMAL_TAGGED attribute when using
the Memory Tagging Extension (MTE). The OP-TEE driver needs to
recognize this as normal memory to allow sharing such buffers with the
Secure World.

Signed-off-by: Hirokazu Honda <hiroh@chromium.org>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/call.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tee/optee/call.c b/drivers/tee/optee/call.c
index 16eb953e14bb6..e422e77b06fb8 100644
--- a/drivers/tee/optee/call.c
+++ b/drivers/tee/optee/call.c
@@ -602,7 +602,8 @@ static bool is_normal_memory(pgprot_t p)
 	return (((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEALLOC) ||
 		((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEBACK));
 #elif defined(CONFIG_ARM64)
-	return (pgprot_val(p) & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL);
+	return ((pgprot_val(p) & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL)) ||
+	       ((pgprot_val(p) & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL_TAGGED));
 #else
 #error "Unsupported architecture"
 #endif
-- 
2.53.0



