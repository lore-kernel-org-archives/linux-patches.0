Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4E22F619D;
	Thu, 15 Jan 2026 17:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498864; cv=none; b=TGSAO44Uw2sOhbP/LepWbsWqzs1GY08HbqkKMTCc4TFjlFYGrrxLEvgenTLMnwF4gLrwm7xUEfeaoyEg+4uFtq0R5fvGSdxGaOKbNfdzMuMbKEN1oy35+kR8i54jUJGPOUOFn0+bITkakADuZZq4drSLcEWagGLqajViWo55B8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498864; c=relaxed/simple;
	bh=PL89LOgjOLtBsHxCLVKbP/qs3lTkmKoee8tXdLcrrUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rt1pD2UiNTFr9ewroCXMExv48q/W3eJ0ilqPZ8rlDwaSEVQIqDI+He2Byo5VAczFBV0GemIPgWreWqnx84wW8CpIT8iPeFOCvn1m0i1OGCZrEuqHVNmo7sP7S4AOD1OqU+tSU0P2KEw9Tv3voFgkQALMShscs32FI3NykToApZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2vOTYtK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2vOTYtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A96C116D0;
	Thu, 15 Jan 2026 17:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498864;
	bh=PL89LOgjOLtBsHxCLVKbP/qs3lTkmKoee8tXdLcrrUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2vOTYtKLgA0u7nfhR7DZr2fLznBvZ/XLmdUyNQYGkLK/WhTYwu+Zt6a3PHNsoQCc
	 oIDqEsmaGKzFD3oIX89c3MOgzBfi7qsYvQKF9IiEkXU2FoB8kGRtjRiSiN1U/50Skc
	 Sll7Fon6unEn4bPAY9i9pnpurz4Cngjnsr38mUk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ab8008c24e84adee93ff@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Subject: [PATCH 5.10 026/451] comedi: check devices attached status in compat ioctls
Date: Thu, 15 Jan 2026 17:43:47 +0100
Message-ID: <20260115164231.838628313@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 0de7d9cd07a2671fa6089173bccc0b2afe6b93ee upstream.

Syzbot identified an issue [1] that crashes kernel, seemingly due to
unexistent callback dev->get_valid_routes(). By all means, this should
not occur as said callback must always be set to
get_zero_valid_routes() in __comedi_device_postconfig().

As the crash seems to appear exclusively in i386 kernels, at least,
judging from [1] reports, the blame lies with compat versions
of standard IOCTL handlers. Several of them are modified and
do not use comedi_unlocked_ioctl(). While functionality of these
ioctls essentially copy their original versions, they do not
have required sanity check for device's attached status. This,
in turn, leads to a possibility of calling select IOCTLs on a
device that has not been properly setup, even via COMEDI_DEVCONFIG.

Doing so on unconfigured devices means that several crucial steps
are missed, for instance, specifying dev->get_valid_routes()
callback.

Fix this somewhat crudely by ensuring device's attached status before
performing any ioctls, improving logic consistency between modern
and compat functions.

[1] Syzbot report:
BUG: kernel NULL pointer dereference, address: 0000000000000000
...
CR2: ffffffffffffffd6 CR3: 000000006c717000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 get_valid_routes drivers/comedi/comedi_fops.c:1322 [inline]
 parse_insn+0x78c/0x1970 drivers/comedi/comedi_fops.c:1401
 do_insnlist_ioctl+0x272/0x700 drivers/comedi/comedi_fops.c:1594
 compat_insnlist drivers/comedi/comedi_fops.c:3208 [inline]
 comedi_compat_ioctl+0x810/0x990 drivers/comedi/comedi_fops.c:3273
 __do_compat_sys_ioctl fs/ioctl.c:695 [inline]
 __se_compat_sys_ioctl fs/ioctl.c:638 [inline]
 __ia32_compat_sys_ioctl+0x242/0x370 fs/ioctl.c:638
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
...

