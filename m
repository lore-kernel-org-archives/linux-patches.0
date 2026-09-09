Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E389577E56;
	Wed,  9 Sep 2026 14:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963500; cv=none; b=jj0/SEF6dDgjXxrLnT9cuYzRNYfxYuHdVdys4EbrlTI7Y4wD3GDR6/5DoT8ge0LupMHl9J6jeHSa+2Ni+ZAxF4Ft0xABTTN0aIjhxTiK28ETEfSbZ8QzYKFKx9PoLVDUTvrt3dikj/Eg0yxWtq21whOUYMI7JTfYghJc22JyGt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963500; c=relaxed/simple;
	bh=BnkReKu4oaAAFjf2/TSEhz/bI4b78f7iUIPPQfm7clY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Px7E6/eP1sEXQlq+VADKbOoj71p18Pjl4u1TUyB/1JZAQf0cX3Bqr/+BnCDNv+CPA5T5vFcAk/a+wURhJaYq3PAN1IDxsVlnM4gD5YQRU/6ygiYBaa54N75+82igrseyFcNXnMgnvYoE/NIrfneoXLU0/LXfj3VPmQgO8ESxdug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPAAkf4k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPAAkf4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48471F00ADB;
	Wed,  9 Sep 2026 14:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963497;
	bh=6L+gukhqWjq1HWvQUoMi50FbRc10LFoc1LnEKhxlwZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MPAAkf4kEpGPBqHltLSn92mP6tL5aVr3twgp+u123r6RBPExE5hyvl4IcZQ9Wo2//
	 OqkxLEN1rzd3uMHXRSxy6AFqOQwQultHs7ZjAF3AxfNGATw8V0NzJP7L9uykGaZhjX
	 Hu3aZ4zarriGDmd2KuV3C23DlTWUryW0twpfQ2aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+23ad911c819b923238b7@syzkaller.appspotmail.com,
	Vasileios Almpanis <vasilisalmpanis@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 099/583] i2c: core: fix debugfs UAF on adapter removal
Date: Wed,  9 Sep 2026 15:36:24 +0200
Message-ID: <20260909134241.560209084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -1814,6 +1814,12 @@ void i2c_del_adapter(struct i2c_adapter
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


