Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4147226ED5D;
	Sun,  7 Jun 2026 10:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828412; cv=none; b=L871zKA4XPgzxhCzzbT4mdaW0CwCInDzQsM9x50avjP8vQaHnKbhFFfkHanqxrenqUC4NJWTMNpvC/GxDPkXYsa3JvAuMJGrDUzrYTUokUq8BSqgeyRTtXCyn7yORg1EhZV6f25Rf3bTrWBMKLiCkxZ6Ql6Vhc7cvjx6I0QleZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828412; c=relaxed/simple;
	bh=NzEqh9DA52EbwUJGGO3fuNvHkd4BLp0b2sKrwdEQY0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEwfzRSBLvyjKTfmJiaB3s6dREQtxnGThuiQy9tZbNjLD+QTy9I/LuXUkHsmuSHjVFYgWuq2PKF9sHEisvI7q5iTq6SlnZX9yMJbks9HF08bUrApRQUALibym14kKVI/4exqKEvVixJv6Ws552/QCJNQ0kNg3QOh+hEKIc8Hi/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwbCMsBB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwbCMsBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6801F00893;
	Sun,  7 Jun 2026 10:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828411;
	bh=0++gafgT7KBfjNbnXhLZBqCqfCWGnoT/1uk8OQnyFzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qwbCMsBBZSUMT+PExs3sBxB09p0l1AIN6v2Cbi6QMUm6mc4ajLljxkD5o7+48Cpw9
	 fOHttdQzlVWUR6v+ERaUY3U01eEp45EAJ7fbzxhKx2XQ7HU1qhGTRRsywgv8Zud45/
	 ZoFncCG7MH/SP+lp5To/YyKovuOtkLBkwAJ1T7pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+11f0e4f957c7c3bf3d51@syzkaller.appspotmail.com,
	Henri A <contact@henrialfonso.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 136/307] media: rc: igorplugusb: fix control request setup packet
Date: Sun,  7 Jun 2026 11:58:53 +0200
Message-ID: <20260607095732.737881389@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Henri A <contact@henrialfonso.com>

commit 171022c7d594c133a45f92357a2a91475edabe20 upstream.

Commit eac69475b01f ("media: rc: igorplugusb: heed coherency
rules") changed the control request storage from an embedded struct to
an allocated pointer so it can obey DMA coherency rules.

However, the driver still passes &ir->request to usb_fill_control_urb().
That points the URB setup packet at the pointer field itself rather than
at the allocated struct usb_ctrlrequest.

USB core then interprets pointer bytes as the setup packet. This can
produce an invalid bRequestType and trigger the control direction warning
reported by syzbot:

  usb 2-1: BOGUS control dir, pipe 80003580 doesn't match bRequestType 0

Pass ir->request itself as the setup packet.

Fixes: eac69475b01f ("media: rc: igorplugusb: heed coherency rules")
Reported-by: syzbot+11f0e4f957c7c3bf3d51@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=11f0e4f957c7c3bf3d51
Tested-by: syzbot+11f0e4f957c7c3bf3d51@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5.5
Signed-off-by: Henri A <contact@henrialfonso.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/igorplugusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -184,7 +184,7 @@ static int igorplugusb_probe(struct usb_
 	if (!ir->buf_in)
 		goto fail;
 	usb_fill_control_urb(ir->urb, udev,
-		usb_rcvctrlpipe(udev, 0), (uint8_t *)&ir->request,
+		usb_rcvctrlpipe(udev, 0), (uint8_t *)ir->request,
 		ir->buf_in, MAX_PACKET, igorplugusb_callback, ir);
 
 	usb_make_path(udev, ir->phys, sizeof(ir->phys));


