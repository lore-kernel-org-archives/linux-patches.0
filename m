Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEAF40DFD4;
	Mon,  4 May 2026 14:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903742; cv=none; b=m4CS+tPhPj69im4op2CI4uzSW0L2ilqpH1fQy6alkO5k6MLDlRXg7IRFqHc5gaohcv2bp0sRCwnF3hSo4d4TfYrlytACpiPHNJ/f4ede8wzA1Y/WkkvU9Tnz6ke7zqQgOKJj5ahZ+e2gA4jHCcc24XJKe+8MHLVdfJzQL1U/ZXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903742; c=relaxed/simple;
	bh=LzzIJ5xmK/yZvHdwhNTjFWW9GYEwfAdyXbE8b+e6tJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaT1NqyBp1G/SOlgdWqxNav71peTfJhdjfFQ/AB4Qq1EfV+lJaCLVeppDnZrBT0OwUz0sfMgAZfaHFEW+8wlQqmhcB0mD1mv9ylrmr2iXY4q+Rd/VGW0kqdXjY0PUkGuzvvsq4Mbr0kjxjpeb4IYgE+S2iEQS3l5o9LhdKjG70I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJ0aK/be; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJ0aK/be"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A0AC2BCB8;
	Mon,  4 May 2026 14:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903742;
	bh=LzzIJ5xmK/yZvHdwhNTjFWW9GYEwfAdyXbE8b+e6tJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJ0aK/beVx/zC/Pb4LxAwsKny8xt7DzepBs5ctgSc0JIIKGnsyS55KPmDVXZsXC9t
	 mlWyO3Qd8nxzkBwet9RF8JI7vRmT2WQkLlfNqJtRAfSLqJRbfSjT37aYuYCSVzfg8Z
	 RXl32sT5Z2VVFpwvzLW8nf+uIQ7+QfTltQTLhVNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 044/275] hwmon: (powerz) Fix missing usb_kill_urb() on signal interrupt
Date: Mon,  4 May 2026 15:49:44 +0200
Message-ID: <20260504135144.578997502@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

commit b66437cb20a2d9ef201f40b675569f8ea7787c9f upstream.

wait_for_completion_interruptible_timeout() returns -ERESTARTSYS when
interrupted. This needs to abort the URB and return an error. No data
has been received from the device so any reads from the transfer
buffer are invalid.

The original code tests !ret, which only catches the timeout case (0).
On signal delivery (-ERESTARTSYS), !ret is false so the function skips
usb_kill_urb() and falls through to read from the unfilled transfer
buffer.

Fix by capturing the return value into a long (matching the function
return type) and handling signal (negative) and timeout (zero) cases
with separate checks that both call usb_kill_urb() before returning.

Fixes: 4381a36abdf1c ("hwmon: add POWER-Z driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260410002521.422645-3-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/powerz.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/powerz.c
+++ b/drivers/hwmon/powerz.c
@@ -106,6 +106,7 @@ static void powerz_usb_cmd_complete(stru
 
 static int powerz_read_data(struct usb_device *udev, struct powerz_priv *priv)
 {
+	long rc;
 	int ret;
 
 	if (!priv->urb)
@@ -127,8 +128,14 @@ static int powerz_read_data(struct usb_d
 	if (ret)
 		return ret;
 
-	if (!wait_for_completion_interruptible_timeout
-	    (&priv->completion, msecs_to_jiffies(5))) {
+	rc = wait_for_completion_interruptible_timeout(&priv->completion,
+						       msecs_to_jiffies(5));
+	if (rc < 0) {
+		usb_kill_urb(priv->urb);
+		return rc;
+	}
+
+	if (rc == 0) {
 		usb_kill_urb(priv->urb);
 		return -EIO;
 	}


