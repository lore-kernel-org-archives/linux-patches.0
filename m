Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624089;
	b=bTMhwjEodvTSj56jCuDq5mk6ghk3S6GZ5xI5W9zqrEe+27sy5gLliLOS/pdKBir5gXHg
	 5Un49N+OtGX2lfrwhNgGIFXcsTMOxKDrtDpCVCyTAZnMEqZr1vVbx/dSUJXRpeUgUu+5a
	 Id+0q5dCxMKzYJL+v0yX9Ty3mGInWUGaVL2kphWdPgAbYdb0OViBZLI38E7eFQXoswBH+
	 CZ2SFBE+YGIujbszupyENCIWOgDP0tFyhemM270bPHaZidTIubXyioBDz9DP05b1T20Mv
	 DytTigH/Cl1om/kXar2OsMQyoTD7kC0Wb90Pxyt5QSaH51YBuwrdHRurNCF5lLZ4d4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=86xJVhXRsKXW+11N/YNiwPs9wlGQAcTTa0g9MFUgvmo=;
	b=FWTrBBWHPSXOwoNFC6yAwXT2AXulyOE8gRZIoM/c8uOaPWnT5+zjF/FvEr8onnZzizZv
	 E7ka3Pc0JrdXn2Wo9vCfdjEgBv5m1MsuaT6yYitmTFNAzs+fBWrPFtYDgsBsK2lWkvxLN
	 atilkVCXBDdMs7OQb2hhl6Jh+n03gxGVawtGRtKGsSSTWYwbjdOklIfDLrJIpR8LDxVqy
	 bDxyPrvNGe8L1i32slvcdus2kaioFp/nhzZx6KHlaqsqrh9C/aq1CV3xFZ81iOvkLpJ4x
	 M9/id7SFDuVwNvghqP6GjyuDX/Vi4p2kA+8NARbXDa9w2O3P15pFfiLs4PAoS+iElFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N1sPvzgx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A01E606A686;
	Wed, 25 Nov 2026 16:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N1sPvzgx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1041F000D8;
	Wed, 25 Nov 2026 16:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624088;
	bh=86xJVhXRsKXW+11N/YNiwPs9wlGQAcTTa0g9MFUgvmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1sPvzgxAMycBLDfNczl5CYKNwFJpe4hm7Jv6y9YrjRRUjytKSMDOO4JnjU/N9Ryw
	 vcmPcMI7lI3J6VbmWnP+0Em7/mDpST7mC9Xw1NdcjITsxFyfiOSMzJ3PKOQ3SVHGmf
	 zqkweuQJk9e8BdP2CQ0/FwQU9tzelpi76PrZ8B5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/816] io_uring/rsrc: keep the old file when a file update fails
Date: Wed, 25 Nov 2026 15:26:25 +0100
Message-ID: <20261125143850.081343769@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Yongkang <teel4res@gmail.com>

Commit e5a346e4309d720c47fe8331a00068608fad47dd upstream.

__io_sqe_files_update() resets the slot before it calls fget() on the
new fd. If fget() fails, the fd is an io_uring file, or the node
allocation fails, the update stops and reports that entry as not done,
but the old file has already been removed. Later requests that use the
slot fail with -EBADF, and if the old file was registered with a tag,
its tag CQE is posted as if it had been removed on purpose.

Reset the slot only after the new file has been checked and its node
allocated, as io_install_fixed_file() does. Removal with fd == -1 still
resets the slot right away.

Fixes: c3a31e605620 ("io_uring: add support for IORING_REGISTER_FILES_UPDATE")
Cc: stable@vger.kernel.org
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Link: https://patch.msgid.link/20261116044531.281978-1-teel4res@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[axboe: 6.12 has no rsrc nodes for files, the old file is queued for
removal with io_queue_rsrc_removal(), which can fail. Get and check the
new file first, and only remove the old one once that has succeeded]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 168c6987435ed..5a3f3e4e3fa11 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -348,6 +348,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
+		struct file *file = NULL;
 		u64 tag = 0;
 
 		if ((tags && copy_from_user(&tag, &tags[done], sizeof(tag))) ||
@@ -365,17 +366,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		i = array_index_nospec(up->offset + done, ctx->nr_user_files);
 		file_slot = io_fixed_file_slot(&ctx->file_table, i);
 
-		if (file_slot->file_ptr) {
-			err = io_queue_rsrc_removal(data, i,
-						    io_slot_file(file_slot));
-			if (err)
-				break;
-			file_slot->file_ptr = 0;
-			io_file_bitmap_clear(&ctx->file_table, i);
-		}
 		if (fd != -1) {
-			struct file *file = fget(fd);
-
+			file = fget(fd);
 			if (!file) {
 				err = -EBADF;
 				break;
@@ -388,6 +380,19 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				err = -EBADF;
 				break;
 			}
+		}
+		if (file_slot->file_ptr) {
+			err = io_queue_rsrc_removal(data, i,
+						    io_slot_file(file_slot));
+			if (err) {
+				if (file)
+					fput(file);
+				break;
+			}
+			file_slot->file_ptr = 0;
+			io_file_bitmap_clear(&ctx->file_table, i);
+		}
+		if (file) {
 			*io_get_tag_slot(data, i) = tag;
 			io_fixed_file_set(file_slot, file);
 			io_file_bitmap_set(&ctx->file_table, i);
-- 
2.53.0



