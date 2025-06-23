Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C516E2222C2;
	Mon, 23 Jun 2025 22:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716335; cv=none; b=WYTTUDheJkWUNZjJNdMSEehO690WTHTldU2/6M1LZ1GDoleVr12YxmaJmKq20WSwp3w+VsGLt6JNwtlycqReN4YJA64cYFIfpCGyb4vjwXUxUbXkScYca9REhsWycD75TcqkVfNUkRZaLKqV8aEUcF+GVv4AFq3gIDE/oxjPz2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716335; c=relaxed/simple;
	bh=RqWnqbMtRghupIJG+XPjRTzkqqtd82rFLy5kzx75A4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8ESQjyvqHpUiisZ3GZU/CTalEvSCyEsmQd45ZRE55/25/Ooo+PJ6en3lAJ4RQTEOCfH2yxHOjX4j+QZasb3qNb/cykYQVMm7QN6OobFm8ePOI69xIl34+qMGqfvNRA+4NnwynB4CyWFGbdtCVcUZyVTaCJkPG7wz2OOFKPEVmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqLOZIpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqLOZIpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7D3C4CEEA;
	Mon, 23 Jun 2025 22:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716335;
	bh=RqWnqbMtRghupIJG+XPjRTzkqqtd82rFLy5kzx75A4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqLOZIpUIWhWaHnZrX7rXHE/YthfX2egEpAyPzztjNyCoVr54kz4bLwtYktudVRaR
	 SJmxYRi+3rYnpSxmc3jQO7f5ZJ2vRbdMonN+H6fpJSk4oZ3XRmQxfKrQWVde/Gm8gP
	 t/5qivdJ7GWYEJZVQrTATM1E27/sWntVD92wvrOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 257/290] wifi: carl9170: do not ping device which has failed to load firmware
Date: Mon, 23 Jun 2025 15:08:38 +0200
Message-ID: <20250623130634.649766393@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 15d25307692312cec4b57052da73387f91a2e870 ]

Syzkaller reports [1, 2] crashes caused by an attempts to ping
the device which has failed to load firmware. Since such a device
doesn't pass 'ieee80211_register_hw()', an internal workqueue
managed by 'ieee80211_queue_work()' is not yet created and an
attempt to queue work on it causes null-ptr-deref.

[1] https://syzkaller.appspot.com/bug?extid=9a4aec827829942045ff
[2] https://syzkaller.appspot.com/bug?extid=0d8afba53e8fb2633217

Fixes: e4a668c59080 ("carl9170: fix spurious restart due to high latency")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Link: https://patch.msgid.link/20250616181205.38883-1-dmantipov@yandex.ru
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/carl9170/usb.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index a5265997b5767..debac4699687e 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -438,14 +438,21 @@ static void carl9170_usb_rx_complete(struct urb *urb)
 
 		if (atomic_read(&ar->rx_anch_urbs) == 0) {
 			/*
-			 * The system is too slow to cope with
-			 * the enormous workload. We have simply
-			 * run out of active rx urbs and this
-			 * unfortunately leads to an unpredictable
-			 * device.
+			 * At this point, either the system is too slow to
+			 * cope with the enormous workload (so we have simply
+			 * run out of active rx urbs and this unfortunately
+			 * leads to an unpredictable device), or the device
+			 * is not fully functional after an unsuccessful
+			 * firmware loading attempts (so it doesn't pass
+			 * ieee80211_register_hw() and there is no internal
+			 * workqueue at all).
 			 */
 
-			ieee80211_queue_work(ar->hw, &ar->ping_work);
+			if (ar->registered)
+				ieee80211_queue_work(ar->hw, &ar->ping_work);
+			else
+				pr_warn_once("device %s is not registered\n",
+					     dev_name(&ar->udev->dev));
 		}
 	} else {
 		/*
-- 
2.39.5



