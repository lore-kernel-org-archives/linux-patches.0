Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050823;
	b=uos0iqLB3En/6rs91nRfrbleS+5kHOdzZ5+o9iuO2ZwbKRVqEpgMyOtkqJT9VpiX1zTD
	 HP1xXbpEmmluAJ0ykS+b1DgLMCVbVQ4sYmsXEp52tM7phnhIuYZ4FpqUaDNft2mQ9VBw0
	 3Bmp61wm/owi3Cdvs4gCrnoc8Q+DUd97K3KyjZENrl/tgSewh5yTZzt8bbwvcSuDuZEnf
	 3usTd6a/nidNKnPDo6l9gTDpjS7XAUpP9cH80y+UOJciIBlZJSG/9veBVflXPrqxk7GCc
	 czTwynENOXcyH6SXY45XPo/gu19pmMrKCsG8uYq2OJM7vKhY9nielQL6vetApa5Cjxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DDqJwblDm/RO0FmqHC8qkcptE2RPwY5vnNASlJqCPFw=;
	b=hgzUN7BfosNgzsKaN98OhWBHDrDpcMoFxn6LP08ZeUnXyKuIjRQcKlmnGV+HY1ypT3j6
	 5ErV15rXvKv4uM5ql3TsqAusD/8Q9/+HHpiK/6pWN0s+B5Q3jwa4qL6zh/iAU/e65G6IS
	 6ijh0kEd4/VENFLMxOW75s+fj06S8i5nLMrQh8SxOb6cHy4OVnFO+dMAfusmIL+cRCZve
	 1+y9d2X7n1GQAnw70EAT3j1IC3/EygLraDze0PRi/tA/aiucyHITbZFel4KGi68P467N7
	 vBz1XmrvIzpHqO7bVDC3BhFxTqyI8Oqd4NR+q/6dqrf2GAKxH5nj74fWt3keWpY5dMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kvGgQNgG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9885E606A32A;
	Thu, 19 Nov 2026 01:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kvGgQNgG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA471F000C4;
	Thu, 19 Nov 2026 01:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050823;
	bh=DDqJwblDm/RO0FmqHC8qkcptE2RPwY5vnNASlJqCPFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kvGgQNgGqFwTP97OFayjLF2fFfzmLcfz7LT2dpdFApwe6qHMxmvlG4gDM+KdCwhim
	 2LzP8NQ3zeH6AU7c39hwqj6BYOg63XNgewgJ8gPaIEfIrlqljhGZGWH28e09/uY6Ci
	 qG4QvPOs6njP0fINIymEK2ca8WNFihMnJC3QyEKM=
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
Subject: [PATCH 6.1 2805/2857] drbd: take req_lock to skip the initial sync as peer
Date: Wed, 18 Nov 2026 16:03:59 +0100
Message-ID: <20261118150342.592150210@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c3dee6265ca31..9334daa0aac6d 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4272,8 +4272,10 @@ static int receive_uuids(struct drbd_connection *connection, struct packet_info
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



