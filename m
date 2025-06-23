Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3D4239E63;
	Mon, 23 Jun 2025 13:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684884; cv=none; b=GqcUL+bFZJDXj/8JET6BY3GHBgadBCdb9f4PXxZqVKUUDnZL8+qclpDq+lz6YaB/HqmjIE5Vq8NynIX88j/3ap2mCQZnrAXBB05NPC+F0/Zt+7uP0Zhvq/hrqdETVfQNwAbmn7lf2ktsJX8y1hWAFuPg+9JDGv4+zlDheKc4eeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684884; c=relaxed/simple;
	bh=4YVZxTyqutW+SoM7gN3/Fut+dKNJk/JvIVn1zbg5Fbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqVCyd3vhpij4Y3M9ZJWrtQoHFBfZZoi5Gif3nfkdm6K8Ll1yFwgpG5N/mrFSB2hN+E3XqYVRmzw8qP8YHsuSHEwLRxh9z4ajdqqToe1ENZxpmAQhYYzbt0CC6JwXck0M2un2ATIImNjHh6h2mbnVx9Heoa822LCdeQmYfUUvRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kS65OSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kS65OSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6512EC4CEEA;
	Mon, 23 Jun 2025 13:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684884;
	bh=4YVZxTyqutW+SoM7gN3/Fut+dKNJk/JvIVn1zbg5Fbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kS65OSYBnlYrvc1K2xU6vaoNY036GQz8ZSJ1l5MogiSa7046eGgu7N7Oot/T8FXb
	 UhBI8kNklB6Y6059kwbpF67EYg51cEjpmO1fufgsA3Zb1w3kLbGshUiAxB6Lxzi8fF
	 xSJ0iI56lr8I4SGZrLHbo8B2Gpp6BFaMxd1Tbe7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 5.10 007/355] usb: usbtmc: Fix timeout value in get_stb
Date: Mon, 23 Jun 2025 15:03:28 +0200
Message-ID: <20250623130626.956145842@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


