Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3C835B15C;
	Fri,  9 Jan 2026 12:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960539; cv=none; b=pmUuBCx5O2MAx9AXnARz2Aw2LS1mQ16Yg8lJjUlBoVC4VGZVEnvJgIqESoPtDWWoDU/EyYiysjqr19BErNyZmRx4hdDH7t00kP1hva3jR5dfSZQt4BfWxiMvdh/o1yUe+eSiVoAkZBXJJ8JAOpewxfmfHaXymwO8MI9kJwn3JME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960539; c=relaxed/simple;
	bh=pmUf7gndajIyd6K5t+Hb9tR3UhMv0tP/kq60zl9Wmcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGQ/TymHNALMc1mlz67NfUC2BdmzElBB/1r9OkHbQZcbLQG8T9b29EIH1pApb8I3fWy4w8muRNknZ+/laQCrQNdTmc6GnCAxpAWtrxFcbCMHu1Xug7uPhTg3kR7rf/mhSr0tK9iy0VdyNZbdTk9zmiMAxfr4SsttLBeyNygmi1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZDeQPTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZDeQPTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C68C19422;
	Fri,  9 Jan 2026 12:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960539;
	bh=pmUf7gndajIyd6K5t+Hb9tR3UhMv0tP/kq60zl9Wmcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZDeQPTu7TgGstKr5/wWlPo3+3ceglK1Ul9CtEGnGHo/dwQB07jjM4HkdxcovaSoP
	 avjfEIldyTJ51AZqrwzOVxitA1Aw5Yyzwri16a27uVPbXMQjCscpehdOzGT+PqEywE
	 1LkW78lcfQ8MIloOyWlkkjDq8BP3wqePu3xi3p1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH 6.6 440/737] usb: renesas_usbhs: Fix a resource leak in usbhs_pipe_malloc()
Date: Fri,  9 Jan 2026 12:39:39 +0100
Message-ID: <20260109112150.542634543@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


