Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA565140E3D;
	Thu, 11 Apr 2024 10:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830783; cv=none; b=CqW9aRkvNphVJg+pVwz5xDrVJwWDeLp9hj1YI0ErOH0xfGTAfvhIsFEj8meg4ZoNDVc5rC6Fdsy6rMHgTQ4euEl8kZ4PpWgYsWuAcyyDUw8sO4aMHGxsRQ57o5xofxjr/zyGVNQFq1jj5Mcjv5Y78OjoZUEAlgkgrAKgagThwOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830783; c=relaxed/simple;
	bh=gJ2ENgU/Wa6j+11Ouckw7yFQhhrUzYayA3uY2u5iujs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAzgqsqLZeWSXY3LgtmQ4AH3ho72m6mec2aw2h32m9tyqD4cUyhlR+qf18QjXSyTcWZuM+ER08Neur6jbCtrH9lDsVLKaTMbD1KPey+JpaMC5upw22Fl/d3mn+XztXKQ8eVko3TMG00tGxrXyepyuDQg1JS17DLlYAKQewr+NCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x11xSD3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x11xSD3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F29C433F1;
	Thu, 11 Apr 2024 10:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830782;
	bh=gJ2ENgU/Wa6j+11Ouckw7yFQhhrUzYayA3uY2u5iujs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x11xSD3ZsObGY5xNbn9AQ47YDRk4vEp0YfnnF9C6VOURg6ktonvxKZviGi20Sb1Rp
	 kcR7l9+QzeLiT/NZSCq2zZ8KP/p+Peiw7akt2FPysLOA7uE+S2diRB8zJyHRNY+aki
	 6Da8EJb6WBDB0/YXn58aozL0zrv2Zfr42gikWTfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.4 117/215] usb: cdc-wdm: close race between read and workqueue
Date: Thu, 11 Apr 2024 11:55:26 +0200
Message-ID: <20240411095428.421465116@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


