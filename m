Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061851;
	b=bKahM8Y+lujO/4oz+xYdrqQ/HmjzY26szF4g3+IjIFC4kPa+6ewdPEcyF8z6wEyFcdQd
	 hl6Gjto8vhI4QUrEwmukMpkJVThxK5YXft1B9DLjiahCfvZrNMLtH2MXcXysPy5sG52bV
	 joAa4KgtV7i+BiExJC6W2o4dQ3CIt/B3pmxbqNEMaByTCQLKgcj7WxtgCjx8D+2ykHxFB
	 29albNU+O3jpKGsaoj/xnFyzeAqL4ddxHR/5c9T0y/zMLajvpskXH70kSMYUmKYd24vLk
	 5u/euPzCezo1Mtcuv5SOMZMUdp1KVIim2n7wYFY7oIgaoKjlTYII+q+Jy3EPW75HTtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nKAIahiZbrCE/+r1sPjrmxemb42bILo3T6UhhxmBKrI=;
	b=Nmsugk0Hlc4BMApr0Rn0bPnepDCh3/eI6ap616cya6OnbtIrcfcCulDlvphmknYj83g7
	 bHl7rFY48+IAdFGNj1qXIOPvDzQ1Atz/kDTHjHBWCUP+hHwHRFaMmf63LXVYrqCdW5Pjv
	 x+9rAf9IARMrDSp6bGrLE2I0AsnxJ+MElIqYAOQTqBQpO9ks9yWxntaIdbUHtN//dzX/K
	 PJY+qsizQMAkcXo6tWUk5h9wrFmwk9eVBWoXLIhutQzW3j1EzcCsZZSLPzjazZNucGIWX
	 4ja+UqD0zV7rx2GxJxfQE/j7EjzAixDlGT4fVcyMrWcN52Icv2sukqDza9EZX9tirHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Pg/91o3H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B042606A32F;
	Sat,  7 Nov 2026 14:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pg/91o3H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3894A1F0089F;
	Sat,  7 Nov 2026 14:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061851;
	bh=nKAIahiZbrCE/+r1sPjrmxemb42bILo3T6UhhxmBKrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pg/91o3H2Z5BfkDwqzdYg3wMvVM7piSXhGZzPnnTjRbi++PBEm1vYl4C8isrT1qJs
	 dJHVVXqkBSMpgjl4CbzmD0sMG1H/S1CuE+Xdg9DZrh/5CNaUXa+bFkkx2yqeET6quk
	 0A7jWZ97nZDQ4z3oWKTQBRes5eo0099ML9rWz7sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 0832/1536] io_uring/rsrc: charge buffer arrays and nodes to memcg
Date: Sat,  7 Nov 2026 08:47:28 -0500
Message-ID: <20261107135020.916375374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

Commit 075d5837bafc317e796548f721b8fbf7add6821d upstream.

The io_mapped_ubuf of a registered buffer has one bio_vec per page,
unless the pages coalesce into huge pages. Huge pages only count against
RLIMIT_MEMLOCK once per ring, so a buffer that maps the same 2MB folio
over and over in a way that defeats coalescing gets a full bvec array
per registration while only the one folio counts as locked. 1GB of that
registered in 100 slots took several times a 64MB memory.max, with 2.6MB
charged.

Allocate the io_mapped_ubuf and the io_rsrc_node with
GFP_KERNEL_ACCOUNT. An object reused from the ring caches stays charged
to whoever allocated it first, same as the io_kiocb cache.

Fixes: de2939388be5 ("io_uring: improve registered buffer accounting for huge pages")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[axboe: 6.12 predates the rsrc node rework, charge the imu kvmalloc()
and the node kzalloc() instead]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -183,7 +183,7 @@ struct io_rsrc_node *io_rsrc_node_alloc(
 
 	ref_node = io_alloc_cache_get(&ctx->rsrc_node_cache);
 	if (!ref_node) {
-		ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
+		ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL_ACCOUNT);
 		if (!ref_node)
 			return NULL;
 	}
@@ -982,7 +982,7 @@ static int io_sqe_buffer_register(struct
 	/* If it's huge page(s), try to coalesce them into fewer bvec entries */
 	coalesced = io_try_coalesce_buffer(&pages, &nr_pages, &data);
 
-	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
+	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL_ACCOUNT);
 	if (!imu)
 		goto done;
 


