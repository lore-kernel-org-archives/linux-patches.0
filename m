Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE59426F292;
	Tue, 21 Oct 2025 19:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076509; cv=none; b=IjfdKvNLRYBtwEd+r/0no3UrGHrx/fOxH3uKC6+hh1C7EUOLexYdeSKyOn8/Oz2t1mpi4VgcIYyUaMs4Fysr/rMCuSGpEXNFWsVPc8fVP/+9gwp6+r8kgUeMKEJw1X1xQg5Lo32YQKchSYKiVrwQTfUeFI2mVWveRurL38NNkPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076509; c=relaxed/simple;
	bh=DaOcZU/AK1GyfOlC03vltmIz+RmqV13vX9lg6UBuV0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vl36uuH719yZv47wU0y1i0tcyKZf3jUMgE2BLQFoBc/2bE9LJQkKvRL54mkMSbBxcUMiSk6ieonte4cTNdxjDvfplXUorz5nA0mAV7ZaEvQQa97hPDDHwVOiwpJ4TwkV0J11vV1RWfoPEwnmqEozpSnc46aQBrxoH5KTRs3ol6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDE0HEqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDE0HEqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED6FC4CEF1;
	Tue, 21 Oct 2025 19:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076508;
	bh=DaOcZU/AK1GyfOlC03vltmIz+RmqV13vX9lg6UBuV0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDE0HEqC5WthDzvaU1/OPACYbALYGEZisp75fKz9wA2JifEco+anWdj5aorsfU1Yp
	 /67xup7aUvpFnN1TOGzDRxzaGpSLoumVJUEH33QjZ37TShkUHbVsU6KYtzzQyK2NnK
	 IB7BOAeekKbPLd8u8FvpnPE1lK1x/O4avNEppwmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Celeste Liu <uwu@coelacanthus.name>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 011/105] can: gs_usb: gs_make_candev(): populate net_device->dev_port
Date: Tue, 21 Oct 2025 21:50:20 +0200
Message-ID: <20251021195021.759577337@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1246,6 +1246,7 @@ static struct gs_can *gs_make_candev(uns
 
 	netdev->flags |= IFF_ECHO; /* we support full roundtrip echo */
 	netdev->dev_id = channel;
+	netdev->dev_port = channel;
 
 	/* dev setup */
 	strcpy(dev->bt_const.name, KBUILD_MODNAME);


