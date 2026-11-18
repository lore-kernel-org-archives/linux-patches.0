Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022239;
	b=lzbLD3XB9GX4Ge66LdsGeY/Ah+E16d6PDrmr8NRVdI8ENvSqEntr/K2RXs2SAR63vnBm
	 kfjpzY3QPLjCG45uiIruy1LoZXoSGNt/pD9+4C+/lda7cdjWgb79WBpVzjsJdF0488+yV
	 midCNTXifIl4Xtt+8DNk0p/kvjZAsH/ycLFeCL0CwVwfFdmIEDW0LbQkTHu56CRyKiX+k
	 FEo0RI1nDLV0gW4xL1K7tyDO9gVg5uV68pQmHue43lYm6aWLB02YCGygRxeE3iCAWLDEX
	 GGRwkeQkoHDP3WNBUr5wfnpYu4poyoEGA2lv+d+3gDfYwu5jcpzYQCNMwc/qOS29QMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NNsUrz6JaPgg0KF6xhk5YatfT/K3bLElLTBkhDUrERY=;
	b=sLA5WFfDQyfi7UHU1irQoeCUGrOBgQc5lfxnDPT6fbb7IL56Fnjx+bjaXa9JCIhFBUmy
	 BocqRd2OagicDMYAEYVPGJtIzw9e6r2iPSS0ZtcJPsrtUOg8sv6/8IgpPJFLPrEErniIt
	 vnGD6uK5i3ZKNwt7Na/35QRJ+WZvWnIQvd56f4Y5bAONNXP6xT6I6I8uhMSeUCIEKcJfq
	 CQBo03zz8GFpyyTkRc3AUkVN0ciaTSt4eSJLXcfBhbKjLUVrOvIPJKkn5fpO3SOPj3MLN
	 g8xU8Qrft58b2xoqFXgqy2OisRWGdMU9Jz+64oDBOafUmO0a0uiECCGUxW7dKBwE3Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uQtd6JmI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0599D606A31C;
	Wed, 18 Nov 2026 17:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uQtd6JmI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1881F000C4;
	Wed, 18 Nov 2026 17:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022238;
	bh=NNsUrz6JaPgg0KF6xhk5YatfT/K3bLElLTBkhDUrERY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uQtd6JmIWxBiXOo3R2QT0M5b3LR8+P9Lq12f7gI9U9FnKMeNESOckMtHHADhpgKTP
	 1VpDm5t9xaRYW3KxYYyW9fC2Yi72wjmhREDFMeY3w+iSIyVvhxEWKvhC8qpYlmB/zR
	 8bIR4LUAKrSFCSa7jGL1PSU/uvTnxZqo8oYLDyd8=
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
Subject: [PATCH 7.3 2592/2651] drbd: stop the start_resync timer of a dying device
Date: Wed, 18 Nov 2026 16:03:52 +0100
Message-ID: <20261118150417.574394481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit a439d3fe3ec2bfe0b4ccb77973ae97949bcf46ec ]

start_resync_timer gets armed for up to a second and nothing ever
deletes it, so drbd_destroy_device() can free the device with the timer
pending. Shut it down where request_timer is shut down.

Fixes: 370a43e7982d ("drbd: Work on the Ahead -> SyncSource transition")
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: "Christoph Böhmwalder" <christoph.boehmwalder@linbit.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-13-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a2a841c892011..099dff1ea2565 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2163,6 +2163,7 @@ void drbd_destroy_device(struct kref *kref)
 	struct drbd_peer_device *peer_device, *tmp_peer_device;
 
 	timer_shutdown_sync(&device->request_timer);
+	timer_shutdown_sync(&device->start_resync_timer);
 
 	/* paranoia asserts */
 	D_ASSERT(device, device->open_cnt == 0);
-- 
2.53.0



