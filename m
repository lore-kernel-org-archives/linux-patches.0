Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6153F929E;
	Fri, 15 May 2026 16:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861091; cv=none; b=nFNpCPgR06FlwI34JUF2edn2gBNlIrgMcTIuBK3e3GR2DQDqBylP+kvERaBlArRh2JbLPuBe3T6wt26eT8kjB3dRLor2LFEr40dFRe6hOolsqbZ6e/TtZppwlt6B/iRnADYH3lEogcRYf1L6mIoyK1tCXEGapdrGj9RSz6miUFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861091; c=relaxed/simple;
	bh=36H9DMg5PVdoW83Pqnhs/U+Ik9PGIT6qkAwVurxn2MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mz4/2BVahFok8mdO3rluxkPM4GBX341ekY7zQPG/farHMYThOtaPTN5YO5cAjm8IHJLOXqYxrOdqVJs2kR3Rk1eH9fdTIazoSXu56tEwso+xI3PiwxJmARTImL8AjALHCv57tVEIgeER2+uZLJU09a+RsKbUmMP7mci6kKniSDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnRooUd0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnRooUd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D62C2BCB3;
	Fri, 15 May 2026 16:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861091;
	bh=36H9DMg5PVdoW83Pqnhs/U+Ik9PGIT6qkAwVurxn2MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnRooUd02+3gJ/ljyfjKXenBDAY7yuEC0g3vG854TcrbftTwiYxTL76iK3CFw7P93
	 L84MpydA2Xz9PrIQt1q8eb2f/AyHhRlfx7wO4PSYF31xFiR7+FSoWWXG+551awQMl8
	 VcI9dWPc4/yXsMVsnaJSjv9/eC5i7YRxwBKNKwjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pete Zaitcev <zaitcev@redhat.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 194/474] usb: usblp: fix uninitialized heap leak via LPGETSTATUS ioctl
Date: Fri, 15 May 2026 17:45:03 +0200
Message-ID: <20260515154719.218156941@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -1166,7 +1166,7 @@ static int usblp_probe(struct usb_interf
 	}
 
 	/* Allocate buffer for printer status */
-	usblp->statusbuf = kmalloc(STATUS_BUF_SIZE, GFP_KERNEL);
+	usblp->statusbuf = kzalloc(STATUS_BUF_SIZE, GFP_KERNEL);
 	if (!usblp->statusbuf) {
 		retval = -ENOMEM;
 		goto abort;


