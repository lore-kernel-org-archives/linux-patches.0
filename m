Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC57B1F76DF;
	Tue, 17 Dec 2024 17:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456844; cv=none; b=a1MUOWxSn98h3uepIHrZcV13ONM4T+Qg9z2cCGOBmyDM2WrWg9YpfNHIzJu8V59/RS0MubRB2SUMFIgShCM3hH5WQSysbSbRiHRIYH5t5kbyNwts2A8mmiLKJoZrqu4nKQm9DUKa5/0mpg55ZxWslnWzGMLCRr9FR3NGF0wEtfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456844; c=relaxed/simple;
	bh=Wwft1SIyKay/QRhp0L+IJhPig0L26x6mqE88/Q5ujb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KxTDgonGWKPpMhQQ1uSK4eS1NuBKd7sSowkn1VrzZfhiZNy5m3c9jPHSGCu4Jf2n1X4hMxCLM+fiI1UWhpwmmyAmdRinQKLg4gw7T5wzM8ZRLR9ATXrk8UgF0EofA55oLO+4Eqq3sxfTRKKR0ifGFTu8CDutCoDo/PaIAfQLHWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjP4DAZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjP4DAZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048E1C4CED7;
	Tue, 17 Dec 2024 17:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456844;
	bh=Wwft1SIyKay/QRhp0L+IJhPig0L26x6mqE88/Q5ujb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GjP4DAZ8s+Kc/I1sC415xw3XTRqqrCIitNn8gNu3xPW51/lMGY4XZVLtm2+B4o+IM
	 Z6cGQZo+Oa6QhAww7liu/9A4yXEX6eCYRZXGf5PPlRrSH73PCRqNRPbnMF4ZDFYto1
	 qKPUJatv1DugaeGQ0rPrwAOJqExQsGvLig/dukXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Danis?= <frederic.danis@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/172] Bluetooth: SCO: Add support for 16 bits transparent voice setting
Date: Tue, 17 Dec 2024 18:08:26 +0100
Message-ID: <20241217170552.552088819@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e6760c11f007..435250c72d56 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -123,6 +123,7 @@ struct bt_voice {
 
 #define BT_VOICE_TRANSPARENT			0x0003
 #define BT_VOICE_CVSD_16BIT			0x0060
+#define BT_VOICE_TRANSPARENT_16BIT		0x0063
 
 #define BT_SNDMTU		12
 #define BT_RCVMTU		13
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 700abb639a55..b872a2ca3ff3 100644
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
@@ -877,13 +880,6 @@ static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
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
@@ -891,9 +887,14 @@ static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
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



