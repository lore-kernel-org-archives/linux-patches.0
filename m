Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43DA1A00DF;
	Tue, 16 Jul 2024 15:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145466; cv=none; b=kInHLZN7Dqk4S28Ve0/D98Y3ssPiXw1nHkfZmAJdAXnffH7EkegYuRhYYKt+RARRgTpfC1IbguuVL8h1gKDrZRgo8hGkU0xtdivKQ8YQd+67DM6sr3oRc7IVMtKzhptSw+7yx/46PvK68/dTxUXdGmwMbEv/GzCWl+K+oOMGHIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145466; c=relaxed/simple;
	bh=x/0ZVa94lZEZXxb5aqK16O+QMzqiTsLeqKH7vJkJeNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBitt1mJEmfACb85DokfRuKaH5PB/Z8/typxustkZAoeSwDizA/cc5rt2OW85wf6iqQ0rE7rNrkyVC7yUFyB0BA9txxUihD/Ip27BTsUKYV9X4ryuX4aDjyoORqerJK3GxP39sKGxW1OVLkousv9oYmOVAEvsCr+9bR0QUcVL68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Os0lo2IE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Os0lo2IE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEE1C4AF0E;
	Tue, 16 Jul 2024 15:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145466;
	bh=x/0ZVa94lZEZXxb5aqK16O+QMzqiTsLeqKH7vJkJeNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Os0lo2IE28Q9bOdeWWFZkdIR6TJ+FREVKtOo4gqaCRuMFxk4G7EoXrGz7mxFgtU2y
	 cX/sMuo+RlE/mIG6tByep34D9AIl1CtlJSJIhYaileghJX8ZWfpUrFGjO7RgiL9zmU
	 fs1dU/IXiecfOuNcN4kMN0brGD5fwlCjUY8ScrI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 75/96] wireguard: queueing: annotate intentional data race in cpu round robin
Date: Tue, 16 Jul 2024 17:32:26 +0200
Message-ID: <20240716152749.395943003@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 2fe3d6d2053c57f2eae5e85ca1656d185ebbe4e8 upstream.

KCSAN reports a race in the CPU round robin function, which, as the
comment points out, is intentional:

    BUG: KCSAN: data-race in wg_packet_send_staged_packets / wg_packet_send_staged_packets

    read to 0xffff88811254eb28 of 4 bytes by task 3160 on cpu 1:
     wg_cpumask_next_online drivers/net/wireguard/queueing.h:127 [inline]
     wg_queue_enqueue_per_device_and_peer drivers/net/wireguard/queueing.h:173 [inline]
     wg_packet_create_data drivers/net/wireguard/send.c:320 [inline]
     wg_packet_send_staged_packets+0x60e/0xac0 drivers/net/wireguard/send.c:388
     wg_packet_send_keepalive+0xe2/0x100 drivers/net/wireguard/send.c:239
     wg_receive_handshake_packet drivers/net/wireguard/receive.c:186 [inline]
     wg_packet_handshake_receive_worker+0x449/0x5f0 drivers/net/wireguard/receive.c:213
     process_one_work kernel/workqueue.c:3248 [inline]
     process_scheduled_works+0x483/0x9a0 kernel/workqueue.c:3329
     worker_thread+0x526/0x720 kernel/workqueue.c:3409
     kthread+0x1d1/0x210 kernel/kthread.c:389
     ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
     ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

    write to 0xffff88811254eb28 of 4 bytes by task 3158 on cpu 0:
     wg_cpumask_next_online drivers/net/wireguard/queueing.h:130 [inline]
     wg_queue_enqueue_per_device_and_peer drivers/net/wireguard/queueing.h:173 [inline]
     wg_packet_create_data drivers/net/wireguard/send.c:320 [inline]
     wg_packet_send_staged_packets+0x6e5/0xac0 drivers/net/wireguard/send.c:388
     wg_packet_send_keepalive+0xe2/0x100 drivers/net/wireguard/send.c:239
     wg_receive_handshake_packet drivers/net/wireguard/receive.c:186 [inline]
     wg_packet_handshake_receive_worker+0x449/0x5f0 drivers/net/wireguard/receive.c:213
     process_one_work kernel/workqueue.c:3248 [inline]
     process_scheduled_works+0x483/0x9a0 kernel/workqueue.c:3329
     worker_thread+0x526/0x720 kernel/workqueue.c:3409
     kthread+0x1d1/0x210 kernel/kthread.c:389
     ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
     ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

    value changed: 0xffffffff -> 0x00000000

Mark this race as intentional by using READ/WRITE_ONCE().

Cc: stable@vger.kernel.org
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://patch.msgid.link/20240704154517.1572127-4-Jason@zx2c4.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/queueing.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -124,10 +124,10 @@ static inline int wg_cpumask_choose_onli
  */
 static inline int wg_cpumask_next_online(int *last_cpu)
 {
-	int cpu = cpumask_next(*last_cpu, cpu_online_mask);
+	int cpu = cpumask_next(READ_ONCE(*last_cpu), cpu_online_mask);
 	if (cpu >= nr_cpu_ids)
 		cpu = cpumask_first(cpu_online_mask);
-	*last_cpu = cpu;
+	WRITE_ONCE(*last_cpu, cpu);
 	return cpu;
 }
 


