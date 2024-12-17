Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8533E1F76A1;
	Tue, 17 Dec 2024 17:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455879; cv=none; b=kopKNs9+jPjpC4af0fqWEpFzx93BUypM8t7i8/Sj+pJqRrJYv7ua+j+bxjX/dfGndGTikt0AeWcrm5da3Eg1rYymqvVfFCzxzpD86xb7rP87PSl+pwODHQAaI4AKS7+943RmJ6UpN5QagnMi8AwySFawxPL0br3b6fBM3XJkOQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455879; c=relaxed/simple;
	bh=OJhpnC3dgEW0kv+/1T9Gv0DS5b3wr5nVk3VRm+6UVfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=beTiz3aDDz9ovwLWkoDdp4QqttII1mnSfGFIbZoOhvJfUC5Flaap9RzSUy5hWKZf8GqJot9hVmn8a3g7sTihsaPBihUgDmdB3uU7Hu5kDeaf5dPjLe6bbTHkishxhN0hqh25L4x5az0psgOfnqex/EL/y9UUTui92XpevlYkApI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxIhtK81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxIhtK81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4E3C4CED3;
	Tue, 17 Dec 2024 17:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455879;
	bh=OJhpnC3dgEW0kv+/1T9Gv0DS5b3wr5nVk3VRm+6UVfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxIhtK81x4sfCZALLDvfd8EqptMmo8xwaSDc+0kBsUjCR/p0pAzAQxCPROOTq/R6R
	 YO0is4aHDNtlGZslokaKHQMuL8Nd0Xifm8F2QYZOkJDK9XEjg9/P7t69fm9uJpHn65
	 fLV9LtYqBC0sJ4vomy88DL8p/pk1Iwb/9geMulMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Danis?= <frederic.danis@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 64/76] Bluetooth: SCO: Add support for 16 bits transparent voice setting
Date: Tue, 17 Dec 2024 18:07:44 +0100
Message-ID: <20241217170528.980283196@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 41fc7f12971a..5689b4744764 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -122,6 +122,7 @@ struct bt_voice {
 
 #define BT_VOICE_TRANSPARENT			0x0003
 #define BT_VOICE_CVSD_16BIT			0x0060
+#define BT_VOICE_TRANSPARENT_16BIT		0x0063
 
 #define BT_SNDMTU		12
 #define BT_RCVMTU		13
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index ad5afde17213..fe8728041ad0 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -268,10 +268,13 @@ static int sco_connect(struct sock *sk)
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
@@ -888,13 +891,6 @@ static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
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
@@ -902,9 +898,14 @@ static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
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



