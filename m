Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83722BF3E2;
	Tue, 10 Mar 2026 11:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141150; cv=none; b=L5+4vWBtjfGkRbJB6fUJoKkG57drSHWqu6l0MgvzgaAbEdS6tEllx/jIf2/RDTYFHKPxWBL7Ym/Fj07t8+vcPW5e12j8DOzxk0lE69mbJC8JN3wGVjK70vlZWSctlfAgERqfS0hzFbHHCLiggndUILrZUV8hwkZETNoKyggoFbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141150; c=relaxed/simple;
	bh=ZDXwzOlmMuGWr2psv5sKf6OmzobVpBYWZQIIdIvMzTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=igcj2YkjZyKtEJZU/bMaFSCzgvD37HmNlLmRoYChaFTfNRrKfri3O6TmUeTnqr49AuBcAaJWmRh9catTkOZrLDHnzdiNKHSEDvRgWxvTuLtyllN6vqA7c+Schizy5VIDb5pK9eTRM5K8NrMxSIFMw92x+yN1/YI+q+3SGn8dMwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDDFO2ct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDDFO2ct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A653C2BC9E;
	Tue, 10 Mar 2026 11:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141150;
	bh=ZDXwzOlmMuGWr2psv5sKf6OmzobVpBYWZQIIdIvMzTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDDFO2ct3K+FNRyKfya7mHnz9hDrJFTltDgDaznV8j4a4O0H9+TXhggQZyJh0ctMl
	 TXGP2zOBKZ3ypFI0N06wrpPRdfISGdpBaFpTJVlVhe7+q1kr+G5UfrD5dEinoywOso
	 LFrqfgIxXDcgrBvPphfwi08b2ISokvPD/q6IDZa1YyXrC3fEFJvhz1he4fj0SOnY3w
	 nj5poGdz1mAb1gEZXqpl5VMCZF/LmsvYkp8QnzkRFbHjYP9gh+JF39FlMZOFfC7BSv
	 ItOmTSk2FI7Uri7GZtawMO/aFIu5vmzjEWGkD3sz7RtyGhOxYRJ29zA4Jon4VeIDCt
	 y29pilpuh1kpg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Tuo Li <islituo@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 153/311] drbd: fix null-pointer dereference on local read error
Date: Tue, 10 Mar 2026 07:03:20 -0400
Message-ID: <c122b2486eeed840b6be5c5f155816d3befd12ab.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>

commit 0d195d3b205ca90db30d70d09d7bb6909aac178f upstream.

In drbd_request_endio(), READ_COMPLETED_WITH_ERROR is passed to
__req_mod() with a NULL peer_device:

  __req_mod(req, what, NULL, &m);

The READ_COMPLETED_WITH_ERROR handler then unconditionally passes this
NULL peer_device to drbd_set_out_of_sync(), which dereferences it,
causing a null-pointer dereference.

Fix this by obtaining the peer_device via first_peer_device(device),
matching how drbd_req_destroy() handles the same situation.

Cc: stable@vger.kernel.org
Reported-by: Tuo Li <islituo@gmail.com>
Link: https://lore.kernel.org/linux-block/20260104165355.151864-1-islituo@gmail.com
Signed-off-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/drbd/drbd_req.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index d15826f6ee81d..70f75ef079457 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -621,7 +621,8 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		break;
 
 	case READ_COMPLETED_WITH_ERROR:
-		drbd_set_out_of_sync(peer_device, req->i.sector, req->i.size);
+		drbd_set_out_of_sync(first_peer_device(device),
+				req->i.sector, req->i.size);
 		drbd_report_io_error(device, req);
 		__drbd_chk_io_error(device, DRBD_READ_ERROR);
 		fallthrough;
-- 
2.51.0

