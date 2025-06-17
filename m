Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C369418E025;
	Tue, 17 Jun 2025 16:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177077; cv=none; b=mkTRNJarz2su69SSpg7oCgseDRUUMk06f4zsyReGvTQciv9Lr5PcVFE06sAOM8BTlhUSQp4NAFTuMHx7lX36eUQyb4rK9Wly1CwkAkR6WnhVT2X4orsAsQT7YKgazZYxUAHJJ0JVwkmcR85btG8XA7/gRBAZLBM8mJcvZ1vGP6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177077; c=relaxed/simple;
	bh=OrBA8WF8Sf7zrRqb+W9E777Z8AaP3rJlmZzI6s/x114=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdD+CJiCITK6PBH3m9A7EeARSuKJRJVWNGjB05Gobe5VUz70pBPxGss0oqMCgMWBxzC4hYgBC8ICEnbSDONKt76RVt0jSO0a1vPnmpPDO75FidovFuhgIKm23Aoq3hAvLK9Y35k5hLfZeXlOyz4K/IVlIylrLDmTxi0F8FcZm1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpAnTS4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpAnTS4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331DDC4CEE3;
	Tue, 17 Jun 2025 16:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177077;
	bh=OrBA8WF8Sf7zrRqb+W9E777Z8AaP3rJlmZzI6s/x114=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpAnTS4kHTfbxfUvLg4PhVbA9dv2JZEMrA7213r/FLPGMmSp+xeAqdnCYSGfPPbO1
	 K1OH+z89iVqInk65ILyyeEMSKkRbEWam7FNRvsH0IYMPqBOgY9/Y/zwPCtzJjUhuxP
	 xmf4jgpnLA3hxYihFJ3zoerJc9QQWVnXsYFP9tgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 6.6 345/356] usb: usbtmc: Fix read_stb function and get_stb ioctl
Date: Tue, 17 Jun 2025 17:27:40 +0200
Message-ID: <20250617152352.027254037@linuxfoundation.org>
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

commit acb3dac2805d3342ded7dbbd164add32bbfdf21c upstream.

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
---
 drivers/usb/class/usbtmc.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -565,14 +565,15 @@ static int usbtmc488_ioctl_read_stb(stru
 
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
@@ -2201,7 +2202,7 @@ static long usbtmc_ioctl(struct file *fi
 
 	case USBTMC_IOCTL_GET_STB:
 		retval = usbtmc_get_stb(file_data, &tmp_byte);
-		if (retval > 0)
+		if (!retval)
 			retval = put_user(tmp_byte, (__u8 __user *)arg);
 		break;
 


