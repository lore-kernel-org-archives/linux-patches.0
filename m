Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FE3171E70;
	Wed,  3 Jul 2024 10:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003923; cv=none; b=b4bZllVtiCLO0NAAnLOVGn3nGYr+FkF/FSfAdrzMATYPxngRi/6IrWapv1i6xUy1Dm0kjOnhiW6dBcAaJ3kXxJUE6hhq1rzvRNNxsIN2gFBDZtAYnIMDiKRyHUaJdZ72JZlDPGd81tNQhqrYCMGBT06vKQZnGZs+ICI8lRh6Cjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003923; c=relaxed/simple;
	bh=YPbNl8aLL4TFmBZ/CdfneTja+cKoTSHE5MfU0vmeRiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUz2M3Ch+9GVzBjpqOTp8UDxuFTwwtDmNNZMcptKZZp5lyjPVgcuUtXNjX6oG09hrMG1Dc3k4/axBM1vARjSa05lspL8Nu/xoxyD8vK96AlwxIGBkNKsyPEWBRbO8HdGN3dxET7Gce01y0vtQWcNfXdcwcOim5uw3KAceHMgFMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqNJsxwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqNJsxwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E9EC2BD10;
	Wed,  3 Jul 2024 10:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003923;
	bh=YPbNl8aLL4TFmBZ/CdfneTja+cKoTSHE5MfU0vmeRiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqNJsxwRLUQVn+396x2KAkwrftmIUfzVsnrpr5xIVeM1VT8IucOHeJfCDhtLDfIaY
	 W/KxDzQMr4dhweS4LhOTJyHA+GHJylTeJLiElV3lCFSfO97BSCDNuQuwqKQi4KJsUx
	 1OPvkkjHxyvXIAViFmlumhCxdDpRaImsJ14vtoS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	syzbot+ffa8143439596313a85a@syzkaller.appspotmail.com,
	Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Dirk Behme <dirk.behme@de.bosch.com>
Subject: [PATCH 5.4 066/189] drivers: core: synchronize really_probe() and dev_uevent()
Date: Wed,  3 Jul 2024 12:38:47 +0200
Message-ID: <20240703102843.999416951@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Behme <dirk.behme@de.bosch.com>

commit c0a40097f0bc81deafc15f9195d1fb54595cd6d0 upstream.

Synchronize the dev->driver usage in really_probe() and dev_uevent().
These can run in different threads, what can result in the following
race condition for dev->driver uninitialization:

Thread #1:
==========

really_probe() {
...
probe_failed:
...
device_unbind_cleanup(dev) {
    ...
    dev->driver = NULL;   // <= Failed probe sets dev->driver to NULL
    ...
    }
...
}

Thread #2:
==========

dev_uevent() {
...
if (dev->driver)
      // If dev->driver is NULLed from really_probe() from here on,
      // after above check, the system crashes
      add_uevent_var(env, "DRIVER=%s", dev->driver->name);
...
}

really_probe() holds the lock, already. So nothing needs to be done
there. dev_uevent() is called with lock held, often, too. But not
always. What implies that we can't add any locking in dev_uevent()
itself. So fix this race by adding the lock to the non-protected
path. This is the path where above race is observed:

 dev_uevent+0x235/0x380
 uevent_show+0x10c/0x1f0  <= Add lock here
 dev_attr_show+0x3a/0xa0
 sysfs_kf_seq_show+0x17c/0x250
 kernfs_seq_show+0x7c/0x90
 seq_read_iter+0x2d7/0x940
 kernfs_fop_read_iter+0xc6/0x310
 vfs_read+0x5bc/0x6b0
 ksys_read+0xeb/0x1b0
 __x64_sys_read+0x42/0x50
 x64_sys_call+0x27ad/0x2d30
 do_syscall_64+0xcd/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Similar cases are reported by syzkaller in

https://syzkaller.appspot.com/bug?extid=ffa8143439596313a85a

But these are regarding the *initialization* of dev->driver

dev->driver = drv;

As this switches dev->driver to non-NULL these reports can be considered
to be false-positives (which should be "fixed" by this commit, as well,
though).

The same issue was reported and tried to be fixed back in 2015 in

https://lore.kernel.org/lkml/1421259054-2574-1-git-send-email-a.sangwan@samsung.com/

already.

Fixes: 239378f16aa1 ("Driver core: add uevent vars for devices of a class")
Cc: stable <stable@kernel.org>
Cc: syzbot+ffa8143439596313a85a@syzkaller.appspotmail.com
Cc: Ashish Sangwan <a.sangwan@samsung.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
Link: https://lore.kernel.org/r/20240513050634.3964461-1-dirk.behme@de.bosch.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1273,8 +1273,11 @@ static ssize_t uevent_show(struct device
 	if (!env)
 		return -ENOMEM;
 
+	/* Synchronize with really_probe() */
+	device_lock(dev);
 	/* let the kset specific function add its keys */
 	retval = kset->uevent_ops->uevent(kset, &dev->kobj, env);
+	device_unlock(dev);
 	if (retval)
 		goto out;
 


