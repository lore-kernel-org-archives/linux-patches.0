Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD2C143C6E;
	Wed,  3 Jul 2024 11:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005635; cv=none; b=LWHlzqcWvAfppfvW2XbOZ3cofr+Na4h296xVq7KfLJvH8Ilsivipszah5RoPukfTB9ZQSHnc518uW8GRo1GB0bk4eFg76smPV4LGLQNg6PCaSxUfiSonXxJhPAcvYd+WfT16mzIxL1CSQwg0U7v+ncfH0pDXJy1pQWo0KA1Kw+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005635; c=relaxed/simple;
	bh=wt1oeOBo7P3Xv8dhbBevBp49jj2BCzpPQLbz5J39VBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUcgjSTqgzHn50hzuT+xuz9k5UROB6pBf22OjsCRbirt1SNpdVCFP57OIOccGnLt0cDrhKSWzaP64vZjs2xDnt9DeRwfaGiKEIc0PW8fF0qKTzuMwC7te+Q+IrRVGuINdG72m+hfMBEDSGm8e6yYRzrIB1BARfdaZ1Edqenewow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnrXECEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnrXECEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC14C2BD10;
	Wed,  3 Jul 2024 11:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005635;
	bh=wt1oeOBo7P3Xv8dhbBevBp49jj2BCzpPQLbz5J39VBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnrXECEdBWWLkJJPV0hhjj0C4//huG/0surxDTgOG8+TIdWfgGLdVgB5B8jRmmZAO
	 OlcRC4sXG71gMpIv76399QH3H4nVkhryNB6u0DanuxcNLgOfbzq26ALTAnJlGJwM2p
	 fJLQ56Cr9mO4sfpx+5MqIrvKso3RcYTf3H/SghAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	syzbot+ffa8143439596313a85a@syzkaller.appspotmail.com,
	Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Dirk Behme <dirk.behme@de.bosch.com>
Subject: [PATCH 5.15 114/356] drivers: core: synchronize really_probe() and dev_uevent()
Date: Wed,  3 Jul 2024 12:37:30 +0200
Message-ID: <20240703102917.410963846@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2404,8 +2404,11 @@ static ssize_t uevent_show(struct device
 	if (!env)
 		return -ENOMEM;
 
+	/* Synchronize with really_probe() */
+	device_lock(dev);
 	/* let the kset specific function add its keys */
 	retval = kset->uevent_ops->uevent(kset, &dev->kobj, env);
+	device_unlock(dev);
 	if (retval)
 		goto out;
 


