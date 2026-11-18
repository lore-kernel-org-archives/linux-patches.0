Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062174;
	b=pSzQiFtV9WaJqAYAXnfb0z22jp+h9coG1M+s0Yh/PVwItqJ8BsK+5h+lAWgt5+uQQRtF
	 FwiE9tyoWtqnm/MCQqvdT4yHpPlQH6az6Z6v/ClgnTC/+KEqW3j6wzMUSMIe9t5mKZdxa
	 ou8HN5oU0FLhA7xNc639+MiTuEuIKFW99YoY1CFF+NzW1wPsZOAwOpLyoNl0qmvilylg3
	 PcymWahTFmM0QMwG3JA+D/eMxgp+B6d3+UnjX3zq8s5xC8z/AEAJ6ebNvwOYN16B8UT7o
	 5o2vmDZOxBJtKHWDk5gGu1OBL/91E/IP+L9GLL4pvAAcLaP88rgakeWna9tgiByIi2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=e1FtrnZRI0FGwpL92UC59WCvSSF5GZNnb7ayEzRsYhc=;
	b=GXZDRF98/4lnFXr9SdJ491dqzDKTCpDvdclbTghx3A+DZpUs81455MDK5cbi469S5ME0
	 Nk1+b4+pM/pmh06ry9clUePzbM2sne5oitp7pPWPFHacoTkF0IkBvj40MIa2WY9/upiiU
	 q77dD5oelu1akHtgKytGn9BV8urf4SeTdZtL/ba/Ryt7JQ/cpGC+icW8ZYeSG9VIf74Kp
	 xvtvc8cl0Zvta3KnkLV958vIInD80Jv58kQeCbztCLV2TmXw4sRbYvmYFakB7nkvG6Vct
	 MIhj24xtcC3exuOLQEK9nA8kDjQNFw0mipXHYOe2ssnfdPgh7kzw7osW8kShRuMe2vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w7qHFZ4u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A0860A2628;
	Thu, 19 Nov 2026 04:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w7qHFZ4u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA7B1F000C4;
	Thu, 19 Nov 2026 04:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062174;
	bh=e1FtrnZRI0FGwpL92UC59WCvSSF5GZNnb7ayEzRsYhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w7qHFZ4uf4gM7qKmRsxNmp5nIm0ynzMAwlNP9mUfv6erTCH9+2jfAJ2Mcv14//sM6
	 Qm8PQ35m2p856k4sOhxov3u1lR40l78CIAd7sCLXuAGkh5BTTRvOPKWvLrYZv6IF+Z
	 xBbituchMCaZHIAQF2f5h7rb6kC2J0AHXy7FN6aI=
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
Subject: [PATCH 5.10 1814/1848] drbd: take req_lock to skip the initial sync as peer
Date: Wed, 18 Nov 2026 16:04:12 +0100
Message-ID: <20261118150035.422799779@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 576a28d14c3dc..b3a965ff2263c 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4331,8 +4331,10 @@ static int receive_uuids(struct drbd_connection *connection, struct packet_info
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



