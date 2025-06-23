Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D33D1F7580;
	Mon, 23 Jun 2025 22:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716884; cv=none; b=Yli8q5nRQOIID/K0+7SycPszRMVWXsrzkyxs2BMtZTRRkWl9nlhNVAMb4OVz/oKyxP0SCC1QlXfcgaRfmEtI7ix4F4X/Qka7uwKpzKsqXE5uYuvnmPKCsKRAxSIXL8RNPg0h+eCppRsfLyeuTpeffKw7mcCF2EEOL+VAMsOxbV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716884; c=relaxed/simple;
	bh=2hYZDC8eSnmMHF2eYPyOjEwddZ6ViNS36kZF0LS7TOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnrIVTQri6bGot97VqJg0KEetr3YErU08naEaSw0reUllT3edYPaiX2Pu5Vrjp6OWV5pL7ah2L4fwONIsyFboh7ODtgHZR6Mo6dOR/RHidrWuNtOoBM8wViSLIa66vzQPDlnWbiJlAbsOxdLf4JpRQ0uOLL8tTPBRFjYCmFaf9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdfO/SWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdfO/SWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F23C4CEEA;
	Mon, 23 Jun 2025 22:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716884;
	bh=2hYZDC8eSnmMHF2eYPyOjEwddZ6ViNS36kZF0LS7TOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdfO/SWF/1SPGgrLqEMMxNVBfZL2TJAgqQOzFQ0yOI8y5d4a685SIdurTdnoNcBak
	 5qqpDmOGMQMq1+QZCfrmYrlC1MEKcOmxW3zmitmQGJktvDe12ITbVmNV3DnujH8tKf
	 5eDk22SIJ6CIlfwxzDyYvq2jsatLmDDaPklNckqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 375/411] wifi: carl9170: do not ping device which has failed to load firmware
Date: Mon, 23 Jun 2025 15:08:39 +0200
Message-ID: <20250623130643.081616710@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



