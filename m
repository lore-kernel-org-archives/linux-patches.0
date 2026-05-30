Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF5F41A8F;
	Sat, 30 May 2026 18:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165919; cv=none; b=OUFy8xYj2S92NGge0CnbVmi7gXIyRlR10rjtiHkTn1zHXNCXFS4mBpy1J8trmyS01EcSsJWumb+Mev5pUbQiQL1lNGaP37BN6/JnbGmQRERUgCPuQ7HnhGw/palksJ0qnJCrO0BHCnti5q19+i3u6Bhy1QnYM2pWclgB8alOj9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165919; c=relaxed/simple;
	bh=ErRuK2WXV2jS3RxyXY8tb3glI92VxJAcQNmW8HZLBeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sl5k6Z8FWTs7M+/6rvkSOQSm+XpoNr5LcYNdwQAheyZnkyw4PVM9+j02KWDBC5NFxa6QchrSNmTttyqy4TSXI5T029/WONTZmTYIM5CwIQIkgxWOnLzjV74ow6/UUpNU1OOP6O9OcDH8n3IHZF3lZNjiphfJoV5tNWrALqlS4LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBWYKW1J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBWYKW1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44501F00893;
	Sat, 30 May 2026 18:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165918;
	bh=fbY1vWvHP8LK5DLby55T+M7nKXveOV31R1pcTGif83w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dBWYKW1JicWH5xoJghkl+7fd86qnvNvJwlhmUNKU9OCwa9/0NGVtfgvyg32Fm6p4n
	 cfwUDXo0RucmwVhdM1LHWLWrN1XgeqgsdpknMz7XoRHAnK6XjMpewlxHy9cqrmhj9b
	 7nz7+53gWl/zqokl8NDTQe2zRPalIe7/DYbIbCcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pete Zaitcev <zaitcev@redhat.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 221/589] usb: usblp: fix uninitialized heap leak via LPGETSTATUS ioctl
Date: Sat, 30 May 2026 18:01:42 +0200
Message-ID: <20260530160230.790252469@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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


