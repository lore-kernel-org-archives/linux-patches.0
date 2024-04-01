Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0C51DFF4;
	Mon,  1 Apr 2024 16:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990427; cv=none; b=ecxFWdpfHXuzp4Y2nYES175t9w6LSL0ODX3oPLvh/CDbGFHJRsdGYu/HhmnQI3FXpmZzfCLalNFVsRmbBUyRQ6KARKdW2cmxbRFi/cTlLHLZ12n7kHMf8TpU7Qh1sriBrflaNMHfHfLF1lA/UcSfONpi9ZEMGH3XQcW1Gq84hm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990427; c=relaxed/simple;
	bh=SEJL9b6D9G+oWpvqkQ8tDyf0Ewe7rY5WmmU6n6tGUr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddges65oxEjLH5ENyGRjEEFpEAbUwDgreexKhbvAv+Krnh1vJsrr4ABCQ8FyULFInaRmAmm5Vo/CvuHblr9iTtwwWFolMMNXYwZY2PndmCVNjV7Yep5n0qNQPc8INibntiux8F7x5Nj5YtDStzhqeDDPoOdS3Bxdxo0E1Ym5uBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yc09CQiy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yc09CQiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60C5C433F1;
	Mon,  1 Apr 2024 16:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990427;
	bh=SEJL9b6D9G+oWpvqkQ8tDyf0Ewe7rY5WmmU6n6tGUr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yc09CQiyRI3M2QK0fUrjonyGgqCR9hdt8enUiE2LZy1XyMqGCl/2/GgBBGaIRzZSu
	 3020n5w8oM0gcAmWs1mICfMXKbzUtQdud3AyJ5ilJN3rxH3KvJ7Mlr57EuGmEA4K/q
	 MnXXTCah262oZGPBLyEY9SvAlKX1kHlbpdY0f0hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.6 350/396] usb: cdc-wdm: close race between read and workqueue
Date: Mon,  1 Apr 2024 17:46:39 +0200
Message-ID: <20240401152558.349546927@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Oliver Neukum <oneukum@suse.com>

commit 339f83612f3a569b194680768b22bf113c26a29d upstream.

wdm_read() cannot race with itself. However, in
service_outstanding_interrupt() it can race with the
workqueue, which can be triggered by error handling.

Hence we need to make sure that the WDM_RESPONDING
flag is not just only set but tested.

Fixes: afba937e540c9 ("USB: CDC WDM driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20240314115132.3907-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -485,6 +485,7 @@ out_free_mem:
 static int service_outstanding_interrupt(struct wdm_device *desc)
 {
 	int rv = 0;
+	int used;
 
 	/* submit read urb only if the device is waiting for it */
 	if (!desc->resp_count || !--desc->resp_count)
@@ -499,7 +500,10 @@ static int service_outstanding_interrupt
 		goto out;
 	}
 
-	set_bit(WDM_RESPONDING, &desc->flags);
+	used = test_and_set_bit(WDM_RESPONDING, &desc->flags);
+	if (used)
+		goto out;
+
 	spin_unlock_irq(&desc->iuspin);
 	rv = usb_submit_urb(desc->response, GFP_KERNEL);
 	spin_lock_irq(&desc->iuspin);


