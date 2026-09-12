Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DF93264D4;
	Sat, 12 Sep 2026 15:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228034; cv=none; b=mqBYRKhrZzVbJHAAu4b+GKAIwEX2YV9E+qGGe4kW/SSxgDb72m0gE/U0zfqx6XR//XMtq6meFuW7fljwR0O+zZRNLu5Tb0Zrepo/Cb/ItpAGl2GMu3K0d3Xn2MzpV+dErk6iGTZkev+UxqebnNJG2EdiqwfBjbtZFk19+WISzbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228034; c=relaxed/simple;
	bh=OtTdI8whj+iUBghp+lNpxmUCdsy2uJrnvI9B5xFZx0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRrc567UhLJpvk0PVAnej+drTWOuHY6MUVOjTJUyd78aGUE/XcKF/g5GGfFhv28JD64cyLu/MzGgC9nXhH0yogWdtNWDXGhiO/Dn3/vY0Y5Rn8XhYt8p24aH623T9fHsDTOhfn71bVKPx/VChqGZl1rr//aTHqx0RJpSeVCzi2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zI0x9at1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zI0x9at1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B4B1F000FF;
	Sat, 12 Sep 2026 15:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228032;
	bh=y7e1/TwZTYPy88hSQNUnoJFL5Ldl8k3b2+hIM6tqApY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zI0x9at17t/+aYeId68qsnJhsIFlQNReKvD9JkPj8wugE7/OA0Do2IF7rKSxKy3f+
	 j0uTNjz/6WlJR2HYgCjtRowKbwp4qS8XWdluhCNoffMWgSsOJf7EAiHJnLG/HXvFRi
	 92h4N2obacBIL7LwRGhRzPWspkRD4iBcxkNPme1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+23ad911c819b923238b7@syzkaller.appspotmail.com,
	Vasileios Almpanis <vasilisalmpanis@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 0303/1191] i2c: core: fix debugfs UAF on adapter removal
Date: Sat, 12 Sep 2026 08:50:31 +0200
Message-ID: <20260912065555.037928496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1813,6 +1813,12 @@ void i2c_del_adapter(struct i2c_adapter
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


