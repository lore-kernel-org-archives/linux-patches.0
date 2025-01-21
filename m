Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26A91F7064;
	Tue, 21 Jan 2025 18:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482909; cv=none; b=ioiLRT8ho7QHLf3SO/7ZzBWx/THMP+RJrhCki7szqG3bkCX5rGNUCMTDjnRCarEBQ1J2e+rS4gaqd2jgpuQvrTmZHJbtz7knovY9Ye5UBHsLdcAKF3lcTeRq7QWNp//UVWoFzlUjrwzQRNYmbDuWc2z/bwAKb3ejrqdEHC4gDqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482909; c=relaxed/simple;
	bh=w/UO+j0UUMHIVNNgLsWi8/9mVYVfQfsYIwFcOVuv9q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcHmDh1xdTCMFUqwruYbN8koSC0ubKFxfKXoRRBoH9fxEytAUa1gVYm+dgX5B8r2P8Y0AmfYUFbjVL+QjYplvybOoKpR38vrOowdYzeZfRxxO/Kgi/+AxdFvfBLfbvV7bbEB5Nz1PEuvVGzoMCrl25t2mdNdDd60AYSOBSKa7+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G83Y5fbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G83Y5fbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44552C4CEDF;
	Tue, 21 Jan 2025 18:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482909;
	bh=w/UO+j0UUMHIVNNgLsWi8/9mVYVfQfsYIwFcOVuv9q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G83Y5fbny0xD5EvhiN2F1LatTr5riUzgyWw7HJhxjXqFyTH5QEtpgX1xHaBKDISin
	 mHK8COZECJX8Ydd9/RL1z/Pt6XQn/xWtotbJZ2xdYnyA4+iuHH2VfQHuHqVnZGaFCp
	 +sS4PhQ2uXjnurnyz8HlhDPB8ESuumHCvAxNYURY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <quic_prashk@quicinc.com>
Subject: [PATCH 5.15 051/127] usb: gadget: f_uac2: Fix incorrect setting of bNumEndpoints
Date: Tue, 21 Jan 2025 18:52:03 +0100
Message-ID: <20250121174531.636271985@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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
@@ -1103,6 +1103,7 @@ afunc_bind(struct usb_configuration *cfg
 		uac2->as_in_alt = 0;
 	}
 
+	std_ac_if_desc.bNumEndpoints = 0;
 	if (FUOUT_EN(uac2_opts) || FUIN_EN(uac2_opts)) {
 		uac2->int_ep = usb_ep_autoconfig(gadget, &fs_ep_int_desc);
 		if (!uac2->int_ep) {


