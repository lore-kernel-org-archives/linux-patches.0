Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C9F347C6;
	Mon, 29 Dec 2025 16:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025665; cv=none; b=bxKMLrSFzJ8JQXvVSQQCmFVVXERM6yrDLv8B3uOw4EfHH+aK75cqAS1tDRnkqNQ/gy6hDR2DZeMIkt82/RXhdrT12YYHLNHyCRGuuK/Ub/POPP7928V+vA213nKbray5SbojoinNsLoHtDJrL3H3vVDCmL7ftICXL0Fo25jxkPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025665; c=relaxed/simple;
	bh=yqoVLaFryfKVsVPplWAaJeAMAMuWKzfc+JyAuxPt5b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A08hSwzj8pMOMIt0iz4i8bG/8uMY8BkAImvvH4k8NI5fIdK+cdnuy0gBIt+Z18Z8LiXgvOMYfkZtlBqYaTyOg1b0UuV/drOiKUJ+M64Ha9yVqRl2Sm8pqCrkoFzYfiYBKYHBlsjvrI3QDJyC0iAf4RY7K/at/HZP9woT66+ykAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9649+dt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9649+dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEDCC4CEF7;
	Mon, 29 Dec 2025 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025664;
	bh=yqoVLaFryfKVsVPplWAaJeAMAMuWKzfc+JyAuxPt5b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9649+dthbtfBHZmEklbUJPRd+nGb0ggHZfWCCg1TT+stQh/4K3Ta3Tb5LluHq1e/
	 82h/u3V2dvuD7wEfSCwr7i8JjNVqKwQ1qu3RMbzMIq/8L/LAZKYaYkd7AtaZC9MmT6
	 5oRd7lUgSCJTBPh9fAFbFubQM5dhzcGV3SIPhrOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH 6.18 293/430] usb: renesas_usbhs: Fix a resource leak in usbhs_pipe_malloc()
Date: Mon, 29 Dec 2025 17:11:35 +0100
Message-ID: <20251229160735.123361400@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


