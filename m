Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A0415E8B;
	Mon, 30 Dec 2024 15:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574345; cv=none; b=B4+EGpIbMiLYL4ykWwOQZVYfkqUbRRv+7Wxh6bQJQflQhceIR559/233ITRUwt1L7Wp3ake8DIreoPfwbHhaOq/zb7Sy2+E3Ja0Rw3bxbi2+1rNPZyrbyQRYh6w/f1HocvDUs3S4mckEpra2ol2+tunTy7vh7qqc6I07RSPyQIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574345; c=relaxed/simple;
	bh=WXepx4IEsOw9hCxT+Iw4chhTxkin61okSGusZxaLORM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnTsyOzTmWy91/ydOF1TmAc2l2GVoGpRTZR/FWYdZSkeUAJWsHWlEfT7MdHh1HBr+3GRVAKqvcoKQbLFM8WwZCVhIUVdbqD0dYWBiNUwFTj0dGMGZzv0/fr3w2ZUeam/S7ViHaEU5wTVeaJ+iP9ksti8u2ymuiOELNWWcCQAvdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvhtNO5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvhtNO5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83CAC4CED0;
	Mon, 30 Dec 2024 15:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574345;
	bh=WXepx4IEsOw9hCxT+Iw4chhTxkin61okSGusZxaLORM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvhtNO5AajKUktxFabOulB9MaKQnpMsDPj/5CdiNukAn2eZpmGlM5rE7tsUvyxkro
	 1oY8m2pJwmcyzjkDA8SV01MHPdxw68uVJ3juM7UeWFxlHow9WwE7mSWPNyDcaIAwDD
	 XteW4gzBd0GheLpgD1OMPp11ZwMUS7cLAg8QeepI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Fedor Pchelkin <boddah8794@gmail.com>
Subject: [PATCH 6.12 109/114] Bluetooth: btusb: mediatek: move Bluetooth power off command position
Date: Mon, 30 Dec 2024 16:43:46 +0100
Message-ID: <20241230154222.328240171@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Lu <chris.lu@mediatek.com>

commit ad0c6f603bb0b07846fda484c59a176a8cd02838 upstream.

Move MediaTek Bluetooth power off command before releasing
usb ISO interface.

Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Fedor Pchelkin <boddah8794@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2734,11 +2734,14 @@ static int btusb_mtk_shutdown(struct hci
 {
 	struct btusb_data *data = hci_get_drvdata(hdev);
 	struct btmtk_data *btmtk_data = hci_get_priv(hdev);
+	int ret;
+
+	ret = btmtk_usb_shutdown(hdev);
 
 	if (test_bit(BTMTK_ISOPKT_RUNNING, &btmtk_data->flags))
 		btusb_mtk_release_iso_intf(data);
 
-	return btmtk_usb_shutdown(hdev);
+	return ret;
 }
 
 #ifdef CONFIG_PM


