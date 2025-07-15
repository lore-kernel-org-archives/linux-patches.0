Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F350E2E7BBC;
	Tue, 15 Jul 2025 13:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586309; cv=none; b=CeHwD8C+KcbCWySBX+HeqD6eC8jRQiZWPcP/dFIbJAJk5f4x8W22FDIfiaSzine3rQGS54Zic1CUoBcYXwmq4zJD8NEPhUqHWvS/Ji2qEgf/HesPCOMLrwaiCrO27RszjcPM4gVWdWvyNDC27aESKrt5kLQMWMgs0mjVwsQEdYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586309; c=relaxed/simple;
	bh=Pqtly/oCySKYocrWwkE3DBcxcBw8SQM8e8mhxAzIyCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbRHpCE3qfWWxneyTsUfvJmvkFsa4O9iFlBfJyvJI/c2FS8GoWM94jsvGRhgaxY5uxeBVocxaSbG9T/hJgx6dnFxzwsbPBTw4/o19in/Hl2uCToGkj1M3TuAvYJXG0m6gekDk9OE1RHUTXmkNNx6t4e+fbP4PoyLDid1VucbqqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VS11ILsr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VS11ILsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBA6C4CEE3;
	Tue, 15 Jul 2025 13:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586308;
	bh=Pqtly/oCySKYocrWwkE3DBcxcBw8SQM8e8mhxAzIyCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VS11ILsrZ5wzUd8dSnpmojY2jcJAlO6Uv+NvK9/U2Ri2C1CHx9aVK19KIW6ZSDSlg
	 fgY8io/66BPI0cmAvS6DKP/vT+0s+++/K1w1fLh97DF0d66Fhdf/kKlWFMVkjJqUAM
	 D+cS/wKjtwgT277jdC0j5XDNaczQ9G3stUGAN5Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/148] usb: usbtmc: Fix read_stb function and get_stb ioctl
Date: Tue, 15 Jul 2025 15:12:19 +0200
Message-ID: <20250715130800.996282267@linuxfoundation.org>
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
index 738ef160109bf..9f084058b1956 100644
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



