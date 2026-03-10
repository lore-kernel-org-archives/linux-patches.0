Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538A23876D7;
	Tue, 10 Mar 2026 11:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142055; cv=none; b=nlToIg5pFPkHtlLtvUfO9Y58GBgq5sfZ52Gh8tlrXFVmPVrInwDBl6y0Lgrih6MUEGAxDlCID5BNZRFjyqXl6IOxvjJBBbXoGtDVZNd8t/z1XysKigJEA6uUgPyR2Z0UQM3rOqkFh9K1/Vt6JsHOiCTz0g98RBgcukcynR1NwRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142055; c=relaxed/simple;
	bh=ZDXwzOlmMuGWr2psv5sKf6OmzobVpBYWZQIIdIvMzTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YjCS6awqtaBnctkLk2jysN7jjQ7bX0aEJNPJwKg7KsYjN5VNVcVJK5Noyc3l8kOMEVH/pWIDBvIZTfDPVH2dsqnes9ILGKnRwRa+Y/1zHD6czItiIXmSoQLJssFbqZhAfL8GigLc0R9oPcE4ySp8T+EPzll9KerVahtRyjhwEJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDLYNOfZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDLYNOfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848CEC19423;
	Tue, 10 Mar 2026 11:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142055;
	bh=ZDXwzOlmMuGWr2psv5sKf6OmzobVpBYWZQIIdIvMzTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDLYNOfZ7T+8iyCC96af/0w4NwjRP8ve/Ev3OBIzhe2panLBunWe0JJEritNcihiz
	 FO/0zLqpSfahew8cND2UMT0wN2ZxL3xrcwyeL+Tt2D/8ZYxgHLdYwzhoNmvvrFjAfb
	 Mm8E2loyYMV/BoR1Y8yMdVU/vW5pLWmb17gZvbuV+XQVEWVq9NnEWjoP2L2v6tV2D9
	 RD9RJzXGYk+RmnlGvERmTxfVoBsHJ17prnr3zGsjR9VjNZNk+CaWxDNNFSqqRl2dA8
	 uvIj8vg6VFiCTdxoMrcwWQ3yuSGA+GptkHlwCVWq7rzI37bpYoWOCJ5RrQB6YLfaVC
	 MyMNRxTLMZFwQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Tuo Li <islituo@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 181/314] drbd: fix null-pointer dereference on local read error
Date: Tue, 10 Mar 2026 07:17:20 -0400
Message-ID: <698bd96e70106ccf9ada77928ce3a35a7e8aa58f.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

