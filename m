Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00E335A2A2;
	Mon, 18 Aug 2025 14:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526469; cv=none; b=E2RMZwyhIQ/kbGJRIJGuXq0JzGii96RP4Pv9YdAClkNAW51A2BwsxWzfyA2gwW+/ahcSdhiqsaZSFdXDsdlvFvj7kfYqUY7xEHITP4BMTiZiFDp4ZezY+Y6EkBWES8PRdCPQwJVLBrufJ4MeYeCTO3MJPAhZFWcen89AHSzR//U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526469; c=relaxed/simple;
	bh=HOzd3aQBTHIjpz0j4xQf8aaRR8F2Qk6qSxyVqri3qrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0R3Jrj6NhL+YgEWzFFfIj90sQ8nttVF8FBVWlyNFJKVFoREzLGrvBmrsPuJZbbRDScVpaRDMix/jfazoonFBk+pS7epREKTCyDKD7UI8dS/IEsPLDX04WVEzh/uF7lEvB9XXK2dhLcci5swyVkrxaJmdAtXpi6evGBQpjW+pJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBglJ2l4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBglJ2l4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58604C4CEEB;
	Mon, 18 Aug 2025 14:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526469;
	bh=HOzd3aQBTHIjpz0j4xQf8aaRR8F2Qk6qSxyVqri3qrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBglJ2l4efn6ckBWhFDnRlDi97d5rTUGPCrQg6APp7A3s29zRUrKN+/Xa/HxpvNtq
	 ii+68knTqnkWylgPpyVhcB6DdKqn22QLaL2TEGYtUYKgVJN6t3ithh6bM5z1gbfX23
	 BRJlBCBpyxxzHYLn2Bg7UE7m+MBv1uhXiAGfPxqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9921e319bd6168140b40@syzkaller.appspotmail.com,
	syzbot+fa3a12519f0d3fd4ec16@syzkaller.appspotmail.com,
	Yu Kuai <yukuai3@huawei.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Xiao Ni <xni@redhat.com>
Subject: [PATCH 6.16 565/570] md: fix create on open mddev lifetime regression
Date: Mon, 18 Aug 2025 14:49:12 +0200
Message-ID: <20250818124527.642533149@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 1df1fc845d221eb646539836dbf509eb96b41afd upstream.

Commit 9e59d609763f ("md: call del_gendisk in control path") moves
setting MD_DELETED from __mddev_put() to do_md_stop(), however, for the
case create on open, mddev can be freed without do_md_stop():

1) open

md_probe
 md_alloc_and_put
  md_alloc
   mddev_alloc
   atomic_set(&mddev->active, 1);
   mddev->hold_active = UNTIL_IOCTL
  mddev_put
   atomic_dec_and_test(&mddev->active)
    if (mddev->hold_active)
    -> active is 0, hold_active is set
md_open
 mddev_get
  atomic_inc(&mddev->active);

2) ioctl that is not STOP_ARRAY, for example, GET_ARRAY_INFO:

md_ioctl
 mddev->hold_active = 0

3) close

md_release
 mddev_put(mddev);
  atomic_dec_and_lock(&mddev->active, &all_mddevs_lock)
  __mddev_put
  -> hold_active is cleared, mddev will be freed
  queue_work(md_misc_wq, &mddev->del_work)

Now that MD_DELETED is not set, before mddev is freed by
mddev_delayed_delete(), md_open can still succeed and break mddev
lifetime, causing mddev->kobj refcount underflow or mddev uaf
problem.

Fix this problem by setting MD_DELETED before queuing del_work.

Reported-by: syzbot+9921e319bd6168140b40@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68894408.a00a0220.26d0e1.0012.GAE@google.com/
Reported-by: syzbot+fa3a12519f0d3fd4ec16@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68894408.a00a0220.26d0e1.0013.GAE@google.com/
Fixes: 9e59d609763f ("md: call del_gendisk in control path")
Link: https://lore.kernel.org/linux-raid/20250730073321.2583158-1-yukuai1@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -637,6 +637,12 @@ static void __mddev_put(struct mddev *md
 		return;
 
 	/*
+	 * If array is freed by stopping array, MD_DELETED is set by
+	 * do_md_stop(), MD_DELETED is still set here in case mddev is freed
+	 * directly by closing a mddev that is created by create_on_open.
+	 */
+	set_bit(MD_DELETED, &mddev->flags);
+	/*
 	 * Call queue_work inside the spinlock so that flush_workqueue() after
 	 * mddev_find will succeed in waiting for the work to be done.
 	 */


