Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B59031D757;
	Mon, 27 Oct 2025 19:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592390; cv=none; b=VvFTD+2ZmP2fEkCtc1Qy3IAECb6v9+AT4JYrVoYUnrb+Vp7khL2wU1eHiZJi9EQ86aZOqvdvR+uWblFGDsFblgqc9DHHNqqG/e7g/aX4gPqM2waELRzB3ATFLOV410ki2NkwGemQekZkAYmtijYnS5VicW4Fy7fOrlTPmKXHHCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592390; c=relaxed/simple;
	bh=L/VBBScho41glXTP1m7Yw6fuvKjnMvdeFuR5dO+MTcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUxwkQiA3SGwMumMN5AWk4zIF3pK8lw8ptWwU4Mw0TxFNO0s5s0lTn89w2SW6H9zP5ysuisb8315Z+x4rBdoCX1ESaM+kcZ4Zyu/ACBAWoV2O6soQO+sY1fPUQW7MlJanIxR48hbsh42Dje7IOxLNmSnGZqIwT1L5gW8Ifo+BPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZsQt46r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZsQt46r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC66C4CEF1;
	Mon, 27 Oct 2025 19:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592389;
	bh=L/VBBScho41glXTP1m7Yw6fuvKjnMvdeFuR5dO+MTcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZsQt46rRrKVFYR9XF1VhHoT9ycrxnXBBOU4hexIOPN8aMLMqv107Vzyu4QcSFjYK
	 3+CbQlKLmbhNxcYrNsTeAY6vM529XVK2fifq6B7c7TQpIKM8hxD8+9EihpGm9yxEqV
	 PZQOvRE5Dyou/8jpig4VKexAGtzxsuxHU1cyVcIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/157] io_uring: correct __must_hold annotation in io_install_fixed_file
Date: Mon, 27 Oct 2025 19:36:03 +0100
Message-ID: <20251027183503.995632365@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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
index a64b4df0ac9c2..f9e59c650e893 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -62,7 +62,7 @@ void io_free_file_tables(struct io_file_table *table)
 
 static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 				 u32 slot_index)
-	__must_hold(&req->ctx->uring_lock)
+	__must_hold(&ctx->uring_lock)
 {
 	bool needs_switch = false;
 	struct io_fixed_file *file_slot;
-- 
2.51.0



