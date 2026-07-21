Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9178E3E3DB4;
	Tue, 21 Jul 2026 20:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664602; cv=none; b=OsMpG9zr8wBYJpG9Guex86O5VaLJigrsSbDo846rOaM/JyNdLHRezuEhwdA/WQ1BwPZkXaqJTG0xwujUrWtnANy5Vs6AyBbt+Io1ihP5uBoO8/CqcwCRSwbAFUYDhXLQAy/IHUE7NSMBKEKu4v3OlZ0iSnCrU238n/yXYyTQqzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664602; c=relaxed/simple;
	bh=LvxKmc2bNlKoCNqmGvOTaqtOvGSv+HZR8bX8coP5vDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLeitNFooS8ZmbrCPqKFD1FYJQwtE0bLk/r5ALOW/bh6u83JlDRkuOH3B9xNvUV/LWo2bTVYt6l6tra9ir1cK7iS5YokDb2KU4zJHHW5dNrKLEHzbowP090QRrUR0hnRlEYeMN3QeyNmHz398HWnPW0Rk3jTiG/eYN+862U8BEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFRvMX7f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFRvMX7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000F81F00A3A;
	Tue, 21 Jul 2026 20:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664601;
	bh=SBVOvAiepBVAKKyizmWkRmSLl4yCMVxYSkXd/bkblB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFRvMX7f+g0t4Rce76qcUH9AZDUigbU8lIU5hZkS3P0WS23T7LC0FmVrJv9M6xdaC
	 rP8/qv5bim63P2V3pE1YvgjMFRR+UHxUzMRraYo5uDX86FW6I34Yh55RovwwFMXHZL
	 rdN1CIH2cB1qGmDKN9YgFKQ0eBECLaMV1b5qMfCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 1263/1276] udp_tunnel: fix deadlock in udp_tunnel_nic_set_port_priv()
Date: Tue, 21 Jul 2026 17:28:26 +0200
Message-ID: <20260721152514.354773874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit c9e78afa688afec528784b79bb02d513cdcd6527 upstream.

While configuring a vxlan tunnel in a system with a i40e NIC driver, I
observe the following deadlock:

 WARNING: possible recursive locking detected
 6.16.0-rc2.net-next-6.16_92d87230d899+ #13 Tainted: G            E
 --------------------------------------------
 kworker/u256:4/1125 is trying to acquire lock:
 ffff88921ab9c8c8 (&utn->lock){+.+.}-{4:4}, at: i40e_udp_tunnel_set_port (/home/pabeni/net-next/include/net/udp_tunnel.h:343 /home/pabeni/net-next/drivers/net/ethernet/intel/i40e/i40e_main.c:13013) i40e

 but task is already holding lock:
 ffff88921ab9c8c8 (&utn->lock){+.+.}-{4:4}, at: udp_tunnel_nic_device_sync_work (/home/pabeni/net-next/net/ipv4/udp_tunnel_nic.c:739) udp_tunnel

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&utn->lock);
   lock(&utn->lock);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 4 locks held by kworker/u256:4/1125:
 #0: ffff8892910ca158 ((wq_completion)udp_tunnel_nic){+.+.}-{0:0}, at: process_one_work (/home/pabeni/net-next/kernel/workqueue.c:3213)
 #1: ffffc900244efd30 ((work_completion)(&utn->work)){+.+.}-{0:0}, at: process_one_work (/home/pabeni/net-next/kernel/workqueue.c:3214)
 #2: ffffffff9a14e290 (rtnl_mutex){+.+.}-{4:4}, at: udp_tunnel_nic_device_sync_work (/home/pabeni/net-next/net/ipv4/udp_tunnel_nic.c:737) udp_tunnel
 #3: ffff88921ab9c8c8 (&utn->lock){+.+.}-{4:4}, at: udp_tunnel_nic_device_sync_work (/home/pabeni/net-next/net/ipv4/udp_tunnel_nic.c:739) udp_tunnel

 stack backtrace:
 Hardware name: Dell Inc. PowerEdge R7525/0YHMCJ, BIOS 2.2.5 04/08/2021
i
 Call Trace:
  <TASK>
 dump_stack_lvl (/home/pabeni/net-next/lib/dump_stack.c:123)
 print_deadlock_bug (/home/pabeni/net-next/kernel/locking/lockdep.c:3047)
 validate_chain (/home/pabeni/net-next/kernel/locking/lockdep.c:3901)
 __lock_acquire (/home/pabeni/net-next/kernel/locking/lockdep.c:5240)
 lock_acquire.part.0 (/home/pabeni/net-next/kernel/locking/lockdep.c:473 /home/pabeni/net-next/kernel/locking/lockdep.c:5873)
 __mutex_lock (/home/pabeni/net-next/kernel/locking/mutex.c:604 /home/pabeni/net-next/kernel/locking/mutex.c:747)
 i40e_udp_tunnel_set_port (/home/pabeni/net-next/include/net/udp_tunnel.h:343 /home/pabeni/net-next/drivers/net/ethernet/intel/i40e/i40e_main.c:13013) i40e
 udp_tunnel_nic_device_sync_by_port (/home/pabeni/net-next/net/ipv4/udp_tunnel_nic.c:230 /home/pabeni/net-next/net/ipv4/udp_tunnel_nic.c:249) udp_tunnel
 __udp_tunnel_nic_device_sync.part.0 (/home/pabeni/net-next/net/ipv4/udp_tunnel_nic.c:292) udp_tunnel
 udp_tunnel_nic_device_sync_work (/home/pabeni/net-next/net/ipv4/udp_tunnel_nic.c:742) udp_tunnel
 process_one_work (/home/pabeni/net-next/kernel/workqueue.c:3243)
 worker_thread (/home/pabeni/net-next/kernel/workqueue.c:3315 /home/pabeni/net-next/kernel/workqueue.c:3402)
 kthread (/home/pabeni/net-next/kernel/kthread.c:464)

AFAICS all the existing callsites of udp_tunnel_nic_set_port_priv() are
already under the utn lock scope, avoid (re-)acquiring it in such a
function.

Fixes: 1ead7501094c ("udp_tunnel: remove rtnl_lock dependency")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/95a827621ec78c12d1564ec3209e549774f9657d.1750675978.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/udp_tunnel.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -323,9 +323,8 @@ udp_tunnel_nic_set_port_priv(struct net_
 			     unsigned int idx, u8 priv)
 {
 	if (udp_tunnel_nic_ops) {
-		udp_tunnel_nic_ops->lock(dev);
+		udp_tunnel_nic_ops->assert_locked(dev);
 		udp_tunnel_nic_ops->set_port_priv(dev, table, idx, priv);
-		udp_tunnel_nic_ops->unlock(dev);
 	}
 }
 


