Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F084D49620;
	Mon, 13 Apr 2026 16:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097451; cv=none; b=Xj7s9zTi4XQH1RGNrc9oCnHt0ft2Cvs15V3gPGM0ahZwtWXK8DR9Z9KOWiMUKtJj0pheHoIOQ55YHNSm0KFmaKvkHQW0DoT0U2LVD/v+Ef3pXCfqN1w8Q9CjFXCp/nw8bE2NEMXwRi99RK2Cv80IYk1wKdzbo5AWxiznkJV+0dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097451; c=relaxed/simple;
	bh=8AMa5L3gOBb0oFc5bGNnj4Dl7Nv/iIutkHJbpriqWUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSA2Yc8i3nzkh4ZWIfALeL/1Qt9Y4ifRUDlcKYEGCyDDfcJl59PoTi0IgqgG+y5ANF9AcF1mla2vtMNYIC/a4ZCVaTYpDzYnha5i8uyeHiiyozoFZawcLP3GXT4SkLjYJq8sGJnGTdRr7MqNH0+Iggihmfk3MBvJGcvguiXBn20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b71Bv887; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b71Bv887"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59578C2BCAF;
	Mon, 13 Apr 2026 16:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097450;
	bh=8AMa5L3gOBb0oFc5bGNnj4Dl7Nv/iIutkHJbpriqWUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b71Bv887+xN+RRKu25QTKICrkTNd0oN5Z1Sl7G9F3uxLDr62kCNo7BHp9qZxHMFUu
	 jcTiDd0L4F9cCs3fjsVZH7v2vGJxwXCWCXAk/rHmz/e0zUivw6eqko19RB2MSfvcPc
	 LhDPx5OKJlvZQpbpsz71chUUGpkOWYuLl+MGYhGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+25ba18e2c5040447585d@syzkaller.appspotmail.com,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 141/570] USB: usbtmc: Use usb_bulk_msg_killable() with user-specified timeouts
Date: Mon, 13 Apr 2026 17:54:32 +0200
Message-ID: <20260413155835.725083626@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 7784caa413a89487dd14dd5c41db8753483b2acb upstream.

The usbtmc driver accepts timeout values specified by the user in an
ioctl command, and uses these timeouts for some usb_bulk_msg() calls.
Since the user can specify arbitrarily long timeouts and
usb_bulk_msg() uses unkillable waits, call usb_bulk_msg_killable()
instead to avoid the possibility of the user hanging a kernel thread
indefinitely.

Reported-by: syzbot+25ba18e2c5040447585d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/8e1c7ac5-e076-44b0-84b8-1b34b20f0ae1@suse.com/T/#t
Tested-by: syzbot+25ba18e2c5040447585d@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: 048c6d88a021 ("usb: usbtmc: Add ioctls to set/get usb timeout")
CC: stable@vger.kernel.org
Link: https://patch.msgid.link/81c6fc24-0607-40f1-8c20-5270dab2fad5@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -727,7 +727,7 @@ static int usbtmc488_ioctl_trigger(struc
 	buffer[1] = data->bTag;
 	buffer[2] = ~data->bTag;
 
-	retval = usb_bulk_msg(data->usb_dev,
+	retval = usb_bulk_msg_killable(data->usb_dev,
 			      usb_sndbulkpipe(data->usb_dev,
 					      data->bulk_out),
 			      buffer, USBTMC_HEADER_SIZE,
@@ -1347,7 +1347,7 @@ static int send_request_dev_dep_msg_in(s
 	buffer[11] = 0; /* Reserved */
 
 	/* Send bulk URB */
-	retval = usb_bulk_msg(data->usb_dev,
+	retval = usb_bulk_msg_killable(data->usb_dev,
 			      usb_sndbulkpipe(data->usb_dev,
 					      data->bulk_out),
 			      buffer, USBTMC_HEADER_SIZE,
@@ -1419,7 +1419,7 @@ static ssize_t usbtmc_read(struct file *
 	actual = 0;
 
 	/* Send bulk URB */
-	retval = usb_bulk_msg(data->usb_dev,
+	retval = usb_bulk_msg_killable(data->usb_dev,
 			      usb_rcvbulkpipe(data->usb_dev,
 					      data->bulk_in),
 			      buffer, bufsize, &actual,


