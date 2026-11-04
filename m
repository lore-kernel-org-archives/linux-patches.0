Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829225;
	b=DdabKWFWh8gmz/P07Hmz+Q4QYBhHqM5PPoi8iBjfEdLdnhddoiphgf7y34MFyBKJiODW
	 1upkeO9+54rltj9vszjgYEcssjabuusODFsoXTDyKU1CiuDRFVPDJx++i4j8cKrO+tauJ
	 nyC7rGLQljahP+fT7cHZOsLfa/rX/szXZuvx0WLEuqFpo0g5Vd25YPjxKBWKWodh63YqW
	 7wyJ3kQ16ZZD+jsdXHIH8kB9UhwuRuHtKbyDXR4NdE4Z3J8syev4APSA1LnBakKbOz3eX
	 HqfmJB6deaKZ7wld6TBB3tekbelE+h+wB9Rb2YUjIYqwi0tagItHkYVAkJ+0za1w6DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yN9nG3bSmHc3jUWrtHDotlxNKvgeUtzirQQzYcoNMHM=;
	b=iItdTjy7RonNSstZipusmo8fVignTJNJq7IevACe9toQzui+RDq9Fm64+NRaQbK7A+X4
	 ekcsxYABRDjlzXkjlrKSdzzgaI+WG8vsiImUW4ADbrU1ZjpO90Fn+sKkPv9TMmrzUzx13
	 ESHJMHbBd4CsEa8Etl6K+urV+jQfsdc5wr/Pk0ibi/qQwNYMGfq3uFYzAlQc1uMABhSoS
	 FWt7IBHsISWUFvX96BLZSJ6XrIBkv/s80x1BRHbyhMNKZdIf4KpnJE0/hlI89qytRYJDk
	 N1tcV3cG2Q3+jktvypxBgY4Vdri0CxlYrdNwVc6B5tya0TqOOu5ZxYhDT6oirgQcNlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rj7QDAMy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A726070A88;
	Wed,  4 Nov 2026 21:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rj7QDAMy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF2B1F0093A;
	Wed,  4 Nov 2026 21:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829224;
	bh=yN9nG3bSmHc3jUWrtHDotlxNKvgeUtzirQQzYcoNMHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rj7QDAMyffv5z+baj9ShZ/pKBJc12i+7/phYk4ggZAIhPqyyfGC7McxrFDtatYqZZ
	 pILJXltDMpSdHPIo9Y3LunOXc+rqzzwL5oqhvKG7p4VoHhmmWkQRwEcAlQXthkG5C4
	 XQXFnnNAieHA2dCWSQNjiY4jqAJywUG/5pjM83aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 527/547] io_uring: free XArray nodes left by a failed store
Date: Wed,  4 Nov 2026 16:11:51 -0500
Message-ID: <20261104211053.365459776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

Commit 51bab09b7ca1a9a6dd9303a3b7ee346f8128c963 upstream.

A failed xa_store() can leave nodes without entries in the tree, and
erasing every entry doesn't free those. An XArray needs xa_destroy()
before it goes away, even an empty one. That was dropped for tctx->xa in
commit ca6484cd308a ("io_uring: no need to call xa_destroy() on empty
xarray") over a lockdep report from freeing the tctx in softirq context,
and ctx->personalities never had it.

Now that the nodes are charged, a store can fail at memory.max and the
leaked nodes stay charged. Call xa_destroy() in io_uring_clean_tctx(),
which the task runs itself in process context before the tctx is freed,
in the error path of __io_uring_add_tctx_node(), and for
ctx->personalities in io_ring_ctx_free().

Fixes: ca6484cd308a ("io_uring: no need to call xa_destroy() on empty xarray")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    1 +
 io_uring/tctx.c     |    3 +++
 2 files changed, 4 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2297,6 +2297,7 @@ static __cold void io_ring_ctx_free(stru
 	kvfree(ctx->cancel_table.hbs);
 	xa_destroy(&ctx->io_bl_xa);
 	xa_destroy(&ctx->hpage_acct);
+	xa_destroy(&ctx->personalities);
 	kfree(ctx);
 }
 
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -189,6 +189,7 @@ err_free:
 			io_wq_exit_start(tctx->io_wq);
 			io_wq_put_and_exit(tctx->io_wq);
 		}
+		xa_destroy(&tctx->xa);
 		percpu_counter_destroy(&tctx->inflight);
 		kfree(tctx);
 	}
@@ -250,6 +251,8 @@ __cold void io_uring_clean_tctx(struct i
 		io_uring_del_tctx_node(index);
 		cond_resched();
 	}
+	/* A failed xa_store() leaves nodes with no entry behind. */
+	xa_destroy(&tctx->xa);
 	if (wq) {
 		/*
 		 * Must be after io_uring_del_tctx_node() (removes nodes under


