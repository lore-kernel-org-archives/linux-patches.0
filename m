Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4434E248BB0;
	Wed, 15 Jan 2025 10:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938789; cv=none; b=bbfwCd1JbWj95+y+aV21W8/W/RzkZtd3ruaAljl/9lTr80m5Fm0APP9PwXpFI6tjFqkslgluXZ1JEbZBDDg44JZbGczRFMbZY6ui4cFWIXxTcywhcmtwsMtg+zudaeLgh2LKAr8Gi9D2nTGJW3u+MD5JY96lY8U94Tg+D1qW5CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938789; c=relaxed/simple;
	bh=rA+mUKiJI69pim4TCDDoSOl33S3cobNgb29korjCwFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhdL++f7BOVd7DHkubshVgHFrYG7T+bDSDP/NahbCCAhMJKXbDnYjcorxUl1ZE0vmB/qBhFlWkWZSLQMDXTIfKypFShW0daO9rtvmOjA8oGQ6aJxXZGYCibluBH9Q9ASn26Jqv3qvOoVfjm7Y7gZu9hhfqppW0+AyKNGDlWMBJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSi2LW/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSi2LW/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9D4C4CEDF;
	Wed, 15 Jan 2025 10:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938788;
	bh=rA+mUKiJI69pim4TCDDoSOl33S3cobNgb29korjCwFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSi2LW/VAdN4R6lbyUQU9Q/qHTK64L9Xc8jyrY20D4R+YUztjFcsG07tkn7o0kuCq
	 +Ib7TsAXEnM0v8veyHdOZ7RybfIsDRA7aLHYyMxxC0zzMRM23WbWJL+0tkPKZ85UM0
	 i9zyuEhzJGFckiruYR0z5AUziMT+n4gBG9v/mTkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <quic_prashk@quicinc.com>
Subject: [PATCH 6.6 098/129] usb: gadget: f_uac2: Fix incorrect setting of bNumEndpoints
Date: Wed, 15 Jan 2025 11:37:53 +0100
Message-ID: <20250115103558.272377573@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: Prashanth K <quic_prashk@quicinc.com>

commit 057bd54dfcf68b1f67e6dfc32a47a72e12198495 upstream.

Currently afunc_bind sets std_ac_if_desc.bNumEndpoints to 1 if
controls (mute/volume) are enabled. During next afunc_bind call,
bNumEndpoints would be unchanged and incorrectly set to 1 even
if the controls aren't enabled.

Fix this by resetting the value of bNumEndpoints to 0 on every
afunc_bind call.

Fixes: eaf6cbe09920 ("usb: gadget: f_uac2: add volume and mute support")
Cc: stable <stable@kernel.org>
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Link: https://lore.kernel.org/r/20241211115915.159864-1-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -1176,6 +1176,7 @@ afunc_bind(struct usb_configuration *cfg
 		uac2->as_in_alt = 0;
 	}
 
+	std_ac_if_desc.bNumEndpoints = 0;
 	if (FUOUT_EN(uac2_opts) || FUIN_EN(uac2_opts)) {
 		uac2->int_ep = usb_ep_autoconfig(gadget, &fs_ep_int_desc);
 		if (!uac2->int_ep) {


