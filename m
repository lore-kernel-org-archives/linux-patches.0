Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D73220696;
	Mon, 18 Aug 2025 13:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524569; cv=none; b=XhLq+whYSq80J3Rv8Agq+Vdythc23KGGqXkwQoBdwk5GRGc0UBEWlbz+NiiLvEqMdEYV4WOEvqSf6yTxRw6O8ajlHFlDN/Dds63o6XPWEV4ZQpQfX+D4QfLKISUS56/hApdA81YBis2e9Qx/jVx3WWUujjT3BCAjndXq1Xu0P8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524569; c=relaxed/simple;
	bh=FmtzCpnFLxXykBtoUpNiPdqqnYGUuJrRKSBHCXOJtww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4TvR8V7j3DbGAREvLiJ73OCr31OAlEMQDfI12sNm7ebNTMx1HR9UMcxCtc5vb61JaJWvDNQ1TxleIPa93R4MWmoF9uWGvP/P3gvmo3MKQoNiZOWzpbrbydW4v4i3O9CbYEhOIGpIDQgwJeSz/JZeSPPZYWxGWMKphTgwfAnwZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oBiNo8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oBiNo8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC0CC116B1;
	Mon, 18 Aug 2025 13:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524569;
	bh=FmtzCpnFLxXykBtoUpNiPdqqnYGUuJrRKSBHCXOJtww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1oBiNo8VSdM56AeJQ4y3CGU1sFELVnzJVlmf5PV7Q6XdnSYUi8gWnO1NkdDlC2AKl
	 D/AVA/jTpgjh5oKUPZn8xFeagMTRNIYTNUILAMvJNF3HgWZ32m9MORiWFddAGv+wEt
	 gfTOjU7jSydLn2abXIUAm47Q+OX0/paUPqQoT4gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9921e319bd6168140b40@syzkaller.appspotmail.com,
	syzbot+fa3a12519f0d3fd4ec16@syzkaller.appspotmail.com,
	Yu Kuai <yukuai3@huawei.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Xiao Ni <xni@redhat.com>
Subject: [PATCH 6.15 513/515] md: fix create on open mddev lifetime regression
Date: Mon, 18 Aug 2025 14:48:19 +0200
Message-ID: <20250818124518.185025341@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -614,6 +614,12 @@ static void __mddev_put(struct mddev *md
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


