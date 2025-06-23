Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF85253F1D;
	Mon, 23 Jun 2025 13:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684669; cv=none; b=cOy7J+hiCjvqWOeI9LGseLCLjXJzRINCQ0ACe+B/uVhiJ8C+msnjYKCfln7F4BK/qV43XH7gL6vPSCVmsDNL2tKO2FKrb+eSkh6+o2t6Ds2r9V2tywsMqHH/AMeIFk5QxRjfP7IOBNcbs84t9sH5xWxBWsuyRa0OR0+dwR253Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684669; c=relaxed/simple;
	bh=4GyHpOOMqRBpZaB67q6Kr8Wr9HZZbiYoksOhd9xFVPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgvOMneJGTvLNyQULFDzpFX/daw44g/YY97EVuFL2W1hwMjbJMJdZiVBMiyMsTvmnC0kbocbQIE7DtmyVYj4KFWFiWxWR3wf5eIoIKqRzAqGCJsXBCym0aRzDe1sD+PdR1qe8kAuzBNVwvBbx6kpo+BnXS1ltRFgD49HVUMfphM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q90Lnfcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q90Lnfcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33FEC4CEEA;
	Mon, 23 Jun 2025 13:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684669;
	bh=4GyHpOOMqRBpZaB67q6Kr8Wr9HZZbiYoksOhd9xFVPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q90LnfcmuJA5aHeFdVvBvH7f1MEzO/Bh3MC5etY5hbzz60wXlTxOEfZ9/iNvKfsD1
	 1BdaNnAJewqW2vxlj6rEc588oyysUjvButzndT7/3JudHoD1Dm2UaRAxPakhHh+tQR
	 AKRXCCIlAtiU7g0oLsacyaLFdHwCjFMUd6PEZDwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 5.4 006/222] usb: usbtmc: Fix timeout value in get_stb
Date: Mon, 23 Jun 2025 15:05:41 +0200
Message-ID: <20250623130612.091086329@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -486,6 +486,7 @@ static int usbtmc488_ioctl_read_stb(stru
 	__u8 stb;
 	int rv;
 	long wait_rv;
+	unsigned long expire;
 
 	dev_dbg(dev, "Enter ioctl_read_stb iin_ep_present: %d\n",
 		data->iin_ep_present);
@@ -528,10 +529,11 @@ static int usbtmc488_ioctl_read_stb(stru
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


