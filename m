Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F078275103;
	Tue, 15 Jul 2025 13:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587469; cv=none; b=feMm74iLT/+sFrjZ+jLp9soEGjVktQ11NaK1YEShbMwo5XcakNncsJEThpnMHLOapdjdpc/gMtEM1OzTeEy5qRrs+2SGj0EiYbbuYr+8/8JBPZoekOU+y/U+T7nn6w18G/04lXK4ICLF/Zro4eFHre6nzmCfzqpKCxC+7VqZoAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587469; c=relaxed/simple;
	bh=SwoiG5uazfQuiGpKwsYQ37B74a1ppQWqgxlAthxIbVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0uWLhW8/Aj1U3lRnw0dRYEVhvSFEBm5apSh8wkBpKjkjQA0W9bU9OqVzExZ1X3BDADvev/Isvu+QhiIh3BgIR6CduPCMnqeSb19kRM12O8t4fG9/IHgvFEsoklpiLOFNemSCxtosq4eb6POaKH9f+we4EL1iI3mtfC8e7dvFFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eo9twn8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eo9twn8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94690C4CEE3;
	Tue, 15 Jul 2025 13:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587468;
	bh=SwoiG5uazfQuiGpKwsYQ37B74a1ppQWqgxlAthxIbVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eo9twn8PL5AcA66i3+5YNSSKwNboVoOubqAcSmpgQ3CqEKgYmMNpam32VGI+4ZPaY
	 VNsCHtcCeTjBKww+ScwtcsqRzc9r17huFbPECfsJSi7FgOcVD5OBUKqIak0Q9Ec9sW
	 VIOt4EmyH6D9yryCwWW1t+A4gsSRvvnSL/gMBoQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/208] usb: usbtmc: Fix read_stb function and get_stb ioctl
Date: Tue, 15 Jul 2025 15:12:12 +0200
Message-ID: <20250715130811.765109583@linuxfoundation.org>
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

[ Upstream commit acb3dac2805d3342ded7dbbd164add32bbfdf21c ]

The usbtmc488_ioctl_read_stb function relied on a positive return from
usbtmc_get_stb to reset the srq condition in the driver. The
USBTMC_IOCTL_GET_STB case tested for a positive return to return the stb
to the user.

Commit: <cac01bd178d6> ("usb: usbtmc: Fix erroneous get_stb ioctl
error returns") changed the return value of usbtmc_get_stb to 0 on
success instead of returning the value of usb_control_msg which is
positive in the normal case. This change caused the function
usbtmc488_ioctl_read_stb and the USBTMC_IOCTL_GET_STB ioctl to no
longer function correctly.

Change the test in usbtmc488_ioctl_read_stb to test for failure
first and return the failure code immediately.
Change the test for the USBTMC_IOCTL_GET_STB ioctl to test for 0
instead of a positive value.

Fixes: cac01bd178d6 ("usb: usbtmc: Fix erroneous get_stb ioctl error returns")
Cc: stable@vger.kernel.org
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250521121656.18174-3-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/usbtmc.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 093040ea7e065..fe1152e7053f4 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -565,14 +565,15 @@ static int usbtmc488_ioctl_read_stb(struct usbtmc_file_data *file_data,
 
 	rv = usbtmc_get_stb(file_data, &stb);
 
-	if (rv > 0) {
-		srq_asserted = atomic_xchg(&file_data->srq_asserted,
-					srq_asserted);
-		if (srq_asserted)
-			stb |= 0x40; /* Set RQS bit */
+	if (rv < 0)
+		return rv;
+
+	srq_asserted = atomic_xchg(&file_data->srq_asserted, srq_asserted);
+	if (srq_asserted)
+		stb |= 0x40; /* Set RQS bit */
+
+	rv = put_user(stb, (__u8 __user *)arg);
 
-		rv = put_user(stb, (__u8 __user *)arg);
-	}
 	return rv;
 
 }
@@ -2175,7 +2176,7 @@ static long usbtmc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	case USBTMC_IOCTL_GET_STB:
 		retval = usbtmc_get_stb(file_data, &tmp_byte);
-		if (retval > 0)
+		if (!retval)
 			retval = put_user(tmp_byte, (__u8 __user *)arg);
 		break;
 
-- 
2.39.5



