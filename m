Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C3670838;
	Mon, 23 Jun 2025 21:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715927; cv=none; b=EyoD3FBs93bUs0bIcGk+y7BM6pzKSCqSmvEzZbFQI4gXaUqJ1W/oFM+IQNPDYpfL0z46nQmqHDRkAEKo25xQ1GnBMHC7hJt33ytBEBgM3AeRkdNWOIneF9p9ziJIxRgQRCY0O2vUtQo4WaQlaab8dbLHvmS3qKYJY8w8k33HdRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715927; c=relaxed/simple;
	bh=1j8vpMI12MOzzC1/xVRpgE0I9uYyZXzb++CuOFqX0bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzXRRARWI7/gm6vLjkf55PnGYx2jbfD5vxCkPW3naFtxbY+1IELzDGA+qARrmLFU2xpr29y3SEX9qsKOPFTyhsBXx1vw13jjntk5l5tyDaluaOzTA0uM59MnE3nGGNg11cj5QDAyeHBorhELI9AY/1VOva/YEYntEwBbBJx6oC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JX7/pFqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JX7/pFqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B27C4CEEA;
	Mon, 23 Jun 2025 21:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715927;
	bh=1j8vpMI12MOzzC1/xVRpgE0I9uYyZXzb++CuOFqX0bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JX7/pFqCvGmpwQiz39rC2FJju8yQqtSls7bu+cc2ZnyHw64TW6Yr9ucE/QWx7GG6h
	 iuOdokHja9bmxBWZCuCtfkoe+XOczncVRT9/nhh6FWU651H+MtrBuG69HyOUBydQxL
	 91h/ZbGtsjvcLBOehpASkVnIIG7r34fVoHGPVvcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 310/355] wifi: carl9170: do not ping device which has failed to load firmware
Date: Mon, 23 Jun 2025 15:08:31 +0200
Message-ID: <20250623130636.105971648@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



