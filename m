Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028266;
	b=ZMfRZg12Cvq0slVKe+1dvNikG2WbipGS+Savs/UTKcjLQwTUNii3FPGfcO1npnXONdQy
	 rtACagjZKyar2quFvEdcSme43GZ8e2aO/dlHELq3xzmNlb96kYEVx4zDP2MmW14OM44K2
	 TT0OJ6dPXRWN9NUvSV5EqTR2IjQ068GCLxP1lbsVE6WPju42HTePwsYA1WPVAFFjHsDl6
	 Cie5vvD19UUMNWNOyTBzife3Xj4bfs/r11D2RXeuYZUZLuJRFFUcIijoC0Zy1I1Tc3aVL
	 IwA6Hq9GKsCv/WLPWuDm82cxwbs0IECCHj5aKc5x4m2wRa7QrcFgWBcYXYTW2ZGzFYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QMZHcQcHmptMikcIwTk8iaX/m6ciGXR7qfHkuEJwMiI=;
	b=bfQnw/pa6Ebs5NpxVfOhpeTRlcyrSqRFgz5tfSGzjxVEQUtfegUMfZq/ntB0WiALm26O
	 PSY8d8956Ey7z/RpnOlYTt7EgH0m1et5YXBkISj98ZgfXwo1STZLYnnUbFeBnsxn3vzc8
	 s8omWBIjbUhPJEZfTYLMJNoJkXmxee9tY2wlFBlXCZjm81KxB1ajfH6EYKBZysyaIrUUq
	 h8fCUdvFCczdkKeWU5i3uINwkRYAZQcOPP3gwtuuKerm34TZHx2ZlpubrNSgtKO6cvRjM
	 ozUXw2FXBpjEUgZpniXqA6L5GB3y9kN39UzY3RRWToGNbJutRV9pRqynP5/v5e4USwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lgHlhgAl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51DA606A32F;
	Wed, 18 Nov 2026 18:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lgHlhgAl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9021F000C6;
	Wed, 18 Nov 2026 18:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028266;
	bh=QMZHcQcHmptMikcIwTk8iaX/m6ciGXR7qfHkuEJwMiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lgHlhgAl2uVpNoaffGr8aLS3KeJO92Nc/1DRfEIVZjznsXmgv1hUb9LO5W6flz7fu
	 BZ9EDGqN9dPqJl8HDdC8DkvlpM9N7988UxTec/k+sSvBJxtP93KAjcirsGj9LYZIV1
	 mksdB8GPuv96m0KHr2JS/xmbnWWTJltrY1J30pP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2082/2151] drbd: take req_lock to skip the initial sync as peer
Date: Wed, 18 Nov 2026 16:03:37 +0100
Message-ID: <20261118150237.552014442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit bf7fff620c890a7ee0b444f1c7e9f0d1263a30ac ]

_drbd_set_state() must be called with req_lock held. drbd_adm_new_c_uuid()
does, receive_uuids() on the peer doesn't, so a concurrent state change
gets lost: the device is Secondary again, or its failed disk UpToDate,
while the work for the lost change is already queued.

Fixes: b411b3637fa7 ("The DRBD driver")
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: "Christoph Böhmwalder" <christoph.boehmwalder@linbit.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-15-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_receiver.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index acac73b75c7cb..2e8a6f836a388 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4096,8 +4096,10 @@ static int receive_uuids(struct drbd_connection *connection, struct packet_info
 					BM_LOCKED_TEST_ALLOWED, NULL);
 			_drbd_uuid_set(device, UI_CURRENT, p_uuid[UI_CURRENT]);
 			_drbd_uuid_set(device, UI_BITMAP, 0);
+			spin_lock_irq(&device->resource->req_lock);
 			_drbd_set_state(_NS2(device, disk, D_UP_TO_DATE, pdsk, D_UP_TO_DATE),
 					CS_VERBOSE, NULL);
+			spin_unlock_irq(&device->resource->req_lock);
 			drbd_md_sync(device);
 			updated_uuids = 1;
 		}
-- 
2.53.0



