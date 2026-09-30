Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7630503BE0;
	Wed, 30 Sep 2026 16:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784063; cv=none; b=TCswHkN8inNVtRhispLPK8vdGM11lZ9W+QJnMQ1eBtho826sNWWtUWhzqlY3ZIMNCSLoa9YElAzjXUpEhGGtPyi3z0OGeDZNvMsvHqZVVa2q1RRUYJ7qXwTlE//MXJbi/SUF13IaPYHmK3RzuvlajmfHRNPyDqbJYWw9CVB0DUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784063; c=relaxed/simple;
	bh=BPoUtaL17B6C2lzOeEo2x80xQSiHT52opbN4mdU+KwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2QR4L873sL7fAKtE2tWU5TDhh7sqcKrTKAEOkDDZcX6JYLDwwkGjWQotpD1nFgWi9gn3jAau73npybqcuK1MnwVHc8ClXP/sMTzOXijC7PkWPI0EUeKPqw5+jlJeeAf5322g93NjDtxLISs1GwUCdLwZd9+xoQqedXzFoQap78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWPjjyIE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWPjjyIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463A01F000FF;
	Wed, 30 Sep 2026 16:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784059;
	bh=90k31A/6sKWyXfMb1SMV2gANCbcPlp4iueObZ4AJnSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWPjjyIEp8zgapmIY2CJI+yokr13Urr3WNVAdkIgLXrQzLgZP/6V/WpQx5Oo+XOpS
	 G9Wc1OCAfDmcN6l19L9Wl5xwNMcnlOh9kOWstBQVHwE/Ym4iyxnjZn/karfmRQdTlx
	 RbRk6DW5Ma2t6kPS7dAd7H1hKTomgjF4hqpL1GxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hirokazu Honda <hiroh@chromium.org>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/982] tee: optee: Allow MT_NORMAL_TAGGED shared memory
Date: Wed, 30 Sep 2026 17:12:22 +0200
Message-ID: <20260930152416.922272901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 290b1bb0e9cd7..5d4b8d75305f6 100644
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
 #error "Unuspported architecture"
 #endif
-- 
2.53.0



