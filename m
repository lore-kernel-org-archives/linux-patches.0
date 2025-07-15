Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582762E7635;
	Tue, 15 Jul 2025 13:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586306; cv=none; b=AqaVx23787Bl3taggK+TdtVX0t7v52wP79htcRfetopkzLhF2QQ4Cl625vqIGwa5al/qHj2+SJG5BoTWptl24nUO5MPn/orvEuWXba4rzzq4s0Nf1CHjQhBSxztCcb1NICWF3nEApbh6hy0qzcmRX1Aup716lhgoLa1/Nlq2thM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586306; c=relaxed/simple;
	bh=rIbOb0H7sHjmvGVpWqrSs8bZhYGqTyuDApaFNuxSSmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tig30kXB2VHYXtLyIks1TOp7U/S/ITA4uuhsB/wnGY19Tv2UHCj4ZcbxM5LHJLR5aPC6K/36MYe4MZ3u72C1Wcr6KxeH+0UjD5hwzALur9sgBzfzmojXocMg1GB0767ivRksTVxhKoPFsaVNiyd4CLwLcFmpjdjmqVhPiwgyT34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uiyu3Oqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uiyu3Oqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0982C4CEE3;
	Tue, 15 Jul 2025 13:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586306;
	bh=rIbOb0H7sHjmvGVpWqrSs8bZhYGqTyuDApaFNuxSSmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uiyu3Oqakjizpu98hdeCIqP/vF7ZfowtMquN+YKymwLtv7kh82BZKMjMvwe5TZRC6
	 6EBhmookwc6jR53wMKU6lRw3B9v/K/AppTNevHe6hdu3ra4XBVas2byjxVthqWL5TI
	 a+D0Ifb2m56N1ywHq2B/rfrTVjjyPxS5sC15TV2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian-Wei Wu <jian-wei_wu@keysight.com>,
	Guido Kiener <guido.kiener@rohde-schwarz.com>,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/148] USB: usbtmc: Add USBTMC_IOCTL_GET_STB
Date: Tue, 15 Jul 2025 15:12:18 +0200
Message-ID: <20250715130800.957606221@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

[ Upstream commit c9784e23c1020e63d6dba5e10ca8bf3d8b85c19c ]

This new ioctl reads the status byte (STB) from the device and returns
the STB unmodified to the application. The srq_asserted bit is not taken
into account and not changed.

This ioctl is useful to support non USBTMC-488 compliant devices.

Tested-by: Jian-Wei Wu <jian-wei_wu@keysight.com>
Reviewed-by: Guido Kiener <guido.kiener@rohde-schwarz.com>
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20201215155621.9592-3-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: acb3dac2805d ("usb: usbtmc: Fix read_stb function and get_stb ioctl")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/usbtmc.c   | 6 ++++++
 include/uapi/linux/usb/tmc.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index d47ec01d29778..738ef160109bf 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -2173,6 +2173,12 @@ static long usbtmc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			file_data->auto_abort = !!tmp_byte;
 		break;
 
+	case USBTMC_IOCTL_GET_STB:
+		retval = usbtmc_get_stb(file_data, &tmp_byte);
+		if (retval > 0)
+			retval = put_user(tmp_byte, (__u8 __user *)arg);
+		break;
+
 	case USBTMC_IOCTL_CANCEL_IO:
 		retval = usbtmc_ioctl_cancel_io(file_data);
 		break;
diff --git a/include/uapi/linux/usb/tmc.h b/include/uapi/linux/usb/tmc.h
index fdd4d88a7b95d..1e7878fe591f4 100644
--- a/include/uapi/linux/usb/tmc.h
+++ b/include/uapi/linux/usb/tmc.h
@@ -102,6 +102,8 @@ struct usbtmc_message {
 #define USBTMC_IOCTL_MSG_IN_ATTR	_IOR(USBTMC_IOC_NR, 24, __u8)
 #define USBTMC_IOCTL_AUTO_ABORT		_IOW(USBTMC_IOC_NR, 25, __u8)
 
+#define USBTMC_IOCTL_GET_STB            _IOR(USBTMC_IOC_NR, 26, __u8)
+
 /* Cancel and cleanup asynchronous calls */
 #define USBTMC_IOCTL_CANCEL_IO		_IO(USBTMC_IOC_NR, 35)
 #define USBTMC_IOCTL_CLEANUP_IO		_IO(USBTMC_IOC_NR, 36)
-- 
2.39.5



