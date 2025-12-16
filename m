Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6B536BCC2;
	Tue, 16 Dec 2025 12:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887436; cv=none; b=bLmG38N5LBARVBKYpqBgioageYAcM1IbrllXEFan1yEDOhuACgSsPS9LcoTtXatNbfFHYYFjOeW5jhS9UGUG05YDk74PNSXOMCy5dpMozEaEynXuTnOQ8/WXUg/dSjT88PXGOGNa8RbX2QM33jG1Hgp7pjaT6LuXcfVxFfogVRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887436; c=relaxed/simple;
	bh=RpEUZDxLecVWnETGseQyOBofRMasPyina5v+TvnEqhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQL719jgoHDlh9hg9HXxdoKyU440LoYqJAGZrHRXf7oFYSpjNnnBmj10UJ0VGqrE//uIznkKOs3SBJ8Q9hKXKFLQeCqVOn48ncC0poUN2VK0sBmY1BakOOd2SKugzkTILtvFLrSRWVSppxeMLIc1e/T55JuZTDvC2DYTMUXWBa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OytGG40l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OytGG40l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AB4C4CEF5;
	Tue, 16 Dec 2025 12:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887435;
	bh=RpEUZDxLecVWnETGseQyOBofRMasPyina5v+TvnEqhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OytGG40lo+9INzSk+wjKGaxPv29QEwMcs0lCyfgT8V4jNbON0ftd6dswTN+yQbRnH
	 gAGKGrVLyu831rLS4cOHISqPxRmkrlSGN1Fxco/tuLr5K/hJ82CyNchO2S3aTLaR26
	 uR0fPzVEbKlp53S5gbW1Bmqvv54n+cOX58hGtYjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+56fbf4c7ddf65e95c7cc@syzkaller.appspotmail.com,
	Zheng Qixing <zhengqixing@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 229/614] nbd: defer config put in recv_work
Date: Tue, 16 Dec 2025 12:09:56 +0100
Message-ID: <20251216111409.668551878@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit 9517b82d8d422d426a988b213fdd45c6b417b86d ]

There is one uaf issue in recv_work when running NBD_CLEAR_SOCK and
NBD_CMD_RECONFIGURE:
  nbd_genl_connect     // conf_ref=2 (connect and recv_work A)
  nbd_open	       // conf_ref=3
  recv_work A done     // conf_ref=2
  NBD_CLEAR_SOCK       // conf_ref=1
  nbd_genl_reconfigure // conf_ref=2 (trigger recv_work B)
  close nbd	       // conf_ref=1
  recv_work B
    config_put         // conf_ref=0
    atomic_dec(&config->recv_threads); -> UAF

Or only running NBD_CLEAR_SOCK:
  nbd_genl_connect   // conf_ref=2
  nbd_open 	     // conf_ref=3
  NBD_CLEAR_SOCK     // conf_ref=2
  close nbd
    nbd_release
      config_put     // conf_ref=1
  recv_work
    config_put 	     // conf_ref=0
    atomic_dec(&config->recv_threads); -> UAF

Commit 87aac3a80af5 ("nbd: call nbd_config_put() before notifying the
waiter") moved nbd_config_put() to run before waking up the waiter in
recv_work, in order to ensure that nbd_start_device_ioctl() would not
be woken up while nbd->task_recv was still uncleared.

However, in nbd_start_device_ioctl(), after being woken up it explicitly
calls flush_workqueue() to make sure all current works are finished.
Therefore, there is no need to move the config put ahead of the wakeup.

Move nbd_config_put() to the end of recv_work, so that the reference is
held for the whole lifetime of the worker thread. This makes sure the
config cannot be freed while recv_work is still running, even if clear
+ reconfigure interleave.

In addition, we don't need to worry about recv_work dropping the last
nbd_put (which causes deadlock):

path A (netlink with NBD_CFLAG_DESTROY_ON_DISCONNECT):
  connect  // nbd_refs=1 (trigger recv_work)
  open nbd // nbd_refs=2
  NBD_CLEAR_SOCK
  close nbd
    nbd_release
      nbd_disconnect_and_put
        flush_workqueue // recv_work done
      nbd_config_put
        nbd_put // nbd_refs=1
      nbd_put // nbd_refs=0
        queue_work

path B (netlink without NBD_CFLAG_DESTROY_ON_DISCONNECT):
  connect  // nbd_refs=2 (trigger recv_work)
  open nbd // nbd_refs=3
  NBD_CLEAR_SOCK // conf_refs=2
  close nbd
    nbd_release
      nbd_config_put // conf_refs=1
      nbd_put // nbd_refs=2
  recv_work done // conf_refs=0, nbd_refs=1
  rmmod // nbd_refs=0

Reported-by: syzbot+56fbf4c7ddf65e95c7cc@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6907edce.a70a0220.37351b.0014.GAE@google.com/T/
Fixes: 87aac3a80af5 ("nbd: make the config put is called before the notifying the waiter")
Depends-on: e2daec488c57 ("nbd: Fix hungtask when nbd_config_put")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index a853c65ac65df..215fc18115b78 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1024,9 +1024,9 @@ static void recv_work(struct work_struct *work)
 	nbd_mark_nsock_dead(nbd, nsock, 1);
 	mutex_unlock(&nsock->tx_lock);
 
-	nbd_config_put(nbd);
 	atomic_dec(&config->recv_threads);
 	wake_up(&config->recv_wq);
+	nbd_config_put(nbd);
 	kfree(args);
 }
 
-- 
2.51.0



