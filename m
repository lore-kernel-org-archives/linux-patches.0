Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068271DDCE;
	Tue, 16 Jul 2024 16:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145930; cv=none; b=h7f8e0zrgES+rAYvgXMQYUf1oI92lEZZjShc085FbIGuGnGA7WRBJPJq5b63FwEQVtJPZv9WMCZQQyRpuxJT6l17YF1fAD5XKnvMQyXwnOzaK+UF+S86YXjoZrr2S0UH5AY+9azG3+zVyGkr/y39pLoI0QiJ2X8/b5JlpMy+hSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145930; c=relaxed/simple;
	bh=8r+ZNkOEXRpBOWLARyBeXR4DnByqHRXIulT216Kdv2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYFhpoLcyoE7gxfE5zWi+sU9DmUr3I+vDKxUVCQxHXyGbP0teZ9gCmjRGRuLelRoroKJs4v7oifphPdYcmD7+/pjraszPvZT83wfuEHx1VZnXesgQs74Wvea2KGMEfuQVGopeVSEbVCY1AvQdFV+idaOdfKwesdnuDb4nclXRqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBDmJvav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBDmJvav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82501C116B1;
	Tue, 16 Jul 2024 16:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145929;
	bh=8r+ZNkOEXRpBOWLARyBeXR4DnByqHRXIulT216Kdv2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBDmJvavDXIGT4x0XD6EF1TnZfo6EM58ufe54CFK0FDSkyAfbeGu7WxTf6/q58Hmn
	 O3UejkLhIvxVVN6TjEmOMAdHYX16wd5NbbCtt6W9k+073JYKt5UyV+Ei2ZvRMyWm2v
	 GaqDDVPLBkexzKx8cmECWt1M+YObxR4Fnuure7o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 095/121] wireguard: queueing: annotate intentional data race in cpu round robin
Date: Tue, 16 Jul 2024 17:32:37 +0200
Message-ID: <20240716152754.983807546@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


