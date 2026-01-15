Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF483C1FD9;
	Thu, 15 Jan 2026 17:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499559; cv=none; b=TB7n5f5Kg/XzWt7+xaUPIG454Fn/CCq8UdtdT62vfo8nUdC97OrhSbALPXUzCs6cSN7AReV2AU1vewHE/zGgk+bZGLmcVPjWH+UadLcSWhJDQlr0R4RGj5utXaF/MBpfJGeHRPYHnMAmG+EWoECU7P7YorQsueOeXGKpGb6a8Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499559; c=relaxed/simple;
	bh=Tm7J+cdUPdBPQkFIXnIM5AXVY8lAZTCP/1tzOtx/06M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TyVxhwHpWt7cHkyDsRYyLjaKQ5OPLpUrCrsFX9Ppv3X5O5PHQ75GXbj5sSh3HrtV2PSDoa5HcNneL8HOrGIr3SkJm33t5fpM8LdtAc8FXB2F5vgTfUnfxQOC8KhPGn3hX6XWIGfCSQESdRqhxQJNyql1FujBHYmiwgy5+1Eg5z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4Rp4Rl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4Rp4Rl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA69C116D0;
	Thu, 15 Jan 2026 17:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499559;
	bh=Tm7J+cdUPdBPQkFIXnIM5AXVY8lAZTCP/1tzOtx/06M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4Rp4Rl+Zn5W5ylVDQgtd79N2mi6/b0Ow8WMGMWrHIcUufGPEnJMSAgolGBhYT3nY
	 dMHro3fJgzi7hQkZ0BsqJcO/v8WW4ixuX3fZPyZ+/AZJy/2FeMpiyDlae6KAVW8pZd
	 z0O25cPEruPRFqsP2vU9KlaXziX6CIAhz0e/8iAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH 5.10 236/451] usb: renesas_usbhs: Fix a resource leak in usbhs_pipe_malloc()
Date: Thu, 15 Jan 2026 17:47:17 +0100
Message-ID: <20260115164239.431516628@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


