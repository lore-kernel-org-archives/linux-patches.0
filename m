Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEE11EF085;
	Tue, 17 Dec 2024 17:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456194; cv=none; b=mIqKOXOeH/L11N5LbsgfG+f3/m3iQ4AeqEkGmY9aMB5PJyo4NIp9RSMIW59awnD+QeZ1C6dZKIgHoCmtV9BgHpVlfAu0yEh67YllFilLxnDApu/h+rTh72TUP/1jAI6mXCaY6Hhylq83QxNfQYivMU3KtUOrqHkgPcFWw/45IcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456194; c=relaxed/simple;
	bh=OgqtylmaqfN4svNcMOr1+DWJNH87mGblrzhzK3VyL6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lXe4RqsKOJVLYTNLavzj2Ul+YdEPxxOC0VCklpxClXw66dLCQPyJFns8CSGgSyfqAC5M+HCHFlsffnp9wttd4b/hywgSmHZiFOmolzTfbIK3OEnZh0qtqkr5hWByJdwBilkr64vVHt99aDRWZ0kAm/mDTDsYKmhJQ4PHZjWJ2XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Goiaihn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Goiaihn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7D8C4CED3;
	Tue, 17 Dec 2024 17:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456193;
	bh=OgqtylmaqfN4svNcMOr1+DWJNH87mGblrzhzK3VyL6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Goiaihn3nGFE8a9c/Nngm2ALEq9ISeBeXe7X+mFoom5O7B0dxf3zR98vuSHPnfzW+
	 Yd/KHZFd7wNr1BAaDHsIYhPzQx37ft6kJv3ZlQCDSuDKZL86oXUZ7jLQz9QIKLlbtd
	 UDJCMpLAMG/9TKTPQEOsi7TB8J3A2ni/aVRllBNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Danis?= <frederic.danis@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/109] Bluetooth: SCO: Add support for 16 bits transparent voice setting
Date: Tue, 17 Dec 2024 18:08:13 +0100
Message-ID: <20241217170537.100796128@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frédéric Danis <frederic.danis@collabora.com>

[ Upstream commit 29a651451e6c264f58cd9d9a26088e579d17b242 ]

The voice setting is used by sco_connect() or sco_conn_defer_accept()
after being set by sco_sock_setsockopt().

The PCM part of the voice setting is used for offload mode through PCM
chipset port.
This commits add support for mSBC 16 bits offloading, i.e. audio data
not transported over HCI.

The BCM4349B1 supports 16 bits transparent data on its I2S port.
If BT_VOICE_TRANSPARENT is used when accepting a SCO connection, this
gives only garbage audio while using BT_VOICE_TRANSPARENT_16BIT gives
correct audio.
This has been tested with connection to iPhone 14 and Samsung S24.

Fixes: ad10b1a48754 ("Bluetooth: Add Bluetooth socket voice option")
Signed-off-by: Frédéric Danis <frederic.danis@collabora.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/bluetooth.h |  1 +
 net/bluetooth/sco.c               | 29 +++++++++++++++--------------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 4763a47bf8c8..c25f9f4cac80 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -123,6 +123,7 @@ struct bt_voice {
 
 #define BT_VOICE_TRANSPARENT			0x0003
 #define BT_VOICE_CVSD_16BIT			0x0060
+#define BT_VOICE_TRANSPARENT_16BIT		0x0063
 
 #define BT_SNDMTU		12
 #define BT_RCVMTU		13
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index fb368540139a..64d4d57c7033 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -267,10 +267,13 @@ static int sco_connect(struct sock *sk)
 	else
 		type = SCO_LINK;
 
-	if (sco_pi(sk)->setting == BT_VOICE_TRANSPARENT &&
-	    (!lmp_transp_capable(hdev) || !lmp_esco_capable(hdev))) {
-		err = -EOPNOTSUPP;
-		goto unlock;
+	switch (sco_pi(sk)->setting & SCO_AIRMODE_MASK) {
+	case SCO_AIRMODE_TRANSP:
+		if (!lmp_transp_capable(hdev) || !lmp_esco_capable(hdev)) {
+			err = -EOPNOTSUPP;
+			goto unlock;
+		}
+		break;
 	}
 
 	hcon = hci_connect_sco(hdev, type, &sco_pi(sk)->dst,
@@ -876,13 +879,6 @@ static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
 		if (err)
 			break;
 
-		/* Explicitly check for these values */
-		if (voice.setting != BT_VOICE_TRANSPARENT &&
-		    voice.setting != BT_VOICE_CVSD_16BIT) {
-			err = -EINVAL;
-			break;
-		}
-
 		sco_pi(sk)->setting = voice.setting;
 		hdev = hci_get_route(&sco_pi(sk)->dst, &sco_pi(sk)->src,
 				     BDADDR_BREDR);
@@ -890,9 +886,14 @@ static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
 			err = -EBADFD;
 			break;
 		}
-		if (enhanced_sync_conn_capable(hdev) &&
-		    voice.setting == BT_VOICE_TRANSPARENT)
-			sco_pi(sk)->codec.id = BT_CODEC_TRANSPARENT;
+
+		switch (sco_pi(sk)->setting & SCO_AIRMODE_MASK) {
+		case SCO_AIRMODE_TRANSP:
+			if (enhanced_sync_conn_capable(hdev))
+				sco_pi(sk)->codec.id = BT_CODEC_TRANSPARENT;
+			break;
+		}
+
 		hci_dev_put(hdev);
 		break;
 
-- 
2.39.5



