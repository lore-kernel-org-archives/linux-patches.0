Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E615133372B;
	Fri,  9 Jan 2026 12:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962374; cv=none; b=vEGzHBjqCTSWK6TJOMZat1KhYyEQ/p6mDAXeDXCgBDObXmc7H95dBpTosANhMtpbkJliHdkTCesIxJTt4Sp0NpCN6rqN+uNWr0YsS3XcLd/0XdKfLEXSCb6bjMFm3J0A2i4TY+nLeaDT2r3AOZs1+OZxdElAn0evanPdkziKr4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962374; c=relaxed/simple;
	bh=0UeakuCLLBMCkkHGD291YES4ey8NKfNp+sR8fFIgJMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTQx/FNG+o2NtTnlCxsUvBO16PH+mrf2V7A4lkVPbPKKmIPpAGIugtVHTdApv+hldpaBihAdvkjLUep1giqTsgnRoB7tkWA6HrpLFP4UlIgj8P6Tx1Dp5czVSYx/EpJlxECHGM9qqq23I0Pyz7ESGPRvwfZN7N7ixgqObTwJ6s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7qtlWMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7qtlWMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C6BC4CEF1;
	Fri,  9 Jan 2026 12:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962373;
	bh=0UeakuCLLBMCkkHGD291YES4ey8NKfNp+sR8fFIgJMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7qtlWMooGIehi6p2UCiYlrzcAF6KeUiMuH5k4ID/y/66PaShReYXvI0rjx5XqjCJ
	 3ZaBTgXitvWrrdcoV6HkCfCZk7oi1hiqzAAHqORzV8Iy5E2ZZd7lrwTcEDR6AnWruv
	 lgDWoRAoQ3ZWM7HTWNM/Ab4qq6ce2lqeXVbqYEmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH 6.1 341/634] usb: renesas_usbhs: Fix a resource leak in usbhs_pipe_malloc()
Date: Fri,  9 Jan 2026 12:40:19 +0100
Message-ID: <20260109112130.355597242@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 36cc7e09df9e43db21b46519b740145410dd9f4a upstream.

usbhsp_get_pipe() set pipe's flags to IS_USED. In error paths,
usbhsp_put_pipe() is required to clear pipe's flags to prevent
pipe exhaustion.

Fixes: f1407d5c6624 ("usb: renesas_usbhs: Add Renesas USBHS common code")
Cc: stable <stable@kernel.org>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20251204132129.109234-1-haoxiang_li2024@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/pipe.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/renesas_usbhs/pipe.c
+++ b/drivers/usb/renesas_usbhs/pipe.c
@@ -713,11 +713,13 @@ struct usbhs_pipe *usbhs_pipe_malloc(str
 	/* make sure pipe is not busy */
 	ret = usbhsp_pipe_barrier(pipe);
 	if (ret < 0) {
+		usbhsp_put_pipe(pipe);
 		dev_err(dev, "pipe setup failed %d\n", usbhs_pipe_number(pipe));
 		return NULL;
 	}
 
 	if (usbhsp_setup_pipecfg(pipe, is_host, dir_in, &pipecfg)) {
+		usbhsp_put_pipe(pipe);
 		dev_err(dev, "can't setup pipe\n");
 		return NULL;
 	}


