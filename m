Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042694;
	b=IGZEB28iWg9q7ft9HTKWp8QTglrLfLOpsqUFhNPoY5ANbHaceM3c/SpDjKe/mUn47bb/
	 GbrN7g+xwPcRRxHaYk7aKAEpXNntFUO+YeC35DDoxEWslNuJovg0RLNGTDqz40Re4w0jI
	 44KnDyuSfsT4kBf7W01vANONqdgeb+zkMRpJlZ93URmhT6x3hcEBv2KzmO+D8xLMofBO+
	 r+Z2AfxmWrFD8eLAsrI8cFZRHnFAgSa1yBZ7h5DGp1tH4IghhCBmq5cppxpwsDPOpibgI
	 +Tf96oBlUP2ECv78jYBLsxv1c0O+BLRaGxBJ5O4m2kb1I5xEMQOSku0SaUI7wSXEFDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=o7J9JAyHu75OdwoMli/a7OTSC6qNgdyCJ78SxIM08pQ=;
	b=PAFpub9RWrBjWKJZo9JA3D43X/7YvLyH/IbAMEgUMunvwYihvipGXf52DBvEadkoTElk
	 IWokky3T26ceEMUQhT/GDkaaJJ33OVwdL+Kd8EzhSKDTMcLv3eIZwoWUOKjqXFojpH337
	 U08nUTwdY8A1LYwEMtpryRlcnHW2wVEHMgbKNdg3m90eHpk/UCpM9n2o7gd9HQwsn1PsQ
	 3ltSy9nKhqIA17Rj7IyBGREHHIIOnhvD3D/o960Uwal0mIwHMnUGbxddAB/lsvNWvNpR7
	 yldB8SZ0PiOMOPTvbIc5HT7OvGzygI5mttqNgcQ4xBhFVj4xjXqeKtnLSVf5eoBlrdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zws5lu6x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBC5606A31C;
	Wed, 18 Nov 2026 22:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zws5lu6x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855621F000C4;
	Wed, 18 Nov 2026 22:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042694;
	bh=o7J9JAyHu75OdwoMli/a7OTSC6qNgdyCJ78SxIM08pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zws5lu6xgzHVvmf1gjDierfFTEmnTBZcVSNqut6OyrB1GQacwTDIv5i+TpTR7O1eY
	 F+9oQnU4UFqgRWEXlSQEePjgyTsvpZBLBUShUPcMnCT6V88VKeoF4P7vmS3LsVzydx
	 X1ZTczH2A/W2Yk/feNaRfhoaOoxxY/I7TCFNl2/4=
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
Subject: [PATCH 6.6 3262/3318] drbd: take req_lock to skip the initial sync as peer
Date: Wed, 18 Nov 2026 16:04:44 +0100
Message-ID: <20261118150457.478129509@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f85ebdc3cff6b..1f3760bbf15d1 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4284,8 +4284,10 @@ static int receive_uuids(struct drbd_connection *connection, struct packet_info
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



