Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02BA35505D;
	Tue,  6 Jan 2026 17:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720282; cv=none; b=BME6UIyvi88WjhrRNPKRlJ7wwsKF7mw87Z+nWwbb6B547h0QQHsBSPZRnNPzSoPW7zwcuTtW8FpG07uHd7HXjpGh/PRHj2BEhmKJHr6d+KR04vTj/edXQDHtojsT2s1k4hBqsMUFvSynRIRr5rd6/l02VTnH9X/ESRg6dNmsTu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720282; c=relaxed/simple;
	bh=CotsII0B3htusyeRr7G8ziTKBO4HHU7ngY0U+k5v5Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYZjiDj7w22LYZx/a8F2Wd00Ev4l0qrLq7Obl2kLMyqIBOsrBk6l5Oin3QDVnvU6VPC0mctC6SCbAjwEzP4FOnCqTYrYIQ/PojpJUxQxboRqvVwjrIWarKvHUeAoKttz2TK15+l8Axlrym14BDBdoVUW9HIsApVdt6fTeFVpTew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMiuBJAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMiuBJAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133FAC116C6;
	Tue,  6 Jan 2026 17:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720282;
	bh=CotsII0B3htusyeRr7G8ziTKBO4HHU7ngY0U+k5v5Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMiuBJAipnwZLWXvE5BhItHrICTI46T8Rhqvl57Xy3F/btpbUn/QasVTsiiOf9HRK
	 uT6ZHk7yQCG+HVohQxGlDECHcZJAF9sCYZ7iafKTJPRhlflmJJ6l/QlFjb912p5hcJ
	 o6tvsmAOK6J//lN50pkZ6XlZsbHtS9aI8LcD1gHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH 6.12 190/567] usb: renesas_usbhs: Fix a resource leak in usbhs_pipe_malloc()
Date: Tue,  6 Jan 2026 17:59:32 +0100
Message-ID: <20260106170458.356266106@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


