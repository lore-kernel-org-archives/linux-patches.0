Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AB33D7D74;
	Wed,  8 Apr 2026 19:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674843; cv=none; b=NmvZXZjAoKKWcbcPRI3gvxzoVruXHOX02alrRvN9DsD55vBoEr73IDvbiw6/xAwBx8gyOJ0k2PM2tcGbqOl28duaShnmRc8pEsOekg65U2zh1sTCICDmdOzNN5rUqettx97GeWe6Cb4RwIxz0YPQrxnfvY2xo8T1CKlQkvK/FWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674843; c=relaxed/simple;
	bh=0uXiRpuynzZcH3M17CTK3Ps9wGQK8fMlMocVeODOZZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSliOOVy28BieaxuElmOGi12PfJhY8wuL5jH4qaNj+KeKFfQnZQYXQ/fv9wy2Kqa4vCT6N4uEcnPzXT+yT+I1O0IGIv/Xo5e/U1RnxETmfbBJaJHCqRj9dnHFti0HzGyshCUsj8VnvrK9Gdd9ld7S2xEoMl7M5VGRsll8e8Seqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUTh8VRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUTh8VRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC9CC19421;
	Wed,  8 Apr 2026 19:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674843;
	bh=0uXiRpuynzZcH3M17CTK3Ps9wGQK8fMlMocVeODOZZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUTh8VRJ+F40ICZuHgvaeFrF1dfIZ4aObUgRjUdqaNQ2q6eQJ+SCHmQoHyIGwMzvK
	 42aMSFLdV1H6Vq76QpIMAzO7pPEHBsb99kTKQsi3Q5vzrLLqNhgdq81/Rw3UIhLJa6
	 iH49fupmVUBFOZaj2V4mxAIcgWd7wS1LtlIzmI5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc9f7f4a7df09f53c4a4@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.19 255/311] comedi: Reinit dev->spinlock between attachments to low-level drivers
Date: Wed,  8 Apr 2026 20:04:15 +0200
Message-ID: <20260408175948.910544192@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1063,6 +1063,14 @@ int comedi_device_attach(struct comedi_d
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


