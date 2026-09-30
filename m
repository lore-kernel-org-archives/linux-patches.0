Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5089F5158BD;
	Wed, 30 Sep 2026 18:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793996; cv=none; b=dvhj6jSxo5jmEsAOEz8oorieSnyCMzfe9LlbdBo/uIYnJOltCbMgvpb4rjOagKZWtA5lPhAuaR2P7GBEvNEU7c57u9ukl+WxlqaSk5culKrwXLRXBCVQ+gzonEsuEwkqj3YzF1JIfBIAWdhPpkrrQXZktod17MwdjGgSzdXS4Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793996; c=relaxed/simple;
	bh=fMPQMeGaZQi0wzJ4txcR4tZiVqjF/sjucJ8AsKdiBsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBqQYPBmtokT9IeWiEGah4QGz9MckUZ2ma5O04xaTHbVcwdcfIVEcvWj8a/HjGWVhoMk+WP4egEnnRHt03LVAJalv1c82JMTuwAQH8lqEEAnC0StzXFvq1Kg4JefnAIu9fovJPb4Oe7Lr8FU08E0W+Ch5mIxiyCIQfTXo2xHJMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHwkJPV1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHwkJPV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906FC1F000FF;
	Wed, 30 Sep 2026 18:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793995;
	bh=gwzEI1MJEEiZ78rNu4lt2rVU+ZZ9m767181A5kn9d5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nHwkJPV1qbFYh4/Oe5ebubWlTXnfZO65+bL54iv9dg2ictT2JTRt1uOyE0Cz3Dz3U
	 JlXF2JKQFuXBZ7FhQiXHl44Iz++prfZtZIfuxYt7Wpon0h40suvaVA2X2XhxAybrIe
	 IQUa1peiSbrxo1OUWyzM61gsqNAPMyCTpoCqo/Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hirokazu Honda <hiroh@chromium.org>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0010/1193] tee: optee: Allow MT_NORMAL_TAGGED shared memory
Date: Wed, 30 Sep 2026 17:11:34 +0200
Message-ID: <20260930152434.536309956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index df5fb5410b722..bfabf057f06f4 100644
--- a/drivers/tee/optee/call.c
+++ b/drivers/tee/optee/call.c
@@ -486,7 +486,8 @@ static bool is_normal_memory(pgprot_t p)
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



