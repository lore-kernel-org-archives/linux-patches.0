Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5E5423A85;
	Wed,  9 Sep 2026 13:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962014; cv=none; b=Qd1MjKjuvl/meNQiHhLcpuMvlnH0hyN4ZDZxU3F5s+eUmY66VABKzYsfCdgFHdhWdjz6bFBq5dZrSyldTli8F/sUCEXw9PuMj1VhEsXFcGQAjNJ+ghwNaaZ7aNJOZTNkBrwwOBvc37bqQZAXpyt0f+feiQCGbAjIR0ET6Zd+Yno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962014; c=relaxed/simple;
	bh=yOHzlRFd7S5mPSfl5ONoh7Ht3oLfKmIfCU1/HTD2OOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdD05ijAHbNc46CLlMOA7aT7P7naxSrCr5NxWhdf4P6DYoqLjGmj8LAfDzmJXaRmXBwhRAujonRDlg/p2GSIYEaaSIqF2UCzNkvcnmnglLu2q5pRyMJFofoqxPM8MVn9BaMFr8I84bNI1u4e5yb/iGI8wz0HjurQk/bRfTiMszA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4Ug6GaW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4Ug6GaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F4A1F00A3A;
	Wed,  9 Sep 2026 13:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962012;
	bh=70YgeeiiJvdfmEFTgLyGRlBX33PJau+Rq7LE4EaKUl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4Ug6GaWziL+XH1viTgH5HyUISYc1VbYDBLD7sIFhXS0Xg6JgXRGeTDi3hHOGu7Zb
	 zd7lhFOZgUN+nS7x+Np5/Q9+NHV5n3sWHLa/3bzu0CwZ8KjETzr9faqlzGrMaVMGfW
	 DilVAdxDxm/ZCVBWNHEBf+gwtr31N9Lb9Ckco9rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+23ad911c819b923238b7@syzkaller.appspotmail.com,
	Vasileios Almpanis <vasilisalmpanis@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.2 143/556] i2c: core: fix debugfs UAF on adapter removal
Date: Wed,  9 Sep 2026 15:37:03 +0200
Message-ID: <20260909134235.478130656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasileios Almpanis <vasilisalmpanis@gmail.com>

commit b15b548d52b43ba8ac4652bc2c7244a8dd1e9622 upstream.

i2c_del_adapter() frees the adapter's debugfs directory before it
unregisters the adapter device, but the new_device sysfs attribute
stays writable until device_del(). A write racing with removal still
reaches i2c_device_probe(), which passes the freed adap->debugfs to
debugfs_create_dir() as the new client's parent:

  BUG: KASAN: slab-use-after-free in lookup_noperm_common+0x407/0x430
  Read of size 4 at addr ffff88803ef87810 by task syz.0.61/6090
   lookup_noperm_common+0x407/0x430
   simple_start_creating+0x9c/0x110
   debugfs_start_creating+0xdb/0x1a0
   debugfs_create_dir+0x24/0x350
   i2c_device_probe+0x814/0xbf0

It's technically possible to create a client after i2c_deregister_clients
has run. That client will never be unregistered and make
wait_for_completion hang.

Close the window by removing the new_device attribute at the start of
i2c_del_adapter(). device_remove_file() will drain any clients left.

Fixes: 73febd775bdb ("i2c: create debugfs entry per adapter")
Reported-by: syzbot+23ad911c819b923238b7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=23ad911c819b923238b7
Signed-off-by: Vasileios Almpanis <vasilisalmpanis@gmail.com>
Cc: <stable@vger.kernel.org> # v6.8+
Tested-by: syzbot+23ad911c819b923238b7@syzkaller.appspotmail.com
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260812-i2c-v2-1-5efaab4c3334@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-base.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1815,6 +1815,12 @@ void i2c_del_adapter(struct i2c_adapter
 		return;
 	}
 
+	/*
+	 * This drains any in-flight writers, so all
+	 * clients will be caught by i2c_deregister_clients().
+	 */
+	device_remove_file(&adap->dev, &dev_attr_new_device);
+
 	i2c_acpi_remove_space_handler(adap);
 
 	i2c_deregister_clients(adap);


