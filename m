Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456E246B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0271C433EF;
	Mon, 16 Jan 2023 16:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886351;
	bh=7WpPQ3defKTuGZnnRJZBdNPv8X4+ILUJ6TyEU8dBKH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IpS7RUgg+C4j0XMDWPKHaAcjj6deSg7GxXc/ILIOmvfdNBpMLfu5ldk1KSxouSeDl
	 x8ERQ68lTSJvJ4f5jo7QnA5HfrbSfylG2tgSkQ7q1O1P1whswhmkqKN84zFFiOC/hd
	 6C0fB7x/5tx6uR/b6dUKxHYxtwcWtnTeFhYIwb6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+95001b1fd6dfcc716c29@syzkaller.appspotmail.com,
	Shigeru Yoshida <syoshida@redhat.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 398/658] wifi: ar5523: Fix use-after-free on ar5523_cmd() timed out
Date: Mon, 16 Jan 2023 16:48:06 +0100
Message-Id: <20230116154927.786883277@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit b6702a942a069c2a975478d719e98d83cdae1797 ]

syzkaller reported use-after-free with the stack trace like below [1]:

[   38.960489][    C3] ==================================================================
[   38.963216][    C3] BUG: KASAN: use-after-free in ar5523_cmd_tx_cb+0x220/0x240
[   38.964950][    C3] Read of size 8 at addr ffff888048e03450 by task swapper/3/0
[   38.966363][    C3]
[   38.967053][    C3] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 6.0.0-09039-ga6afa4199d3d-dirty #18
[   38.968464][    C3] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.fc36 04/01/2014
[   38.969959][    C3] Call Trace:
[   38.970841][    C3]  <IRQ>
[   38.971663][    C3]  dump_stack_lvl+0xfc/0x174
[   38.972620][    C3]  print_report.cold+0x2c3/0x752
[   38.973626][    C3]  ? ar5523_cmd_tx_cb+0x220/0x240
[   38.974644][    C3]  kasan_report+0xb1/0x1d0
[   38.975720][    C3]  ? ar5523_cmd_tx_cb+0x220/0x240
[   38.976831][    C3]  ar5523_cmd_tx_cb+0x220/0x240
[   38.978412][    C3]  __usb_hcd_giveback_urb+0x353/0x5b0
[   38.979755][    C3]  usb_hcd_giveback_urb+0x385/0x430
[   38.981266][    C3]  dummy_timer+0x140c/0x34e0
[   38.982925][    C3]  ? notifier_call_chain+0xb5/0x1e0
[   38.984761][    C3]  ? rcu_read_lock_sched_held+0xb/0x60
[   38.986242][    C3]  ? lock_release+0x51c/0x790
[   38.987323][    C3]  ? _raw_read_unlock_irqrestore+0x37/0x70
[   38.988483][    C3]  ? __wake_up_common_lock+0xde/0x130
[   38.989621][    C3]  ? reacquire_held_locks+0x4a0/0x4a0
[   38.990777][    C3]  ? lock_acquire+0x472/0x550
[   38.991919][    C3]  ? rcu_read_lock_sched_held+0xb/0x60
[   38.993138][    C3]  ? lock_acquire+0x472/0x550
[   38.994890][    C3]  ? dummy_urb_enqueue+0x860/0x860
[   38.996266][    C3]  ? do_raw_spin_unlock+0x16f/0x230
[   38.997670][    C3]  ? dummy_urb_enqueue+0x860/0x860
[   38.999116][    C3]  call_timer_fn+0x1a0/0x6a0
[   39.000668][    C3]  ? add_timer_on+0x4a0/0x4a0
[   39.002137][    C3]  ? reacquire_held_locks+0x4a0/0x4a0
[   39.003809][    C3]  ? __next_timer_interrupt+0x226/0x2a0
[   39.005509][    C3]  __run_timers.part.0+0x69a/0xac0
[   39.007025][    C3]  ? dummy_urb_enqueue+0x860/0x860
[   39.008716][    C3]  ? call_timer_fn+0x6a0/0x6a0
[   39.010254][    C3]  ? cpuacct_percpu_seq_show+0x10/0x10
[   39.011795][    C3]  ? kvm_sched_clock_read+0x14/0x40
[   39.013277][    C3]  ? sched_clock_cpu+0x69/0x2b0
[   39.014724][    C3]  run_timer_softirq+0xb6/0x1d0
[   39.016196][    C3]  __do_softirq+0x1d2/0x9be
[   39.017616][    C3]  __irq_exit_rcu+0xeb/0x190
[   39.019004][    C3]  irq_exit_rcu+0x5/0x20
[   39.020361][    C3]  sysvec_apic_timer_interrupt+0x8f/0xb0
[   39.021965][    C3]  </IRQ>
[   39.023237][    C3]  <TASK>

In ar5523_probe(), ar5523_host_available() calls ar5523_cmd() as below
(there are other functions which finally call ar5523_cmd()):

ar5523_probe()
-> ar5523_host_available()
   -> ar5523_cmd_read()
      -> ar5523_cmd()

If ar5523_cmd() timed out, then ar5523_host_available() failed and
ar5523_probe() freed the device structure.  So, ar5523_cmd_tx_cb()
might touch the freed structure.

This patch fixes this issue by canceling in-flight tx cmd if submitted
urb timed out.

Link: https://syzkaller.appspot.com/bug?id=9e12b2d54300842b71bdd18b54971385ff0d0d3a [1]
Reported-by: syzbot+95001b1fd6dfcc716c29@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221009183223.420015-1-syoshida@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 58e189ec672f..5d3cf354f6cb 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -241,6 +241,11 @@ static void ar5523_cmd_tx_cb(struct urb *urb)
 	}
 }
 
+static void ar5523_cancel_tx_cmd(struct ar5523 *ar)
+{
+	usb_kill_urb(ar->tx_cmd.urb_tx);
+}
+
 static int ar5523_cmd(struct ar5523 *ar, u32 code, const void *idata,
 		      int ilen, void *odata, int olen, int flags)
 {
@@ -280,6 +285,7 @@ static int ar5523_cmd(struct ar5523 *ar, u32 code, const void *idata,
 	}
 
 	if (!wait_for_completion_timeout(&cmd->done, 2 * HZ)) {
+		ar5523_cancel_tx_cmd(ar);
 		cmd->odata = NULL;
 		ar5523_err(ar, "timeout waiting for command %02x reply\n",
 			   code);
-- 
2.35.1



