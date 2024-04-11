Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E471422C4;
	Thu, 11 Apr 2024 10:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829838; cv=none; b=oEgTYzexDfJxSoFNi1cXY2rLQol9dd/ltp362XXlv9M/msoupsLJOX0TbyVIKJKxRJtARx1SElbbvkXeeUA4TZ6TDIuaNSAvdvtX6+cTOlbc242WQfNmaP54qw6Aeg6mjE2d9LPW43jU0cWd/E+abyQ7rtsRFmihi5rp0H3va2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829838; c=relaxed/simple;
	bh=Smlr/XAt+0Y+PE8041GPeWkpFafOAdIknsQmO4/CQLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnzsDAZH+dvS5TNDRdGHCSRxQ5N8xPfHUIXJFigOrF8DybScXdxcPEOTQUJ33H7JOFBODN6CI6DguBUrJybSortEV5ntZSvhsiamx1DAyxrNguo7phuGfzWenOuAKhw1X97K2/wfIK2+hmxYnOWuTQNEy22nnqCMNye/qGLgc1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbjkKfnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbjkKfnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C97DC433C7;
	Thu, 11 Apr 2024 10:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829837;
	bh=Smlr/XAt+0Y+PE8041GPeWkpFafOAdIknsQmO4/CQLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbjkKfnGvh/i+M91IOU49oR0yAc5MQpdZzeR+a7aD5F2QQd7AbQjLKfb6bpSbTrjK
	 Fqu9uykOB5yhZcE/cc+4YgQYCu/1Qnj1ugHDpdc6xRPYBAm0WVZtVOfKHM3gDPXwMU
	 I1a4LHVkfUS8fWVzJ3kguVfUw9hJRqASf1pCR1eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.19 084/175] usb: cdc-wdm: close race between read and workqueue
Date: Thu, 11 Apr 2024 11:55:07 +0200
Message-ID: <20240411095422.091282703@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -471,6 +471,7 @@ out_free_mem:
 static int service_outstanding_interrupt(struct wdm_device *desc)
 {
 	int rv = 0;
+	int used;
 
 	/* submit read urb only if the device is waiting for it */
 	if (!desc->resp_count || !--desc->resp_count)
@@ -485,7 +486,10 @@ static int service_outstanding_interrupt
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


