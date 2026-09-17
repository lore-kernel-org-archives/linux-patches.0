Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90EA3B776C;
	Thu, 17 Sep 2026 17:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667202; cv=none; b=oTbCfkBgIeTO+KBH9C4dtPvLcSNaHmbiNz4QpMNnE59YqvM8ArEiHdnL5cPyw/hPDxz2MMe3VTxBF4gI8PbW/4hrcqVUqnsCMsf24Y9+Hax/d8CFMYrRA96B+Ynw8YyqeI9fNcy36D1/LhQaF3VUfTehb4Ri1BUoaozzRclHxgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667202; c=relaxed/simple;
	bh=EAok0I8yGJvEszh+goDaPfZKZMEIVGJNAzzFJYBmTL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zqhb5fAnF9vA2sbdVNvsi26J0CclqvTlcNvFtnuoMUFtk4TCaRHQOcsyDhr0bJ8h7w4wxNLH/x8RMEohZ0m2SfAD7onaVPUgX5rrQvwAQbTtWhyDaVtUTpV/esd6zPGPtpywsdHedyrOWGvU7Ru6KUKGc5TUVh/MnnLpYz7xvIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wu85I88N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wu85I88N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C09B1F000FF;
	Thu, 17 Sep 2026 17:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667201;
	bh=JXcO/vlcejeyhaETvEIXT1mzTsTuaLP/ERPWUpEiLT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wu85I88Nhpam3h4xxRMAkyQb9k68/2prLf02h4wRqCk6jZ4bC2PrH4nHl3NS2kwZL
	 aLZKcttbhF8L1fX5MMSpm9MiKHJsYhsi0HgpyPDX9Fn0bfQ1Ygq1lzQHdGeNhhH9OA
	 QdNKzSmK0sHragrmh8z/Kz+1SVIk52xVxbmyBNRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hirokazu Honda <hiroh@chromium.org>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0015/1102] tee: optee: Allow MT_NORMAL_TAGGED shared memory
Date: Thu, 17 Sep 2026 15:59:18 +0100
Message-ID: <20260917151539.807608787@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



