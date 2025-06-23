Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3E0C2E0;
	Mon, 23 Jun 2025 21:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714282; cv=none; b=COhl5TXDMgNXeGT4xuwNdiAeMETqjh+JhAptFNIH8aTbogaZv7A4/xdO4kPOgpT6s42zS3qglnA74kX6oOV/doqo2gA5w96titSCsBJ25omzF6AGS9QT703QT41rdh25D5YOwnFZ/jezBCXd0G4Fsed3Iqe1TzdJfFCfXyC7byc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714282; c=relaxed/simple;
	bh=9VISglJNjYu13TbqizywU0Hb8a7S9R49wbwM58X9Baw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKGBk2fvv29g5u7uQdG7/c7VTnVt0L5NGR7un+qiNlo5xxJC3p/KuoAxBs9WzbBX8Q7yUYxRD7Q3+HvMaJ/Pc8zNYmbF+L4LyPwjc1PCHGbW3HBp+OrnDwXveRc210mG+kZlzV7YQJUBtTe3VHek7EYZzh6IHuPZW8Q9ZGfo+DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0k5vgcVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0k5vgcVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CB8C4CEEA;
	Mon, 23 Jun 2025 21:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714282;
	bh=9VISglJNjYu13TbqizywU0Hb8a7S9R49wbwM58X9Baw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0k5vgcVXBmSY8kDKA03PUHfyqQ8CiQ4KhxvRqIthdb9EBAd9B/mWyEr5JYaxEC4M2
	 hIx/OwqnhnD3ao9q3Xo1+NC7ljqHBhshNXf9acGbRYpVCFi3H0nzo0KgtujFmcBZh1
	 Rjm1dgfaPB49I9ypyQVS1MX8kXl5nLqrQ9VfiEMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 5.15 178/411] usb: usbtmc: Fix read_stb function and get_stb ioctl
Date: Mon, 23 Jun 2025 15:05:22 +0200
Message-ID: <20250623130638.166735600@linuxfoundation.org>
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
 


