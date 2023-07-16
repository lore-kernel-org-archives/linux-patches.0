Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0834F8F40
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B74C433C7;
	Sun, 16 Jul 2023 20:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539579;
	bh=Nxz3PYYkNkUnuZp2/1C8x8557eiEJXMxecNopkg2yBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8JpYpY1NtM7eM4sF2DShMlyX2wFpzntqjx4bLk0pIndY3QvATDyU6b0hdMBEEt5V
	 PQNar7K4Slf7E7XbYHpFaMEtIVNj+ze5iG8Z79b3AYi/LdULJCIkZl9AIyLZTUg7XV
	 x5OT3qo4dVfOuAIFgwpcxKbMx3VkDjmJhUMYG3MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/591] rcu/rcuscale: Stop kfree_scale_thread thread(s) after unloading rcuscale
Date: Sun, 16 Jul 2023 21:43:17 +0200
Message-ID: <20230716194925.382368146@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 23fc8df26dead16687ae6eb47b0561a4a832e2f6 ]

Running the 'kfree_rcu_test' test case [1] results in a splat [2].
The root cause is the kfree_scale_thread thread(s) continue running
after unloading the rcuscale module.  This commit fixes that isue by
invoking kfree_scale_cleanup() from rcu_scale_cleanup() when removing
the rcuscale module.

[1] modprobe rcuscale kfree_rcu_test=1
    // After some time
    rmmod rcuscale
    rmmod torture

[2] BUG: unable to handle page fault for address: ffffffffc0601a87
    #PF: supervisor instruction fetch in kernel mode
    #PF: error_code(0x0010) - not-present page
    PGD 11de4f067 P4D 11de4f067 PUD 11de51067 PMD 112f4d067 PTE 0
    Oops: 0010 [#1] PREEMPT SMP NOPTI
    CPU: 1 PID: 1798 Comm: kfree_scale_thr Not tainted 6.3.0-rc1-rcu+ #1
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
    RIP: 0010:0xffffffffc0601a87
    Code: Unable to access opcode bytes at 0xffffffffc0601a5d.
    RSP: 0018:ffffb25bc2e57e18 EFLAGS: 00010297
    RAX: 0000000000000000 RBX: ffffffffc061f0b6 RCX: 0000000000000000
    RDX: 0000000000000000 RSI: ffffffff962fd0de RDI: ffffffff962fd0de
    RBP: ffffb25bc2e57ea8 R08: 0000000000000000 R09: 0000000000000000
    R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
    R13: 0000000000000000 R14: 000000000000000a R15: 00000000001c1dbe
    FS:  0000000000000000(0000) GS:ffff921fa2200000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: ffffffffc0601a5d CR3: 000000011de4c006 CR4: 0000000000370ee0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
    Call Trace:
     <TASK>
     ? kvfree_call_rcu+0xf0/0x3a0
     ? kthread+0xf3/0x120
     ? kthread_complete_and_exit+0x20/0x20
     ? ret_from_fork+0x1f/0x30
     </TASK>
    Modules linked in: rfkill sunrpc ... [last unloaded: torture]
    CR2: ffffffffc0601a87
    ---[ end trace 0000000000000000 ]---

Fixes: e6e78b004fa7 ("rcuperf: Add kfree_rcu() performance Tests")
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcuscale.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/rcu/rcuscale.c b/kernel/rcu/rcuscale.c
index 63e4c2d629a96..7854dc3226e1b 100644
--- a/kernel/rcu/rcuscale.c
+++ b/kernel/rcu/rcuscale.c
@@ -734,6 +734,11 @@ rcu_scale_cleanup(void)
 	if (gp_exp && gp_async)
 		SCALEOUT_ERRSTRING("No expedited async GPs, so went with async!");
 
+	if (kfree_rcu_test) {
+		kfree_scale_cleanup();
+		return;
+	}
+
 	if (torture_cleanup_begin())
 		return;
 	if (!cur_ops) {
-- 
2.39.2



