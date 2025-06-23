Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E69D4C7F;
	Mon, 23 Jun 2025 13:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685131; cv=none; b=RXJ+JRoavQ9Gn4JWuYOL70ffLOPLJGb8G8gzBQLCuHMd+8kRnw4l3Xln48fM65B2r+YUMdRPxLEjLXjPkAmWGGxyQ3sTA7qWyE58DfsxK6FrqlSBHGWOKurqzOwUZT9TXqVFxdVgutH8iLT6kFvcPEZraBV0wGhLEJCnt53kcCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685131; c=relaxed/simple;
	bh=RlAJpMo0A+UE442BaxHNezXSie+Bf3Eyid1LmPb1JQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmJ8xBbdYFR6Zk2EK5JAc/UBWFgZG51L9S9DWIhQGOXzMcgbikK36hZTxt2Z4zTnLEWvGvL8j6bDr8HUrU+xpyjx9UBJFGdlDQjqHYm4Ji++9aXHDAfMWEY9IRmoNu3Yz4LZlmavq5lE/vUOBCDIb7W0r9cGGmkR7F3FUGadR9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cexON60Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cexON60Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02916C4CEEA;
	Mon, 23 Jun 2025 13:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685131;
	bh=RlAJpMo0A+UE442BaxHNezXSie+Bf3Eyid1LmPb1JQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cexON60YOxTmMV/67Myw61+EEyFOHFanlnWNivpsd7K2HKNvPJ/BSV3bwl2Jh2lF6
	 Ii+nTLLXbsb7wnyTx9DEdKqYBWx9qcPraituPvX2jr100yPZsBzRXhhytK0mMYmBFl
	 LvJufSecRf/j/XFE/+lgvg4Xxc+bv+uKMe+uVNYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 5.15 010/411] usb: usbtmc: Fix timeout value in get_stb
Date: Mon, 23 Jun 2025 15:02:34 +0200
Message-ID: <20250623130633.298070929@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dave Penkler <dpenkler@gmail.com>

commit 342e4955a1f1ce28c70a589999b76365082dbf10 upstream.

wait_event_interruptible_timeout requires a timeout argument
in units of jiffies. It was being called in usbtmc_get_stb
with the usb timeout value which is in units of milliseconds.

Pass the timeout argument converted to jiffies.

Fixes: 048c6d88a021 ("usb: usbtmc: Add ioctls to set/get usb timeout")
Cc: stable@vger.kernel.org
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250521121656.18174-4-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -483,6 +483,7 @@ static int usbtmc_get_stb(struct usbtmc_
 	u8 tag;
 	int rv;
 	long wait_rv;
+	unsigned long expire;
 
 	dev_dbg(dev, "Enter ioctl_read_stb iin_ep_present: %d\n",
 		data->iin_ep_present);
@@ -512,10 +513,11 @@ static int usbtmc_get_stb(struct usbtmc_
 	}
 
 	if (data->iin_ep_present) {
+		expire = msecs_to_jiffies(file_data->timeout);
 		wait_rv = wait_event_interruptible_timeout(
 			data->waitq,
 			atomic_read(&data->iin_data_valid) != 0,
-			file_data->timeout);
+			expire);
 		if (wait_rv < 0) {
 			dev_dbg(dev, "wait interrupted %ld\n", wait_rv);
 			rv = wait_rv;


