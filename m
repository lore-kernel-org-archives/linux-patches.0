Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035677;
	b=x1Q1OZ/gBf2Boe/kwJph+ErFpZnRVR4Najp28nd3+DOMKOuXIy6xWlDmnvq7ph0sLcWY
	 7o2+3//tAtpl4F8rufIRRDaWX6oumqNNurgsp8Hm0OE9QgzpjASTmghfQyGY3wXoPWzpd
	 IAoNhfsqXOs4hkZ1nXuOWSa4O+5tQqaTFKFkDwh6xH+W1mMjmfhv7GkKXxnVlbAt2WDiI
	 vOV4flg9OsLo03liVE3hT1wK4IoYJCGnT9+N6saKxiN2qu6nO/IIjoVJpHAvZIcG2ncc+
	 U2IokZ+BKyITD70YIFD66rmLFGe1fcP/8a3x07+NJxq39ohPLJ6JcIX90rhUOtOVrPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AuwYlVLI9vUvJOg6EJyFfVQACZ1I/uvUNf+S32RT+/E=;
	b=Nvrtzgq1Qo+KbkWeyWFoTTDZ8YljsHY17CXAgy6gMqQYdm9M2pKjgYFqnqykXtQcWnsV
	 cWu7/DAUWvYq7etgl6CwcMTpCh9CsTQZQT/7BCCdJ/o2xuutaj5KQK7SzUF5TgUmGRPFF
	 b2Ev+sdl+XkfBHARjUOqOWgB+p4I5TLn8CZHvbY3JsI/uZes6AH1/i1XE9ZQqX3nAizsC
	 ae7vaKIseAoXBFEguHYiJbaIYaPiUKxjKIkBkLOaePM4Iu255utf0ButFqHvivTL5RbNi
	 t76hKGnCle/vQlK3b3Ux3DeEl6R1bZ1JFDJ1vNjCh3pd8Rt2r7et9dBtzjliEzUVMEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I7XUq4aZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767C160A2610;
	Wed, 18 Nov 2026 21:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I7XUq4aZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53901F000C4;
	Wed, 18 Nov 2026 21:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035677;
	bh=AuwYlVLI9vUvJOg6EJyFfVQACZ1I/uvUNf+S32RT+/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7XUq4aZ6o8R77TQb8ldMDNIoENGMB4FyRK/9m6ynbC2RgVJ7aR1RO6mZgOQVJMku
	 NKvblPxAcyqId6rMZRW2lUIuJC+trV5tTyCXNov1c3I9N7B4dCItYQYW6ho2CyPWh7
	 KYxz0UCybDE843ISowyok+0caYIhhhqq7ANi354U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 0748/3318] io_uring/rsrc: charge buffer arrays and nodes to memcg
Date: Wed, 18 Nov 2026 15:22:50 +0100
Message-ID: <20261118150341.073326241@linuxfoundation.org>
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
[axboe: 6.6 predates the rsrc node rework, charge the imu kvmalloc() and
the node kzalloc() instead]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -203,7 +203,7 @@ struct io_rsrc_node *io_rsrc_node_alloc(
 	if (entry) {
 		ref_node = container_of(entry, struct io_rsrc_node, cache);
 	} else {
-		ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
+		ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL_ACCOUNT);
 		if (!ref_node)
 			return NULL;
 	}
@@ -923,7 +923,7 @@ static int io_sqe_buffer_register(struct
 		}
 	}
 
-	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
+	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL_ACCOUNT);
 	if (!imu)
 		goto done;
 


