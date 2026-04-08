Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2DBB67E;
	Wed,  8 Apr 2026 18:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673501; cv=none; b=Ql4NA4ePG41iw+tQBb1po5vfPfbP5qrNd+35ivuJcjbVxBxpJAZacYLoVYXPYWrl4BRwHD1ziMEUlvSp8VNpWN7wqWoEDEhT/110h2BN7hYoofxANmReeQZ1pliEkJThfyyDD9TAnHhqTwmlkqfIiBAxY4e6w86DU1UAQqWczFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673501; c=relaxed/simple;
	bh=DKqiNRwFZA9QKxJDpe9m/UqPhAT3f82JZvsZCpPIZz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7GwOYl9Wl9zVdYmEy9OlEL+vlnsGmROXi95/FsEB9kXIhzg3IiQlYds+pT8tHKgtKrOFU+tZfJcfb3ijGtejqMWmzCU9QfCZm3KqQm78Tivmh0Ssbf4WmomD0oQ1YJLLmzifX3Vo18eGWws/E+uQYuXmSdSK1xCt8qJzLkmSsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D27+tVTJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D27+tVTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816A7C19421;
	Wed,  8 Apr 2026 18:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673500;
	bh=DKqiNRwFZA9QKxJDpe9m/UqPhAT3f82JZvsZCpPIZz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D27+tVTJ5h/pVuM54/qBWvMFY0FC/IFSdBWL+Lfj/+8sfVG3fGHCfxwbtMxO1x0u2
	 5TuYY+KAIBrbS6Xm7/Y2pYeAwr8VFsOg7x2pPX34dNvCJb7W3V0Y4lxCB9ILYQ+tO2
	 bI0aEEnYRA6a7zSHDpyObmifqUXA+rF36yM6ba1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc9f7f4a7df09f53c4a4@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.18 214/277] comedi: Reinit dev->spinlock between attachments to low-level drivers
Date: Wed,  8 Apr 2026 20:03:19 +0200
Message-ID: <20260408175941.852374818@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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
 drivers/comedi/drivers.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/comedi/drivers.c
+++ b/drivers/comedi/drivers.c
@@ -1001,6 +1001,14 @@ int comedi_device_attach(struct comedi_d
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


