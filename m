Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693DC23D7E8;
	Tue, 21 Oct 2025 20:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077206; cv=none; b=KyF8zpMi/CNY+059k/suZsWisqyvAerPVeqpMjk7uMqfuuuLqQWZlzI22+sRtwySJ7mtFPwxv7kbF2BlOTM48SJQKlAVpaa5n2vWo67PgsDSSlQTh9viIMtsRwu7ZSuYZkVz167sdJM+YWVzWVjSBGApNF2Nbsy74Jtj8DDOzu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077206; c=relaxed/simple;
	bh=wesZYuqPkBNvV9vlDt8USD4H0QxlllVvQy1r9pbiBto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ej6BMKxU6L1Rqy3TZwIRkOG7YRcS9Y/AeiP0lRgiibMRhxJkMHnhcExWBEBxzOXgOV0K+1VTkylZcpuvXn4aYPSEPRHE1wm2HEDetzxalCnYEFPfIKZbL0Zr0cgbnQbu0j1rr2eUwft1Fqqil+KQBwKOnpa03bNDLL9K/ZThwoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCg7OTHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCg7OTHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7431EC4CEF1;
	Tue, 21 Oct 2025 20:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077205;
	bh=wesZYuqPkBNvV9vlDt8USD4H0QxlllVvQy1r9pbiBto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCg7OTHL+07rO1UOf8oTOX8kcufRrZ7N7EQtxwb+/bhhvA3sslddkrL0MJUjEpnZE
	 LkoR3dT5zcjQ3g5IIcX5zyW+v3dos/dDZsc4+cILvh2pXNqAz4DoTFLTVxjTs5jYO1
	 ljmLDzhjDTQEOXvYB/mto5oiNJYhbriL2zxaxuXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Celeste Liu <uwu@coelacanthus.name>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.17 031/159] can: gs_usb: gs_make_candev(): populate net_device->dev_port
Date: Tue, 21 Oct 2025 21:50:08 +0200
Message-ID: <20251021195043.946772708@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Celeste Liu <uwu@coelacanthus.name>

commit a12f0bc764da3781da2019c60826f47a6d7ed64f upstream.

The gs_usb driver supports USB devices with more than 1 CAN channel.
In old kernel before 3.15, it uses net_device->dev_id to distinguish
different channel in userspace, which was done in commit
acff76fa45b4 ("can: gs_usb: gs_make_candev(): set netdev->dev_id").
But since 3.15, the correct way is populating net_device->dev_port.
And according to documentation, if network device support multiple
interface, lack of net_device->dev_port SHALL be treated as a bug.

Fixes: acff76fa45b4 ("can: gs_usb: gs_make_candev(): set netdev->dev_id")
Cc: stable@vger.kernel.org
Signed-off-by: Celeste Liu <uwu@coelacanthus.name>
Link: https://patch.msgid.link/20250930-gs-usb-populate-net_device-dev_port-v1-1-68a065de6937@coelacanthus.name
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -1249,6 +1249,7 @@ static struct gs_can *gs_make_candev(uns
 
 	netdev->flags |= IFF_ECHO; /* we support full roundtrip echo */
 	netdev->dev_id = channel;
+	netdev->dev_port = channel;
 
 	/* dev setup */
 	strcpy(dev->bt_const.name, KBUILD_MODNAME);


