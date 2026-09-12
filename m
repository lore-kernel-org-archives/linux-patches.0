Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E8025A640;
	Sat, 12 Sep 2026 15:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227893; cv=none; b=UYrcMsbkc4/PT5MAk1KFxn+yPNAskAD0moYJZKPffG4cRltJFokmxDqil0Ho/kI3NZFyH5/0APboBL2mWDMPWIqexMipTdLSWAKoc0Cr2HyYMATRhczs6iKiC82RlVIIvstO6wej/3kL5pWsrEMsn+H6DXpZJoYNyGeRE/uhu3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227893; c=relaxed/simple;
	bh=E44C+jhiC2g9lA8Pd91go1yVi11n/JLdgEgUevz77p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQjA59hw7cbVXj3ZmwwFZh4gxcGHYKdM96agMZ37BjojglJRFufUvSv5usoSxqGBpyohDmRCpTtpsLCTFZ8O45nOvdhyDZ59GnCvCSa5SaVZVGyHkiiI7A68d7VR2oECVgRMZWYWl5KaRUsS6MboTvzBvD3wZj2KgoTMJPoSIWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oTpRurd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oTpRurd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691F01F000FF;
	Sat, 12 Sep 2026 15:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227891;
	bh=C7cBR3N+tWCijo7V2rZrjA9fdPI/m6jcjOlVKIS62iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0oTpRurdEKacttneQDDew81lj5S8t45z0iY+WqiUlBuiskswwQcwqVGPr9DRS1I2+
	 TRd06DWYJQ7aF0raFZE9ns/09kG1o2yjq9K4YMxNTITDYU++b37UfJZYdaWiQLS/rE
	 wzTpEAIlSmvFRm/mLH9tDcMW2TzyFD7/MKmV9iY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+22ea20ef3afb6785b122@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Liu Qi <liuqi@longcheer.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 0273/1191] usb-storage: ene_ub6250: fix race between scan work and probe
Date: Sat, 12 Sep 2026 08:50:01 +0200
Message-ID: <20260912065554.358016498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Qi <liuqi@longcheer.com>

commit 445fc368c6bc73eff0aeb3818cf5f355facfbb16 upstream.

ene_ub6250_probe() calls usb_stor_probe2(), which starts the usb-storage
infrastructure and schedules the delayed scan work.  The driver then
calls ene_get_card_type(), which sends an ENE command through
ene_send_scsi_cmd() and the usb-storage bulk transfer helpers.

Both the delayed scan work, through usb_stor_Bulk_max_lun(), and
ene_get_card_type() use us->current_urb.  The scan work serializes this
access with us->dev_mutex, but the ENE card-type probe does not.  If the
scan work runs while ene_get_card_type() is still using us->current_urb,
usb_submit_urb() warns that the URB is already active.

Serialize ene_get_card_type() with us->dev_mutex, matching the locking
used by the scan path.

Reported-by: syzbot+22ea20ef3afb6785b122@syzkaller.appspotmail.com
Cc: stable <stable@kernel.org>
Closes: https://syzkaller.appspot.com/bug?extid=22ea20ef3afb6785b122
Assisted-by: Qwen:Qwen3.6
Signed-off-by: Liu Qi <liuqi@longcheer.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260821090416.1247127-1-liuqi@longcheer.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/ene_ub6250.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -2358,7 +2358,9 @@ static int ene_ub6250_probe(struct usb_i
 		return result;
 
 	/* probe card type */
+	mutex_lock(&us->dev_mutex);
 	result = ene_get_card_type(us, REG_CARD_STATUS, info->bbuf);
+	mutex_unlock(&us->dev_mutex);
 	if (result != USB_STOR_XFER_GOOD) {
 		usb_stor_disconnect(intf);
 		return USB_STOR_TRANSPORT_ERROR;


