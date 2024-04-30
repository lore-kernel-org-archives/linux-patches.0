Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F349C12BF21;
	Tue, 30 Apr 2024 10:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473761; cv=none; b=EmM8YV1+RKbBlQqT9tw4c3APeiRuFVH9wDb+Z9y2Ry0wExzd0p5zaLBCzHWaZ+rs/F4FplfbuiUY1zVq8r2O0/+61qbTxT80rnrysUpw3zAEN+ohoLE5g+e8HcsQVFCu4T/J4AaohUy9bTq2wmp5g8ox682EpdGU+enPV/9Gk9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473761; c=relaxed/simple;
	bh=gxKf+Gyyt1R2cBFvThjCW3nS2t8wO/cOFCfgHF4NnOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=it5yLHzt8muNNO9hVxB/0hV1VyBVN0sMoFV2GIQyLsH7nTkUQaogV0j7dE/eHo93rK92eBd9zFeenf5iIbBY6j7k6WBlCbng6DzUUenOVHzqlOJgabB8uqiDVVt7sATqBANU52XwSYqqYpOQnzft9FHKIhlJWltcM6W44hr5wEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqvlfHHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqvlfHHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D839C2BBFC;
	Tue, 30 Apr 2024 10:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473760;
	bh=gxKf+Gyyt1R2cBFvThjCW3nS2t8wO/cOFCfgHF4NnOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqvlfHHUDPOUXHBPq9bvlwZLVkvYuUf/zcYrnKtgi0GTxCDoDoyrsdGLGqC2GEk+W
	 q7AlJyn62v10Cwx2n4QXtYiJcVy/cyjsDxcJ+yvHCeBpdU8Lpm/yCm3g+C9yJpeCIF
	 dzjVgivf8bXg6lsKGrKN/Nn0aXHcDRzIp5rVEBMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	": Aleksander Morgado" <aleksandermj@chromium.org>,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH 4.19 30/77] Revert "usb: cdc-wdm: close race between read and workqueue"
Date: Tue, 30 Apr 2024 12:39:09 +0200
Message-ID: <20240430103042.020101503@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 1607830dadeefc407e4956336d9fcd9e9defd810 upstream.

This reverts commit 339f83612f3a569b194680768b22bf113c26a29d.

It has been found to cause problems in a number of Chromebook devices,
so revert the change until it can be brought back in a safe way.

Link: https://lore.kernel.org/r/385a3519-b45d-48c5-a6fd-a3fdb6bec92f@chromium.org
Reported-by:: Aleksander Morgado <aleksandermj@chromium.org>
Fixes: 339f83612f3a ("usb: cdc-wdm: close race between read and workqueue")
Cc: stable <stable@kernel.org>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -471,7 +471,6 @@ out_free_mem:
 static int service_outstanding_interrupt(struct wdm_device *desc)
 {
 	int rv = 0;
-	int used;
 
 	/* submit read urb only if the device is waiting for it */
 	if (!desc->resp_count || !--desc->resp_count)
@@ -486,10 +485,7 @@ static int service_outstanding_interrupt
 		goto out;
 	}
 
-	used = test_and_set_bit(WDM_RESPONDING, &desc->flags);
-	if (used)
-		goto out;
-
+	set_bit(WDM_RESPONDING, &desc->flags);
 	spin_unlock_irq(&desc->iuspin);
 	rv = usb_submit_urb(desc->response, GFP_KERNEL);
 	spin_lock_irq(&desc->iuspin);


