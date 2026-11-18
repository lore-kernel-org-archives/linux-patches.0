Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035683;
	b=pTnaf0N+nx9RzHTUdUQ+3FNjKD4mc0mum9uXib8PgEHXM3E7tOVbMNuwB7GxnYh6SMY1
	 h0OWlJutIVOjNKk/TplMP7e1FBD9UkUmDuPEJbjlg8SkqMFOmkiYpqFAMuattBcn9FkJ6
	 yV3tpftNmPCzye7E6eIQK16lDp/cymZfQ75svwJqhfjMGdmMe06j0PZRJ5PfmZ53PGjpB
	 rBS606stvbP4zivT/FtPSXbY4zjZ4P73jWlVrziYliu0txSPHlqci4+vSl8Alo+o7dzcd
	 AK92aK23GipejgyI5AZkf7rqNZpf0nDyl+atH/H+qmuXwBAiW8i0fpK9aPqv3UtROeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/xiIXS+hhVChYdkWIKRM7z+1NQ9bV8+gfIzEYklCy2U=;
	b=ceB2aVzxSSlNNdT8Ko+gRdrWatHVPu33nqj8nkZ54qPemDdvqLwgm2Hi9UvKYKSJVKiK
	 9Zw0pTXUV0JWNoaNDUAEZUKgU/whaM9fjY1LXnBJ6C8QOZpvtluj22NeiJ2DMJXwhFU+y
	 c3yZbiOO2Ai/RSq4reTtxNphI1CgfsqMdjeajWgbOH8Dq5dhFPnEpjWOzKHB16MCCpM8L
	 YpNKWVNWKTzYVHwNGCLPL/+5NtKVpZIol8Rsgb9+gUc87V4dDKOp75jR0wSfIaTKGMJB+
	 Brcl+fwN5BysDpWMavz6rpZw8n8NfHBMXl5XE6ckhl55ideAvm4zb53s7wqy6rtlQiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=li7hE+HC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237F260A2610;
	Wed, 18 Nov 2026 21:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=li7hE+HC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDBE1F000C4;
	Wed, 18 Nov 2026 21:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035683;
	bh=/xiIXS+hhVChYdkWIKRM7z+1NQ9bV8+gfIzEYklCy2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=li7hE+HCI4x4TJu3D6q0fixOVIL1t3Zs/gThcgWPh7PSFEitfUPou9Tbvzm+NRRhS
	 0clCFrKoeiRC89ufabr3S8TwsIgf9WFNHOAvENZU/EDNuQuj1MKBABl+1Z1TGKHLqF
	 Ugc15ekgRe15U9muyFXBnVlFHvwoAVABurWNOkzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 0750/3318] io_uring: free XArray nodes left by a failed store
Date: Wed, 18 Nov 2026 15:22:52 +0100
Message-ID: <20261118150341.139293430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[axboe: 6.6 installs the tctx before adding the node and has no error
path that frees it, drop that hunk. There's no ctx->hpage_acct either]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    1 +
 io_uring/tctx.c     |    2 ++
 2 files changed, 3 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3123,6 +3123,7 @@ static __cold void io_ring_ctx_free(stru
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
 	xa_destroy(&ctx->io_bl_xa);
+	xa_destroy(&ctx->personalities);
 	kfree(ctx);
 }
 
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -197,6 +197,8 @@ __cold void io_uring_clean_tctx(struct i
 		io_uring_del_tctx_node(index);
 		cond_resched();
 	}
+	/* A failed xa_store() leaves nodes with no entry behind. */
+	xa_destroy(&tctx->xa);
 	if (wq) {
 		/*
 		 * Must be after io_uring_del_tctx_node() (removes nodes under


