Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1592B47A5D;
	Mon,  1 Apr 2024 16:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987626; cv=none; b=eni574CSra7Ug70GjzQLZsimNUG9ujP47P0FqF6eUNKP/Ri3ATgCUYpenw4HhTPXlBCbaC7TmIJo8i6AvtkK/iTzNiy2IpfOWe2la/SbPSKdFF8Px1rIp+1gP3BNbwd1ow+p8i1xl3JSKQDmzdMW0HLgdI44LE1ddEzq0T/XSAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987626; c=relaxed/simple;
	bh=WLYOe5jv99Aj8NeQPpOqom0cXHPZ00yslFPnNQZhMPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfNd2Txs40eHEoC2EWqAk/48JTGfGNjHL94JFFvyoF3xhQ1NN6OGVf817hAYbDCNLlo3/UfWj8ibsMa+N/5paGNwLard+QRxCexbVNrjAC53QcGrUa5dDout9b35FUFXqlF20ABJY8mLqm4jt6sImkJN1n+Z0szyJxhTa1WRb9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJowfOGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJowfOGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78861C433F1;
	Mon,  1 Apr 2024 16:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987625;
	bh=WLYOe5jv99Aj8NeQPpOqom0cXHPZ00yslFPnNQZhMPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJowfOGSN5xl/w4ddPxSuXv3quSVEIGlz0lpwzrniEI9iE0n7iU3Obl8vgf4F+0pJ
	 ZhHOGhCw4bK35A5rYymhff0fb+8Mhnr565SpboKqj8mBZel7FztNw8kvnRcBr0Byxe
	 hUACI4ilqhNcAdPn51pD3nUloaKI6KvbMXYG9DsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.8 343/399] usb: cdc-wdm: close race between read and workqueue
Date: Mon,  1 Apr 2024 17:45:09 +0200
Message-ID: <20240401152559.410915595@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


