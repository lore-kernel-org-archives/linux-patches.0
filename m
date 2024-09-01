Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DF01E87B;
	Sun,  1 Sep 2024 16:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209911; cv=none; b=HpvA8R30x4FXdGUTCNFe6y2EOyL0xHnITAvAYInOmmMQfDC1w6OR5uPL7DhEL8IaV+cEtVBXbqDAPAvEQouaaIr5O7jYxooQARFP6jR6yNmOBatHGomFmjXETmeBLpH8/MtxuFO2aZPgtpwjPB+8YSbI07QrHswhVkiY03hECnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209911; c=relaxed/simple;
	bh=6KEiIsC9whRdk7zZvvuEwSn97enDhOqmV9q8BaiVuyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQpdZiChVdjvyncNrgeMCCqPsX5cCHxK2gYzm7GAec3jNvSM9Vhz4ok/Q8tO3axTUduVVy4FA/CEP3e85exYa1/PNpVBPDeaW3Nefny8UnJW7Pn/HGVQP6BNu48XGyllZlEV9rv5XpbF1l+isUI+X7VZ2fB+QSmJCqzgm/sNCVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f46/ORBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f46/ORBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73855C4CEC3;
	Sun,  1 Sep 2024 16:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209910;
	bh=6KEiIsC9whRdk7zZvvuEwSn97enDhOqmV9q8BaiVuyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f46/ORBZT/viWkBQYP7Pp0UROuMXV2W5c68Ui0keYo98Zp6Eq6Ni52EEk29wr0QsI
	 BCo5LpMihnaZGpdaeXe2S1cGYqxDrRlANaXilE7Q8jrxFAdTORH4gIydpg10hZq6QG
	 1qEJh3QWKs5FMV1nVovuC3eaXakmJ5OD9kVtG9WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 5.15 003/215] char: xillybus: Refine workqueue handling
Date: Sun,  1 Sep 2024 18:15:15 +0200
Message-ID: <20240901160823.366496280@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eli Billauer <eli.billauer@gmail.com>

commit ad899c301c880766cc709aad277991b3ab671b66 upstream.

As the wakeup work item now runs on a separate workqueue, it needs to be
flushed separately along with flushing the device's workqueue.

Also, move the destroy_workqueue() call to the end of the exit method,
so that deinitialization is done in the opposite order of
initialization.

Fixes: ccbde4b128ef ("char: xillybus: Don't destroy workqueue from work item running on it")
Cc: stable <stable@kernel.org>
Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
Link: https://lore.kernel.org/r/20240816070200.50695-1-eli.billauer@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/xillybus/xillyusb.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/char/xillybus/xillyusb.c
+++ b/drivers/char/xillybus/xillyusb.c
@@ -2079,9 +2079,11 @@ static int xillyusb_discovery(struct usb
 	 * just after responding with the IDT, there is no reason for any
 	 * work item to be running now. To be sure that xdev->channels
 	 * is updated on anything that might run in parallel, flush the
-	 * workqueue, which rarely does anything.
+	 * device's workqueue and the wakeup work item. This rarely
+	 * does anything.
 	 */
 	flush_workqueue(xdev->workq);
+	flush_work(&xdev->wakeup_workitem);
 
 	xdev->num_channels = num_channels;
 
@@ -2258,9 +2260,9 @@ static int __init xillyusb_init(void)
 
 static void __exit xillyusb_exit(void)
 {
-	destroy_workqueue(wakeup_wq);
-
 	usb_deregister(&xillyusb_driver);
+
+	destroy_workqueue(wakeup_wq);
 }
 
 module_init(xillyusb_init);


