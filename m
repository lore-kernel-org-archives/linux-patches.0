Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24479309F1E;
	Mon, 27 Oct 2025 19:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593484; cv=none; b=dpQGAreBBiQFYf8zWaLqioDKABH7e7A4iCDrmg/PnK6hgFYuCXGmZIya6u50VzGERGIOYhBUCPJfpt4CVO4oec20yqTzoP9tH57JlwIP3pf4A0Bxvxe/ZsIL60SMOsE3ykuNP3nCrbzCep77dLI5t0sxKQtrDSutgKJUmffNVDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593484; c=relaxed/simple;
	bh=7tZvoC9DSUEuR3/Qq1z0a69jIios6yt/47TFyis5fdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=in71FWgCHlKEVO8B6Zcr0N6WIpD3E6TjLPU2RXk2slAIe/K/G7QySSw3lpNNtIys92H6R82aeGo9Z5Erdu19gWapTSe/n5NYhz+h7hsDm7pd6p9hmGID1vVf40TDE7DpB1WCWNDbUYux8oUMFMVnIxaFMHlu84epJ27wWWPUTRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ha+X6p5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ha+X6p5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997E9C4CEF1;
	Mon, 27 Oct 2025 19:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593484;
	bh=7tZvoC9DSUEuR3/Qq1z0a69jIios6yt/47TFyis5fdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ha+X6p5Kfy7FpLFFJABq3eeRU3E+x/QsVqujH31DdFrcDnX7C52NQVdlKS9yj0QBh
	 C4JL+oR2z2XMTxM62f49sireanFh4ZfjXLHO8m+K8grqofgMVdBknCMN3NIs4vqFv/
	 pUcHnaaifLlTGP4m10XvxXTd2/g24Db/IePidG7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 147/184] io_uring: correct __must_hold annotation in io_install_fixed_file
Date: Mon, 27 Oct 2025 19:37:09 +0100
Message-ID: <20251027183518.896602674@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit c5efc6a0b3940381d67887302ddb87a5cf623685 ]

The __must_hold annotation references &req->ctx->uring_lock, but req
is not in scope in io_install_fixed_file. This change updates the
annotation to reference the correct ctx->uring_lock.
improving code clarity.

Fixes: f110ed8498af ("io_uring: split out fixed file installation and removal")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/filetable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index a21660e3145ab..794ef95df293c 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -57,7 +57,7 @@ void io_free_file_tables(struct io_ring_ctx *ctx, struct io_file_table *table)
 
 static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 				 u32 slot_index)
-	__must_hold(&req->ctx->uring_lock)
+	__must_hold(&ctx->uring_lock)
 {
 	struct io_rsrc_node *node;
 
-- 
2.51.0



