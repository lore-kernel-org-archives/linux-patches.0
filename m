Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661DD86334;
	Thu, 15 Jan 2026 17:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497444; cv=none; b=YYAcRzlQGpnrsTfltiOjHPxXaLGiiKOGfkHFX9lwT8waUJXZbnM2NcTu4DV12vG049Bh+UQE/Umf61UPVFWw3jUlfFRobTF7AEwPR0zeDA1jpYrfw9oDJ31HE4JXBdwOPuoWUxl/n3GZu+KeT74xNb1c6V45EniklOa/9wA19r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497444; c=relaxed/simple;
	bh=MSeyXNLmmDx9adEcbSGmPUK2GiG7Hkbs3LkFV+I8x88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1RjfQ3NfnVFAmMe+c9qkH65Yihkhp3yxReYGV9hlLzZLGmjY+Can8ab5MddyFjwB0YCbyE163q6XMWxxpoa8siYj/6tYvdz5J0n+62StAOmxNFOPt1VYmYq6vP5sJuVkGUw676G5oXYdzk8YFKZs6bRpsNJlCCw/Sgp4BZS5rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5oNMlqx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5oNMlqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7615C116D0;
	Thu, 15 Jan 2026 17:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497444;
	bh=MSeyXNLmmDx9adEcbSGmPUK2GiG7Hkbs3LkFV+I8x88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5oNMlqxOdSWb1bv7+xzbDNmnZ39Iu16vkF8Ps/My8OST3yUQ75KjwpLuh5bVC5V5
	 nUhwzIfj6JDk+KgnvKPOt03Kf7lBvKtvPv2c9HLmaX9J1OHZH5Zj2Y+wtjVIQH9S8n
	 W6u7mSR9BfzK/nWRlPlxNOQ+HJKP89rYlFg1oMNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+56fbf4c7ddf65e95c7cc@syzkaller.appspotmail.com,
	Zheng Qixing <zhengqixing@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/554] nbd: defer config put in recv_work
Date: Thu, 15 Jan 2026 17:42:29 +0100
Message-ID: <20260115164249.244847535@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index eb37427a3c019..ae89f6124cc6b 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -836,9 +836,9 @@ static void recv_work(struct work_struct *work)
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



