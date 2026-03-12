Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622A82D0606;
	Thu, 12 Mar 2026 20:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347046; cv=none; b=RSi38hIuVtlsMv8mpQJhVfrYREI4fHcc2rz07g/YnjR80mi64RzIh04TyEJ0VczSPrh1yBNFu3I2V+U4tgtIAl5OJekgtya/zfzZtiErfuyz/FkVQAvPklQFx7GnscMadHUx0orsvnOk7oWDcFnQgGB+CaK0rZ+39aWkqjhQjn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347046; c=relaxed/simple;
	bh=vU/t1NeBrlOLoL4KhhjRtGXGb6tbugrENJoG84nFZZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=onFhMKJk+eS90U6NsTyBvqP3yIVVIh5JdygG70vWDp/YRDDkEMY2nrA0jc0tCjZzmxKN45HpVSH0uv7GCUkCbFNVUvi7tDxcaK87AHARoRHQpZ7mENYyrmNmqaUS/OxSFCzaoHAxBlIbqtFMIfmLtvCoGRGRw+upNvlFOSi8SLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKCJbpzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKCJbpzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38E2C4CEF7;
	Thu, 12 Mar 2026 20:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347046;
	bh=vU/t1NeBrlOLoL4KhhjRtGXGb6tbugrENJoG84nFZZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKCJbpzX1dKPCJPJS53gH1vk8IgLS/XAs99sdH1ZYTi4D/eze6048BtZk9iqVL76i
	 EhcCnBl+Z3fbD4wqT1iUx2JUwPcvA7qTYtQfC2PhcFGye61XUrW3ugEwkZmM94NxjV
	 IQ+/q/UQOhbJ7RMz+Snkk05cFKQf6HXudv8SFosc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tuo Li <islituo@gmail.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 156/265] drbd: fix null-pointer dereference on local read error
Date: Thu, 12 Mar 2026 21:09:03 +0100
Message-ID: <20260312201023.905736628@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/block/drbd/drbd_req.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -621,7 +621,8 @@ int __req_mod(struct drbd_request *req,
 		break;
 
 	case READ_COMPLETED_WITH_ERROR:
-		drbd_set_out_of_sync(peer_device, req->i.sector, req->i.size);
+		drbd_set_out_of_sync(first_peer_device(device),
+				req->i.sector, req->i.size);
 		drbd_report_io_error(device, req);
 		__drbd_chk_io_error(device, DRBD_READ_ERROR);
 		fallthrough;


