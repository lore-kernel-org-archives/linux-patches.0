Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E77613D24D;
	Thu, 11 Apr 2024 10:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831895; cv=none; b=cKIvNX1pBv+I4fakWuwFk52IUmsGzu4BdWjlpYautkp6LQc/ZczndgpE6jrDsyHo+KB/t6nFjP4KtPZwer/1oumxOLcR8BhEG5YxSVRJfIwj+2kMyGbYYr8B78KLX0+BwHOlzu5b5A/bWmIpH05Y0eF0pu/E9ZxhxgSAPnTJt00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831895; c=relaxed/simple;
	bh=y4EZ650pTJjsw70bzU66pUEW+9z7K89oD8V1WEN0fz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3cmExoZI5+JiStPJSn4NRjmQyKcOe4rea/bJ02ZfssTpA99AgGtKKPDF+v8XKYWMVlDyPQOcxxaA9jhtTP4okEEZwQohPFW9XypV4OHZZWLkYR7R2cot1UKSyv88kR2KZ9zEWGpuYBWM/H0Qv+q8jY4NxZYrq05n5mlIXf0Iz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPSB2iuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPSB2iuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F887C433C7;
	Thu, 11 Apr 2024 10:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831895;
	bh=y4EZ650pTJjsw70bzU66pUEW+9z7K89oD8V1WEN0fz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPSB2iuWNIT6HQEk+GPOTe+zoROOjizPqJiyvS/Id8lUT7LK6llTw69vbovauY0ex
	 KhQRYIwlh3ccoSzgzHgNtqnDlQxnyOycfH58vP9llxN9eJwE5V72kNBXnHXZc1OyyU
	 hnY4j+VXUS46UGgZmHlAV3t3B3L761i6yS2QSJYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.10 162/294] usb: cdc-wdm: close race between read and workqueue
Date: Thu, 11 Apr 2024 11:55:25 +0200
Message-ID: <20240411095440.520699753@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


