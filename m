Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620870;
	b=otcVztTBFJEtZJ5j9JUJ1X64qGVI1Wu1fFqzcnGciy7P7RFX4XjCBQX1k3e8wPH+PHLv
	 OIGmdL8SNalUA1Ep61GtD2d0jFYVKQfAUkrfCRUDW1COMzMW7XNcpS564hB9eRXuOJiGM
	 uuHRVDpLHniUTaYSQi4AvyItlnGvs9At+uiHudUmNPvhfngz7ERsf3j+kAEjk0HQ7uaeX
	 nBy1G5Cs0SmCLN5i0fE9e4yqvuX+rF/SJYRGI0szKBi+YfiZb3aErvL3vTkDgmrpL42jD
	 JBc4TNTUYW3DIMbE3wzQPq/cUgFUoqfRjgusKIV8R3OJnlbGrA2E/3DswQBTT+nAmaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6FXe83TWZDatYcw80DPSriNWP5URA7rMaJf4dLVG0rA=;
	b=fYbsxOawaM0A3G85+O+hlJEr4gcyvP3ha8Xa8daAkTKgptklibhaJK2KaNhrVZzMXEQR
	 pV9h1YohgHeL1rcyzPTKZ7HBTCfnU8yKt9jqHDvmpxzUrQNQ/PtDnDaEb73I2SRl/JyCV
	 tp7Ak7zepsyUew+Af+GCmCZnHAqGsdfd+XS+iCIGOxSUdMol/SVsVV3BDpViMRGwBWvSd
	 j1fcBKC9iKc8TIeyVpsscE626VGziZamdhU7EglB2/S76hK9KTTfc2icUj020cxk+kbgT
	 qeUbniDe05qYxEBwDAXIGFYLSLRnd2RotChO9F7hvPw56B+GjnuqyDcoUB3Qd32BQiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Vw4/CpK6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B89E606A323;
	Wed, 25 Nov 2026 15:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vw4/CpK6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827431F000E1;
	Wed, 25 Nov 2026 15:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620870;
	bh=6FXe83TWZDatYcw80DPSriNWP5URA7rMaJf4dLVG0rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vw4/CpK6i67jDQYsdCgnT9NoA41W5sP4HiRdreX0qIXeE2GShIvlq9/kdKKgEd2LN
	 7XW4WAOy9XsspSDjwIe+y5m/6Je+pHe/ro6Z+74e9WIqzg+LfPV2LLXNuRrRNQW9rA
	 57txydzvRiNYGjUffuy1dF7RlxwBUZGRR7SEMlWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/990] io_uring/rsrc: keep the old file when a file update fails
Date: Wed, 25 Nov 2026 15:23:35 +0100
Message-ID: <20261125143823.217262283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[axboe: 6.18 doesn't clamp the slot index with array_index_nospec() in
this function]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 7170b3f001d41..36a9bc279e74e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -237,9 +237,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			continue;
 
 		i = up->offset + done;
-		if (io_reset_rsrc_node(ctx, &ctx->file_table.data, i))
-			io_file_bitmap_clear(&ctx->file_table, i);
-
 		if (fd != -1) {
 			struct file *file = fget(fd);
 			struct io_rsrc_node *node;
@@ -262,11 +259,15 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				fput(file);
 				break;
 			}
+			if (io_reset_rsrc_node(ctx, &ctx->file_table.data, i))
+				io_file_bitmap_clear(&ctx->file_table, i);
 			ctx->file_table.data.nodes[i] = node;
 			if (tag)
 				node->tag = tag;
 			io_fixed_file_set(node, file);
 			io_file_bitmap_set(&ctx->file_table, i);
+		} else if (io_reset_rsrc_node(ctx, &ctx->file_table.data, i)) {
+			io_file_bitmap_clear(&ctx->file_table, i);
 		}
 	}
 	return done ? done : err;
-- 
2.53.0



