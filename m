Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93B5275103;
	Tue, 15 Jul 2025 13:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587466; cv=none; b=jTwmlZhAsT6dokur0rdcoggIx403QntZpp86TWr0sGc51SQChmM3LDjMObmOZNtq2m7FuOZQHKJlJ5u+OvxW0aZ80IBeCeBrdZ49KJ23OEUs6X+Iw+3IscJnEJZRRSFDu/L5EHnTpjqJR7Ek1yUjb+WmI6nkjk29Q01REHssaic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587466; c=relaxed/simple;
	bh=3hBJrp2Cqfe/anng+xqysnrTD6ID55WZBOIAYYCZw54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEe30kTCkYkuHzgFAaMjyiPyWFA5HF+JKLcVwIfRbxgassau5bFe1PNI8FwlWzav3HukvriKm6PvvEddrUNZ4oR76Z/vQBMJWVBJybKbeqwTFzU/2Gl+7AXxT6rIj2b7p2qUz4HUc3yKZR8ByNbW0UF8XMFLKJ3VpZOU6I7d8UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+oWZfJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+oWZfJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B44C4CEE3;
	Tue, 15 Jul 2025 13:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587466;
	bh=3hBJrp2Cqfe/anng+xqysnrTD6ID55WZBOIAYYCZw54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+oWZfJxu51+mh1Pe059QJo/VcKbY+gzwHVzInZW4cx737pESiQX/20d3saaSRdiT
	 flkf3t97trWXvX4TXAA5qQKszellOqPgKZt67EGyob4ph+0Wp3ASoEUipqOD8Tumfp
	 d0y4R320rqk9FujMNuZMTphJ5fv7XtyT910RxN7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian-Wei Wu <jian-wei_wu@keysight.com>,
	Guido Kiener <guido.kiener@rohde-schwarz.com>,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/208] USB: usbtmc: Add USBTMC_IOCTL_GET_STB
Date: Tue, 15 Jul 2025 15:12:11 +0200
Message-ID: <20250715130811.725344645@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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
index bfd99d461f813..093040ea7e065 100644
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