Reported-by: syzbot+ab8008c24e84adee93ff@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ab8008c24e84adee93ff
Fixes: 3fbfd2223a27 ("comedi: get rid of compat_alloc_user_space() mess in COMEDI_CHANINFO compat")
Cc: stable <stable@kernel.org>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://patch.msgid.link/20251023132234.395794-1-n.zhandarovich@fintech.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedi_fops.c |   42 ++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 6 deletions(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2961,7 +2961,12 @@ static int compat_chaninfo(struct file *
 	chaninfo.rangelist = compat_ptr(chaninfo32.rangelist);
 
 	mutex_lock(&dev->mutex);
-	err = do_chaninfo_ioctl(dev, &chaninfo);
+	if (!dev->attached) {
+		dev_dbg(dev->class_dev, "no driver attached\n");
+		err = -ENODEV;
+	} else {
+		err = do_chaninfo_ioctl(dev, &chaninfo);
+	}
 	mutex_unlock(&dev->mutex);
 	return err;
 }
@@ -2982,7 +2987,12 @@ static int compat_rangeinfo(struct file
 	rangeinfo.range_ptr = compat_ptr(rangeinfo32.range_ptr);
 
 	mutex_lock(&dev->mutex);
-	err = do_rangeinfo_ioctl(dev, &rangeinfo);
+	if (!dev->attached) {
+		dev_dbg(dev->class_dev, "no driver attached\n");
+		err = -ENODEV;
+	} else {
+		err = do_rangeinfo_ioctl(dev, &rangeinfo);
+	}
 	mutex_unlock(&dev->mutex);
 	return err;
 }
@@ -3058,7 +3068,12 @@ static int compat_cmd(struct file *file,
 		return rc;
 
 	mutex_lock(&dev->mutex);
-	rc = do_cmd_ioctl(dev, &cmd, &copy, file);
+	if (!dev->attached) {
+		dev_dbg(dev->class_dev, "no driver attached\n");
+		rc = -ENODEV;
+	} else {
+		rc = do_cmd_ioctl(dev, &cmd, &copy, file);
+	}
 	mutex_unlock(&dev->mutex);
 	if (copy) {
 		/* Special case: copy cmd back to user. */
@@ -3083,7 +3098,12 @@ static int compat_cmdtest(struct file *f
 		return rc;
 
 	mutex_lock(&dev->mutex);
-	rc = do_cmdtest_ioctl(dev, &cmd, &copy, file);
+	if (!dev->attached) {
+		dev_dbg(dev->class_dev, "no driver attached\n");
+		rc = -ENODEV;
+	} else {
+		rc = do_cmdtest_ioctl(dev, &cmd, &copy, file);
+	}
 	mutex_unlock(&dev->mutex);
 	if (copy) {
 		err = put_compat_cmd(compat_ptr(arg), &cmd);
@@ -3143,7 +3163,12 @@ static int compat_insnlist(struct file *
 	}
 
 	mutex_lock(&dev->mutex);
-	rc = do_insnlist_ioctl(dev, insns, insnlist32.n_insns, file);
+	if (!dev->attached) {
+		dev_dbg(dev->class_dev, "no driver attached\n");
+		rc = -ENODEV;
+	} else {
+		rc = do_insnlist_ioctl(dev, insns, insnlist32.n_insns, file);
+	}
 	mutex_unlock(&dev->mutex);
 	kfree(insns);
 	return rc;
@@ -3162,7 +3187,12 @@ static int compat_insn(struct file *file
 		return rc;
 
 	mutex_lock(&dev->mutex);
-	rc = do_insn_ioctl(dev, &insn, file);
+	if (!dev->attached) {
+		dev_dbg(dev->class_dev, "no driver attached\n");
+		rc = -ENODEV;
+	} else {
+		rc = do_insn_ioctl(dev, &insn, file);
+	}
 	mutex_unlock(&dev->mutex);
 	return rc;
 }


