Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE3531F9BC;
	Mon, 13 Apr 2026 16:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099586; cv=none; b=MDVkXTHObaVJnO0JEvNwWbo6IVTgyMd4N8mcK+rHGiVadOCKEhbDaoX7qyWKx5bBomPXeAFibZiDU22ekNZlj0TP33kSeyeeRJu0cCfud7sKpuqMqKAnqg+hE4sb0tJERtF1Rs0mINlL6JqxCE8rjHcpE7NbvYG4Sbw+ZwNTxKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099586; c=relaxed/simple;
	bh=bNfAoYWBpgnbZVhlMi/rNaMde0cDun92lmDxMAuq/oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7OIswvc658S8Qe/5dj9FuCcXjzCWURdp+D2qlR6cJCmtEY+f0BaRWtLq86T/jjOmAQcV7YM5mPAZVDjYq7yS33EpSHrdsruseHpAqEHhiVE7UXEaB+T2DrstErGq4yQjSJBmrKgNSY0LKXa08vwKhwcTN6eSAImlrB3vz/6jjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQ08KunM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQ08KunM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338AAC2BCAF;
	Mon, 13 Apr 2026 16:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099586;
	bh=bNfAoYWBpgnbZVhlMi/rNaMde0cDun92lmDxMAuq/oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQ08KunMj27/BG9eEW04E8N6IJ/kgpkYDlDCoSfumYZDvjDlj2heINZKbNEsh0CZu
	 adO/5ozNnOgTnR008sL/m4a6CKFJ2zhrec9RzHfKQK37ZTA3uB6Pz1Ss8rgh3MdtPa
	 RTQgsK6UReudVo/CaXfeiDLeRtZT6ynrcltAHCxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc9f7f4a7df09f53c4a4@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.10 398/491] comedi: Reinit dev->spinlock between attachments to low-level drivers
Date: Mon, 13 Apr 2026 18:00:43 +0200
Message-ID: <20260413155833.933440741@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

commit 4b9a9a6d71e3e252032f959fb3895a33acb5865c upstream.

`struct comedi_device` is the main controlling structure for a COMEDI
device created by the COMEDI subsystem.  It contains a member `spinlock`
containing a spin-lock that is initialized by the COMEDI subsystem, but
is reserved for use by a low-level driver attached to the COMEDI device
(at least since commit 25436dc9d84f ("Staging: comedi: remove RT
code")).

Some COMEDI devices (those created on initialization of the COMEDI
subsystem when the "comedi.comedi_num_legacy_minors" parameter is
non-zero) can be attached to different low-level drivers over their
lifetime using the `COMEDI_DEVCONFIG` ioctl command.  This can result in
inconsistent lock states being reported when there is a mismatch in the
spin-lock locking levels used by each low-level driver to which the
COMEDI device has been attached.  Fix it by reinitializing
`dev->spinlock` before calling the low-level driver's `attach` function
pointer if `CONFIG_LOCKDEP` is enabled.

Reported-by: syzbot+cc9f7f4a7df09f53c4a4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cc9f7f4a7df09f53c4a4
Fixes: ed9eccbe8970 ("Staging: add comedi core")
Cc: stable <stable@kernel.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260225132427.86578-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -1000,6 +1000,14 @@ int comedi_device_attach(struct comedi_d
 		ret = -EIO;
 		goto out;
 	}
+	if (IS_ENABLED(CONFIG_LOCKDEP)) {
+		/*
+		 * dev->spinlock is for private use by the attached low-level
+		 * driver.  Reinitialize it to stop lock-dependency tracking
+		 * between attachments to different low-level drivers.
+		 */
+		spin_lock_init(&dev->spinlock);
+	}
 	dev->driver = driv;
 	dev->board_name = dev->board_ptr ? *(const char **)dev->board_ptr
 					 : dev->driver->driver_name;


