Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAFA3C09E2;
	Tue, 12 May 2026 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608443; cv=none; b=Hzg/JdhN2n/G2d+CSBaCzihseMCZtPcuwsIY2WQ4UkZ9n401lxo9TbqhNxVzvzjDD6q9TyBjXvXwVXcyDA7McXcHJWZAWRi3VfVIuvnHYLTaWbHs6A93wbGJaynHuBEo4kyu9CvSIJ7j+j5v4q27nIy4VK7kU99t/JQZ4GRDU+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608443; c=relaxed/simple;
	bh=Xpy99jG2uQaWWI3bLkjLaUdIs5oSJPhzj/BS1Y3fzSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNmtkqgwtS6qNAd6/dyJk0Ze2pdJsGPYAJ6DN/w/cj3xKVa/Go89A4SfQhTCjevpMj/NBfTLnQftqpDSrnYTNOEYkSUp+07JshWHtkS2o1MTtk6qrBgqoSUjyhWiAO8BlgS5SzfO8IrjIBhq2Jpa/tYNMzF6QpIR4JuwKviNiac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWjf6lN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWjf6lN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C105AC2BCB0;
	Tue, 12 May 2026 17:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608443;
	bh=Xpy99jG2uQaWWI3bLkjLaUdIs5oSJPhzj/BS1Y3fzSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWjf6lN8RPobYAfcLM4S5TeIPwStx5bd57sqRAtkubU6anCHk5IJLfbZBONucdexo
	 QfQRENMNlsL+lYW/Gl3Xyw/j/6a28yb0YGkptv0y5GPb1LvGJ2QFotwmEeYgneLkiB
	 DIyvEENmKYsT+dK1c5+nko9jtL7q3HngLYr+FpN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pete Zaitcev <zaitcev@redhat.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 039/270] usb: usblp: fix uninitialized heap leak via LPGETSTATUS ioctl
Date: Tue, 12 May 2026 19:37:20 +0200
Message-ID: <20260512173939.278865578@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit b38e53cbfb9d84732e5984fbd73e128d592415c5 upstream.

Just like in a previous problem in this driver, usblp_ctrl_msg() will
collapse the usb_control_msg() return value to 0/-errno, discarding the
actual number of bytes transferred.

Ideally that short command should be detected and error out, but many
printers are known to send "incorrect" responses back so we can't just
do that.

statusbuf is kmalloc(8) at probe time and never filled before the first
LPGETSTATUS ioctl.

usblp_read_status() requests 1 byte. If a malicious printer responds
with zero bytes, *statusbuf is one byte of stale kmalloc heap,
sign-extended into the local int status, which the LPGETSTATUS path then
copy_to_user()s directly to the ioctl caller.

Fix this all by just zapping out the memory buffer when allocated at
probe time.  If a later call does a short read, the data will be
identical to what the device sent it the last time, so there is no
"leak" of information happening.

Cc: Pete Zaitcev <zaitcev@redhat.com>
Assisted-by: gkh_clanker_t1000
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/2026042011-shredder-savage-48c6@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usblp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -1178,7 +1178,7 @@ static int usblp_probe(struct usb_interf
 	}
 
 	/* Allocate buffer for printer status */
-	usblp->statusbuf = kmalloc(STATUS_BUF_SIZE, GFP_KERNEL);
+	usblp->statusbuf = kzalloc(STATUS_BUF_SIZE, GFP_KERNEL);
 	if (!usblp->statusbuf) {
 		retval = -ENOMEM;
 		goto abort;


