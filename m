Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B022EB5A8;
	Tue, 17 Jun 2025 15:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174191; cv=none; b=PrOJM4Wd2o2jwrNrJzcQJptrmFL5JJo1gK4zzDUkob+x/QdT8Q7v7x43AjOhMQ8W6TA9Dpp/BbX+o0JpNB3zU/3eYHIKqLTislFMSJBu+JuW81FNFYkJbOs3GBKelG5wSWpwolKH8M6Wq4rsS50L+Lb58uto6SY6P07qVEsLo30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174191; c=relaxed/simple;
	bh=BJKMMHysefZ6AR9d1eYBJMQtTs9VLQ7nMqVFtKntjE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ua01YIpQsMBWcKLwE+rgCEwtoIwVeHcBF0VwnOYi5WIoRDH45E1UzTO3jo0LmAsc+I5eUW4YtLNHV5CwI8oGWcvNX4qxdABVJpq57RcuPktz917X0mlmdkqpfbB+daupQc60i+x4RFdC2kTuIXrnlQ7AgmtPaTVGCIV0eDLzEws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dn/9mhVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dn/9mhVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5315FC4CEE3;
	Tue, 17 Jun 2025 15:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174190;
	bh=BJKMMHysefZ6AR9d1eYBJMQtTs9VLQ7nMqVFtKntjE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dn/9mhVdSxQ/YeArQwtkrS436y4WA9rf//GYABRIDrGl/NdMg5mbw3fcitxB4A1L7
	 Qs5Y7Kek+TW96S4hmQ0qAbqIlQZWHT1TCTAPD6cv3V/7/ixFMIfgPCGCbAH42fJLR7
	 gwgPW7Fs4Ba/c6SvJeeS7ib4EP+By3ttAXXbNBJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 6.6 013/356] usb: usbtmc: Fix timeout value in get_stb
Date: Tue, 17 Jun 2025 17:22:08 +0200
Message-ID: <20250617152338.761642070@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


