Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D08572689;
	Wed,  9 Sep 2026 14:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963257; cv=none; b=fhf4jkKfLIhO27a9UXjzOoLd7FaludM7tpscOQy4OEqdi2ETQVXRgM4N2ySsXHA2HuPE2Vcg2O8aESaeLIzOhBTIP9XbLI80Etokvm6paeGH3oAJZ8RfdTkX1iBDW8qP0K2e9wYdVda7WSe5omU/vPmuGfYAqhhnWTqr3xMIOWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963257; c=relaxed/simple;
	bh=q67Ym7q4K3Lk7T+Y4qKIZu9qGnI0qGe3b4WSQ7VJrLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oe1ZmNppARnaWktcWRTGIqyfOPiymGuJcOH+wD1brxW+U/kxqp5kjFB3FAjV+6ooe0DavYwyO51K1Y+jOlxzxizxm6bRJrPlTT6J27RbSeKfqHlgK4cbtD0K8VEkpft3AIQMrm4J8XzPfwuD/MfNvl6fBEYY/wKB7+lxFqGZs1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fxu0/pVS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fxu0/pVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8611F00A3A;
	Wed,  9 Sep 2026 14:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963255;
	bh=ZT4HBCnRGqFK0LB3TXB3s+SHL0qhIKoX+aq602/uKaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fxu0/pVSSbPSfXWEoOsWnZm1WIjiaKfJ6m2Q96Tpzx+pzaxO9dhzlJkedJMySj8zl
	 CJJzLyH9J6o3IF+tI8eMoZli3v1cVcvjdHam/B1LunIwbqCRabKGsm1/rb3C4vh4ci
	 dD84FV+HaoNOgCjszvdhr0fNfPQUYmS/4Wl9y4CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+22ea20ef3afb6785b122@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Liu Qi <liuqi@longcheer.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.18 017/583] usb-storage: ene_ub6250: fix race between scan work and probe
Date: Wed,  9 Sep 2026 15:35:02 +0200
Message-ID: <20260909134238.409592001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


