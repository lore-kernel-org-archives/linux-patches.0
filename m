Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623412;
	b=BwjdZBK+Ab41kLaDK3N+LOrmO/0+zK/HYxAV9MmoY464xPaySDpNGcGAN0PDEPqAwX6g
	 FDYe0di2k7VGaeNwqdrsI51DAGF7phQRl6Ax3LP/tc1AA4xuw94pXitD1QgaceCs/YyZe
	 E19MKkKrqZNc5bukL9WHG0sJ/ZF/CSiJ6G128E0eQJNWRZftv4gpd9DWD5Nk18CnamNPE
	 VC7j8TzqzyxBXzWFWm/SC2q4InmFxHPSdoo6rQPTAbsDA+fybRQOVQ7OyYEz/JG/XcxtZ
	 hgJb68CFUhTQb33S34JG5ePO+n7SPxZIVaME75quEtplQfsg1n4lKxDRvgchK3xUbXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z7Dymvk8cCcBjPdVRh73sQP2rlDHyJb0SKl0k5+apu0=;
	b=WPVMMR6nrdcSeLLGedq+tYp3QxGjKUE4UF0XAG97i4aecEDh+zraxvDtiJnQ1uSN8iKT
	 bWB19tg99+riFIMDbk5xI25rrFOVFARJWwLk3iakGnDAxZryqCuD/jhv5eM2rQce3QQ91
	 LyRRdLxe+GRhYDeFJ5n1PIiYbZ1jToyf+8mvrz52t+bjRJlpcZgUOalmAXH8eQmaUIMB5
	 V09kfP0RCXCDgrNcsD4HbqhRFxLsXYoz/ogKjsEvTmNOj62FGIuE3rSrAiBaSyR4hpsN4
	 9sEQTM6pEDtJRR9r/A8ppZyiO2KMv7vVgGnFqaBy2WhWsHqLSNej91K7CIR1IvwNQhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E59bxnGw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAE2606A326;
	Wed, 25 Nov 2026 16:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E59bxnGw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5854D1F000D0;
	Wed, 25 Nov 2026 16:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623411;
	bh=z7Dymvk8cCcBjPdVRh73sQP2rlDHyJb0SKl0k5+apu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E59bxnGwGD66qQ5SGdbD3cAvy6SxM95Q6xXJh9l2l7HLCda6YkEE5fBEJwCfOpEhA
	 IvY4emwrxAYjpNJAyFOQ90KiZZY32DeWKriiZWZJBqbgBYE5q0qmuRFkDaBEDWLqek
	 D9cq8aKW3xCpGcbeGrI4Gll08zqfe2v2To9bL3VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Tejun Heo <tj@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 851/990] dm: fail a REQ_PREFLUSH bio with data when its preflush fails
Date: Wed, 25 Nov 2026 15:36:58 +0100
Message-ID: <20261125143841.962160441@linuxfoundation.org>
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

From: Daejun Park <daejun7.park@samsung.com>

commit e92cd41e8e5ee5616c6c7cd4378661d942f0a7c0 upstream.

For a bio with REQ_PREFLUSH and data, dm core may send an empty flush
first. If the flush fails, __dm_io_complete() still reissues the bio
without REQ_PREFLUSH and drops the error. When that write succeeds,
the XFS log keeps running and fsync() can return 0.

End the bio with the flush error instead of writing the data, as
blk-mq does.

Fixes: 6a8736d10cb4 ("dm: relax ordering of bio-based flush implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -983,7 +983,7 @@ static void __dm_io_complete(struct dm_i
 	if (requeued)
 		return;
 
-	if (unlikely(requeue_flush_with_data)) {
+	if (unlikely(requeue_flush_with_data) && !io_error) {
 		/*
 		 * Preflush done for flush with data, reissue
 		 * without REQ_PREFLUSH.
@@ -991,7 +991,7 @@ static void __dm_io_complete(struct dm_i
 		bio->bi_opf &= ~REQ_PREFLUSH;
 		queue_io(md, bio);
 	} else {
-		/* done with normal IO or empty flush */
+		/* done with normal IO, empty flush or failed preflush */
 		if (io_error)
 			bio->bi_status = io_error;
 		bio_endio(bio);


