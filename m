Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A7B384CD4;
	Sat, 12 Sep 2026 19:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241829; cv=none; b=UiVTllY5AK9qtG5nhqjmNL8kSEbSw8eXf4Co+xnNI8QLruDrzLmnXDBrhLWT9zccrOK5t7h+0TlHIhm61Lmy4Od2qUG3r1Pm9uAqjj7ccrlfBHCIZS+RSpF58IFrtu3nXUDBZcPjYOh8wjFvd4tKGF49gfD53J4KZPydReOhGhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241829; c=relaxed/simple;
	bh=bghYT8goE/C8KckDRMLGpjSYyMYWLm6mckQ8gqxMySw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLaQBDovR1pt6UnScOoUYZytJsyCtV/waZKyQnlytCi1NePVeA3VONOr+jOibHA7pM1r4yrOYyTLD7g/qY0Q6NtBy6RBw3dOoVG9bYaRVJRRPuzepqk5hLqxVLaHdF/O2Vk97kHcYrBQjjGVGvUo8/oeJzLzG42/7TknDu/2vl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTntW8mT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTntW8mT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A691F000FF;
	Sat, 12 Sep 2026 19:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241827;
	bh=xRtcK19IPffXF1ANSrBLh8sxWury8ENt0L5Vrr155B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mTntW8mTkX8rNcls+Jkrn4INrEOOQk/IKEgeVKMkcgGwyPJhhew1wa8k4ORBvcWze
	 XgN9qhDA6p6FfksowdFx09YB+4pT9gMeApwjJFG6HoehB02snGpPBAfsuvliEK/eUp
	 8Vlxv0F+CmkeIh9xHeD29SfZ7im9NqpQ7agQiHSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+22ea20ef3afb6785b122@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Liu Qi <liuqi@longcheer.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 216/798] usb-storage: ene_ub6250: fix race between scan work and probe
Date: Sat, 12 Sep 2026 08:57:24 +0200
Message-ID: <20260912065522.066133325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2357,7 +2357,9 @@ static int ene_ub6250_probe(struct usb_i
 		return result;
 
 	/* probe card type */
+	mutex_lock(&us->dev_mutex);
 	result = ene_get_card_type(us, REG_CARD_STATUS, info->bbuf);
+	mutex_unlock(&us->dev_mutex);
 	if (result != USB_STOR_XFER_GOOD) {
 		usb_stor_disconnect(intf);
 		return USB_STOR_TRANSPORT_ERROR;


