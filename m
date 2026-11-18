Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044690;
	b=gx41HaoviUvcpjgsO92Is4nNNowKDajxSIyfXJKAfkoZ+9CENClR0pQb8qwCcXcCInhX
	 mpTtFezPhuQ3e9YjgXb/jZkQ0uTYC+LgFcRw1GBTsfZ73b48sr7faZO3U9ifQBl5kOfz8
	 3Q/1tLkO8QtFa7vTt0MJL0MI7XP0Um7Zb4GIDvZGQPGEo+lHjCc43lO8JZ5443Dez+ztL
	 kKzGNg9pK5TsnbSq5FE89jiobQQNaJjbiMV2h5Yb12Dgz90rq9vfB6JnRhcUDsW4z+6qC
	 c93HrEzwWA71WxyEt6qU+AfxqJHJCmNpSEef7wsO8CZuPCPnpuaEB1/iI/tLPOcqFNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yu2R3pVY0h6WcP0Skwm8GRjJCApLEOx6sXhplq69WL0=;
	b=hGNTSB1mMipE2Cz1gF0rxXQTaWMC6r3XiZEemS3AQfVvrCj8kbJYQ8zIB/zs0EEeAOiI
	 ujOGT5OgcvRgufUfW8O0PAYbknqK3k87bc+QZUZyJLK9gqw3hgm9REX2nQz/LBl6X0Mou
	 /37FkPI5Hx65BUD8xSpSYS4B22QjSoM4zcdjxQCOFlqwM5NyJJ7Rz5aQI39N9AYgiAamL
	 Hu0eBjgU1yt52BP099pHDZzekT46Gza2H4hvkxuVxL7D4L56086GUzuy6W3AxV2/uO0eH
	 k0DdmGwjvcLPsfP44+pDxmH9PrzFTRwP0J0SFzNo/Pp8yhK1DFulD1DcafUcOM0JSKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPbhmSMg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F158F606A332;
	Wed, 18 Nov 2026 23:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPbhmSMg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524CC1F000C4;
	Wed, 18 Nov 2026 23:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044689;
	bh=yu2R3pVY0h6WcP0Skwm8GRjJCApLEOx6sXhplq69WL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPbhmSMg1P8+ReHcCTPBbYBhBgluREBp+VPFJAR93rnyYjeGRnKoe407jLTqcviqg
	 sqrX/CY5Zrh1FATBPQ2EUI25s81fLX4olkyAGXMaztjuHGQv6WQRUimVR+rwP6OOjE
	 vuswXWeaCBX072IAATzTNNgO/bgTU6/BbzPkwa5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0656/2857] io_uring/rsrc: charge buffer arrays and nodes to memcg
Date: Wed, 18 Nov 2026 15:28:10 +0100
Message-ID: <20261118150225.176936488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[axboe: 6.1 predates the rsrc node rework, charge the imu kvmalloc() and
the node kzalloc() instead]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -250,7 +250,7 @@ static struct io_rsrc_node *io_rsrc_node
 {
 	struct io_rsrc_node *ref_node;
 
-	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
+	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL_ACCOUNT);
 	if (!ref_node)
 		return NULL;
 
@@ -1068,7 +1068,7 @@ static int io_sqe_buffer_register(struct
 		goto done;
 	}
 
-	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
+	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL_ACCOUNT);
 	if (!imu)
 		goto done;
 


