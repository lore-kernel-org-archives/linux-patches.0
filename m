Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2CE2BE118;
	Wed, 23 Apr 2025 15:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421690; cv=none; b=hPjTUWi9r09Jrmxm0CHCGzqbi5mdxFdBNU7XsWol1JBQyg3fWaZTsMtf3GHoAoPUAftoydsvpAr1ecBtPvQyGTnoMEiwv4zCD3qhbQ+An1OWLvNTsUyCSIvBSuw6X/6LkZtq/akQ1IdhdAXNkUwPtJFm0pVw/iC5gEh2wZRke5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421690; c=relaxed/simple;
	bh=luU7Xf68R7FGwCo0tbyhNU1AaqAuBVNpZPJ3YmrUKKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dL3cXePOKaUp65+vOn9XkjtthnrTEqLaUHfi6fmwJNAbB2TLmiszyQdCSKoLta3mJ6AqAu/ptOyKF6EjS8Y1hWdm+iLEKd9gUo3Mr++AQZmVCtPes6jPcBGg14KI5QEKYNfoe0P2qPhN8RtoH5zaMTKkz9EQLBLdA4kX8M76J3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLlUVD61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLlUVD61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6EAC4CEE2;
	Wed, 23 Apr 2025 15:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421689;
	bh=luU7Xf68R7FGwCo0tbyhNU1AaqAuBVNpZPJ3YmrUKKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLlUVD61oIqnqtbT7hoGUR3biRCNA3c2sDM9TXDr+xlH5eAsh0Po0HX7yZwII/SVc
	 MoVGoWdbC1WSlTj7VquKNwLr1h1ao6aIZUWNxHNKNOvydMVBaPzJ42qAT5JG5jZFWM
	 6I2cVvhu+ufJHV53AODLpuS9OQwSOTGPNBJI9jBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 220/241] io_uring: dont post tag CQEs on file/buffer registration failure
Date: Wed, 23 Apr 2025 16:44:44 +0200
Message-ID: <20250423142629.546149474@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

Commit ab6005f3912fff07330297aba08922d2456dcede upstream.

Buffer / file table registration is all or nothing, if it fails all
resources we might have partially registered are dropped and the table
is killed. If that happens, it doesn't make sense to post any rsrc tag
CQEs. That would be confusing to the application, which should not need
to handle that case.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Fixes: 7029acd8a9503 ("io_uring/rsrc: get rid of per-ring io_rsrc_node list")
Link: https://lore.kernel.org/r/c514446a8dcb0197cddd5d4ba8f6511da081cf1f.1743777957.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -130,6 +130,18 @@ struct io_rsrc_node *io_rsrc_node_alloc(
 	return node;
 }
 
+static void io_clear_table_tags(struct io_rsrc_data *data)
+{
+	int i;
+
+	for (i = 0; i < data->nr; i++) {
+		struct io_rsrc_node *node = data->nodes[i];
+
+		if (node)
+			node->tag = 0;
+	}
+}
+
 __cold void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_data *data)
 {
 	if (!data->nr)
@@ -539,6 +551,7 @@ int io_sqe_files_register(struct io_ring
 	io_file_table_set_alloc_range(ctx, 0, ctx->file_table.data.nr);
 	return 0;
 fail:
+	io_clear_table_tags(&ctx->file_table.data);
 	io_sqe_files_unregister(ctx);
 	return ret;
 }
@@ -855,8 +868,10 @@ int io_sqe_buffers_register(struct io_ri
 	}
 
 	ctx->buf_table = data;
-	if (ret)
+	if (ret) {
+		io_clear_table_tags(&ctx->buf_table);
 		io_sqe_buffers_unregister(ctx);
+	}
 	return ret;
 }
 


