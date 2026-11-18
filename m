Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056966;
	b=sZUjHu/DYCrbG3PfNEnHWrJNie2dCWuYDB/jiPerCpc1s/xIYTTX4BTItjuvARAVeGxv
	 M2vJU7khn/4ix+tdyUehb4nWmjkz9t+74fsI5ja9fl9xGHE2Cr3Rhp1clUByCby0NYjE4
	 m9qZii7K8oDnKnkVNiKkdibvr0H0ZAejGERAsV9VWUMNpSMqnU1E7iwsl4Td2ZQiIPhOe
	 xIr/r5KDUuQiyq3kNWxo7EOcL5DyVAwR+Qt7+G4tdC8G9/sbjxOOzA87rJjEwepUooGSE
	 onlfkaltKFro8kdnYgVfVCGJ35llLUwZeLb46/KnC786ZZNDpK8mu4jXICqB/YJbHYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0LJt8ITyDeMrtIiscaTzHEhib2hdPxrNbiIuExNKIzs=;
	b=u00fxg5geSgg2HRyDnbbHqsMJlPDBjgTsc68xttoe6rZ1mwpMTCpfnduCrtqWvwPyctk
	 lGYzCKmf4zViMOslykhyxBMMBm6wX2pfKxSF99ussNbCeoLmcdjqra+YNr1m9UApxULwO
	 Nt4PZwsvix7+jZmtUAc367TDl7HomF9wpwL42WPzuM7p8B33rZo4cBuUBMhz8fVM+gyt+
	 R+UUid1oYCdH2d1k7lw3ZGIPSGq28bR/2mr2hStqnKim9YbEI7oBMYapWsDtZp9xdvI70
	 Ol+hQm+F4TIdaZXutt88egQsF5elQFjq7mWP9FwtezccDZ5P5Ln07kUEcPgr7Cux+Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nnc5kc2w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F32606A320;
	Thu, 19 Nov 2026 02:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nnc5kc2w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1DE1F000C4;
	Thu, 19 Nov 2026 02:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056966;
	bh=0LJt8ITyDeMrtIiscaTzHEhib2hdPxrNbiIuExNKIzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnc5kc2w1YaQpwqsgT4o2ghPznK9KSGdy2o/YqFvv1pm1X3iQKmUeGdimtyfPkeWx
	 vwJ02EZqkUDm63tVuhP6l8s+6nC9NyBdSYE/+5+T3xbQcg4Y+GKkPsXYipEpsCnUop
	 VHZ0dSkGl14PNUCo5ZMWpJAJgpG7sNhHueOCyHvo=
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
Subject: [PATCH 5.15 2177/2214] drbd: take req_lock to skip the initial sync as peer
Date: Wed, 18 Nov 2026 16:04:13 +0100
Message-ID: <20261118150137.474332010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 157e952d71b55..4b35d74c68a1d 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4324,8 +4324,10 @@ static int receive_uuids(struct drbd_connection *connection, struct packet_info
 					BM_LOCKED_TEST_ALLOWED);
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



