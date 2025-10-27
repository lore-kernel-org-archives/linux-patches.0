Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0853832548D;
	Mon, 27 Oct 2025 19:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592689; cv=none; b=uxfZYbB6GuEatW0790+O4uP7lv0Mml+mF99PMI+B7XaleikNrLwBXEa6QgFSDNLcn7EeUmlgDHuCyKgjowjbEkJNyMF/8jarnB7GuZTt3/SDyAfHE3zaBRLi/1N6uqdTt/Ym4AdCafelez0k2wlqHkM7nFtuMuKXeVaYkm1xuEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592689; c=relaxed/simple;
	bh=R1qLJqPpYXwQpnn3E40ssVwkt/bfxYueHHP9OAsNPns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jnlfs/YV4Ndr7PaX2y8ygCQn42n9qfAx2DO3at5dy5zAFfQcjLKEY74fnJhywL3TQ5SgSCdJFMUYKk9T4ymZcd7Nxzf1horvbLNPm1n1jeVJwQ92EtB/UsbcSgbKUJKHURXjRQCKwIMgT+CY07uSDFdfK0IOw26BuE/w3We+/wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyeBDPjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyeBDPjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0BFC4CEF1;
	Mon, 27 Oct 2025 19:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592688;
	bh=R1qLJqPpYXwQpnn3E40ssVwkt/bfxYueHHP9OAsNPns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyeBDPjHHKp/MSOMqX0UUYP1DpFQG53pHce5qgB6dX9f+vAPhbKz8VoFFN1a32hZk
	 p3gGUqQgHpj1cL6PvfKu/5dLf2LXD6Mxe2jBWR/d29IQU/2wX5sr6NFb/z2Y3tcdJm
	 UPT5JkstWSDVu/umK6yuB0Oe5uaOe6+GTGrY4ees=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 57/84] io_uring: correct __must_hold annotation in io_install_fixed_file
Date: Mon, 27 Oct 2025 19:36:46 +0100
Message-ID: <20251027183440.340148281@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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
index 6e86e6188dbee..ff74d41d9e53c 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -62,7 +62,7 @@ void io_free_file_tables(struct io_file_table *table)
 
 static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 				 u32 slot_index)
-	__must_hold(&req->ctx->uring_lock)
+	__must_hold(&ctx->uring_lock)
 {
 	struct io_fixed_file *file_slot;
 	int ret;
-- 
2.51.0



