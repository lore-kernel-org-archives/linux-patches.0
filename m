Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD3E2FB2;
	Tue, 27 Aug 2024 15:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770851; cv=none; b=psk0oWC5aGYZnGQVgr6qLUHNLG4Jxgwhe8ZtrqcKyHUxkmTzmYolhDO5N/mtQ7PCxqZYbi23drgUewqLH4fXsYuh7u84YnHjWSnvwzCf2bruk+axqyejKWQrR/ES8sUj/te77O52Fr1Of4751gb4IofOnmVinmNcyDUvhWpm4mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770851; c=relaxed/simple;
	bh=44oT7pECC/MNJDxqoCh5/q+alw7Di+E+tQTwlXZ6t3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/7o+sJYpbYuTIjYRxzPbZu+Py6n9E8GK/bv8ChLkJT6aJ7dpWgpnL8Z0r0P0Zh9l1LfehtJGATHnujY8R+aOfdUz3lsfUypebsM6+jx25iwZmKGkncp4jO4AIzzJRmvhMqgl6n5iKVZqWlyrN/GBlvpXCqnjHMqv0EZWYLZjZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rhVJm0Mo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhVJm0Mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E646C4AF1C;
	Tue, 27 Aug 2024 15:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770851;
	bh=44oT7pECC/MNJDxqoCh5/q+alw7Di+E+tQTwlXZ6t3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhVJm0MoSV8pCdLJUlrAF4rKwAbcOTk7ptijpYAU/Egbz/u3PcRJaLCitjgMdJOhA
	 mrKKub8tFwYBzDrDeMs2XhAXFHlm7F1LCGLLUMhXbOWlMJ+uVAH/fKe2Pw9/g//V5u
	 aC/iL0EAoPiWYMwjp+bLDj54GEz4dcMGXQoGQoVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 6.10 012/273] char: xillybus: Refine workqueue handling
Date: Tue, 27 Aug 2024 16:35:36 +0200
Message-ID: <20240827143833.852270692@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2093,9 +2093,11 @@ static int xillyusb_discovery(struct usb
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
 
@@ -2274,9 +2276,9 @@ static int __init xillyusb_init(void)
 
 static void __exit xillyusb_exit(void)
 {
-	destroy_workqueue(wakeup_wq);
-
 	usb_deregister(&xillyusb_driver);
+
+	destroy_workqueue(wakeup_wq);
 }
 
 module_init(xillyusb_init);


