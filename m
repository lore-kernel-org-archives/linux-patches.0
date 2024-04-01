Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AC640876;
	Mon,  1 Apr 2024 17:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991331; cv=none; b=SUjG8XXa+gqt3euVK0EZVr24kCPSf8AvDEksWFVVaARm4mdh5n2V/PdkDMjWFUNHghxOBHBd80WzHEXYODEDPlPlkGLLN+lFOUMQAW2PYWcoon4WdkZQ9RkXJrwyklaXfcs1pT7UH76mvnwp/JImvXo+8usip9GgTjB1V/6N78U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991331; c=relaxed/simple;
	bh=ytJoCylIuPVA49GusGH28Rywy/QotDeC1g/4GE5GE/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6S0beOHzp5dJEHxenwz9GKxrF9wsSblu2tBezVJy5nZRuFcSp+goZ6i2Hl0gnwljfSOk8xppkwK0QxbcCYHwpKojlMG6pVJRZWrd4w6R8cl+AIClpBFu8QXZbB4vw/t+wq8ZZo2Hj1z7vkkeQMimmdvKbHgPzsmZ89E3Q8xZiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dm71+O9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dm71+O9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35235C433C7;
	Mon,  1 Apr 2024 17:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991330;
	bh=ytJoCylIuPVA49GusGH28Rywy/QotDeC1g/4GE5GE/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dm71+O9oqDy1l9uqpXIBggQLSTCcM1PoDLYyBd0tkPC1E4E+0l7lvSYdB+l0rjHha
	 RdGlktB6OzMyUZ7HiGiFVIdZSGZfzRyUUWb5fuXfFIiu1hvysDHe5XALxe7+72ZEqy
	 9I+docp4+oCcZkzQzPOM6MbTZ78dA5D/3M6yeAbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.1 232/272] usb: cdc-wdm: close race between read and workqueue
Date: Mon,  1 Apr 2024 17:47:02 +0200
Message-ID: <20240401152538.222118075@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


