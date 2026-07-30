Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172A444AB81;
	Thu, 30 Jul 2026 16:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428263; cv=none; b=NKu5OwK/itLerQikPIzHHqCOBE3xFcGL26r9jH71nxPPZY2dwjbRl/gU7KfeXCbkK5ZcMjLaYYdWTFiJWSA1inCOFzFARzdDLj6vwL6F0ffK85hpMQqke2cv5NZcsfVWB8ivJN1q/YcjfRb8wwc9myJlorlhywEYoUySvFVpIcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428263; c=relaxed/simple;
	bh=QjpDixSWdoqBxbu39mLLQsxEKRGX+On92Q73WdPsGfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWdCiO0SmHrAr4fK8KJzucbFF7wZ5h/+oQBf3GXCY5aObxS+k1JB/sNrDWAnum7gd88FXGmITj8gDfP64zteqN6HVAJD0MCQ9FeUwvisFKoP3ZGkLXbRRw/TdonHC92DPHdYPEKSKiPsv64BRIevzIavGoO1SwIOqU2gAa5A3Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3mYQnr7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3mYQnr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7338F1F00A3A;
	Thu, 30 Jul 2026 16:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428262;
	bh=y16OPwUTEUO+YehBo+pEa/V+oBRLdv8nI7cuBNlRc7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3mYQnr7I53XXO+aWws5pCYwvF/akVmVeHbxm/uDJez1/CtisNmIo0IWXjTry192+
	 4cu74roibC0tt2zJBC4NEpxhrbfQb22LTbxGpk2hIQuAYrhi5Bsndb+Tb6SvNgRLky
	 9wqwMD03uu6czuXSyrOaCC0PICRLLVUE2dcwlaFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 458/484] mmc: vub300: fix use-after-free on probe failure
Date: Thu, 30 Jul 2026 16:15:55 +0200
Message-ID: <20260730141433.433270241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

The vub300 driver lifetime-manages its controller state using
vub300->kref, with vub300_delete() freeing the mmc host when the last
reference is dropped. The probe error path after the inactivity timer has
been armed still bypasses that lifetime rule, however, and falls through
to mmc_free_host() directly if mmc_add_host() fails.

The race window is between arming the inactivity timer and reaching the
probe error unwind after mmc_add_host() fails:

        probe thread                     timer/workqueue
        ------------                     ---------------
        kref_init(&vub300->kref)         ref = 1
        kref_get(&vub300->kref)          ref = 2, timer ref
        add_timer(inactivity_timer)      fires after one second
        |
        |   race window
        |<---------------------------------------------------->
        |
        mmc_add_host(mmc)
                                         inactivity timer fires
                                         vub300_queue_dead_work()
                                           kref_get()          ref = 3
                                           queue_work(deadwork)
        mmc_add_host() fails
        timer_delete_sync()
        mmc_free_host(mmc)
          frees vub300
                                         deadwork runs
                                           use-after-free

The inactivity timeout is one second, so this would require
mmc_add_host() to both fail and take more than one second to do so. This
is unlikely to happen in practice, but the error path is still wrong.

timer_delete_sync() only waits for the timer callback itself. It does
not flush deadwork that the callback may already have queued. As a
result, queued deadwork can still hold a kref while the probe error path
directly frees the backing mmc host, including the vub300 storage.

Fix this by using the same lifetime mechanism as disconnect. Clear
vub300->interface so that the timer callback and any queued deadwork
return early and drop their references, then drop the initial probe
reference and return without falling through to err_free_host.

Fixes: 0613ad2401f8 ("mmc: vub300: fix return value check of mmc_add_host()")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
(cherry picked from commit a3b5f242997a3be7404112fd48784881560aea57)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/vub300.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2343,12 +2343,16 @@ static int vub300_probe(struct usb_inter
 			 interface_to_InterfaceNumber(interface));
 	retval = mmc_add_host(mmc);
 	if (retval)
-		goto err_delete_timer;
+		goto err_stop_io;
 
 	return 0;
 
-err_delete_timer:
-	timer_delete_sync(&vub300->inactivity_timer);
+err_stop_io:
+	vub300->interface = NULL;
+	kref_put(&vub300->kref, vub300_delete);
+
+	return retval;
+
 err_free_host:
 	mmc_free_host(mmc);
 	/*


