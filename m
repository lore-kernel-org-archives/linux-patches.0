Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D214720A5F2;
	Sat,  7 Jun 2025 10:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291108; cv=none; b=aXi94E9n53jsH0T9n3uvs/+N9hCrZ9/sNyle1z3R19WIXhFYo1Nx7WvipffY9c9Jg1LBvaodWJvdaEe3dGwA6OuP8eWidUEs2RroGaFgE/ayYAURD6cA3goe3X1kO4WU6MzjWQmPLtaeNxriUC5sOsMaZGs399f5l2zxsiyxIAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291108; c=relaxed/simple;
	bh=1bHPnNsD8VU3nM6HYlkcQSIeMb/pm4rX5ZQdaTr1PJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCMnyJBrRUUD/PN4DVfUxZZYtaQyJLtov9nbLzDPagCEyn4Nxbut01Sbvcvz+hKHl6Om5sOKQQoNQs79yNUjIUxHgoBpL5NnRTzEQfkOQ9GcqgE6gjMpix7K9IeyrJTYqIwPDD0oIxHJuGe3Z1/1DzV0qf4AM3kSGdQEPgTZ7Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4qGPK2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4qGPK2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645B5C4CEE4;
	Sat,  7 Jun 2025 10:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291108;
	bh=1bHPnNsD8VU3nM6HYlkcQSIeMb/pm4rX5ZQdaTr1PJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4qGPK2p8wKJqDiPypwsv5HzuORsmsp1F3+N51DZNsGLjE7dpyLd/I3JjQSBfjhF7
	 PlxR7KgsWQJj/3LaPUJ5SB+KlkG7nyTDeqsninNGbLEX5cs6HrjYe6Nn56MYP1LCil
	 hrHshv6wFK3ah6yrazica3WkqC+beHBV4o+UmxZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 6.15 26/34] usb: usbtmc: Fix timeout value in get_stb
Date: Sat,  7 Jun 2025 12:08:07 +0200
Message-ID: <20250607100720.742049318@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


