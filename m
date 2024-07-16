Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A9A1DDCE;
	Tue, 16 Jul 2024 15:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145174; cv=none; b=MSoizK0f4CVK0PWRF8DnW28j/fZdkUXPpFI08/cXQ/g2gP46+2OKfAhWQ9DjC5D2J7coOESVu3ZkcdxFzyPti8Mtt3rZvc08+4HbNIUJ0RWljMDKWN90RxCssHI/d8K+JhFLuOglCGXNdKbNpq17ukk/C1luJQS9lOIQ/42FohE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145174; c=relaxed/simple;
	bh=gpXPr6/OGCxFAk1mFgEUzLMt/yRsFmZnsRUqN/4SSbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SITEImUS1v96+d1G5n/Shk0Uu3uA6FB8P3sHr7dn9HEda3CwEHdygJHjDuxaweBujEcGkIgN9VToKvCXsRaedJiPyAFJSGj8byUH4O7dHaSu/aHIBAOULASERzTIyE4I0oYw3KZqewWyooCO8+fHWkqDFkwj4suLegQmMXPL8zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgNpc245; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgNpc245"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF71C116B1;
	Tue, 16 Jul 2024 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145174;
	bh=gpXPr6/OGCxFAk1mFgEUzLMt/yRsFmZnsRUqN/4SSbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgNpc245L2GJg9BO21n/1d7COThj3AMfm2ZBbeF90zN+X4pXMAGski568m41GYFhq
	 3tyELpHmlL58LA0eD/4bKd19GaoCw58fFcGnaxYTxhH+NhvzMG5iHNv1HwssvKE8jM
	 3d6v9o/PR0rFgkFoUIatroa1611bdEx9mK+P6ZU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.9 122/143] wireguard: queueing: annotate intentional data race in cpu round robin
Date: Tue, 16 Jul 2024 17:31:58 +0200
Message-ID: <20240716152800.674620467@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
 


