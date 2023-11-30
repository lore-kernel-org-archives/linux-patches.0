Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B9C524C2;
	Thu, 30 Nov 2023 16:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYoKj22q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19594C433C7;
	Thu, 30 Nov 2023 16:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361565;
	bh=NA8l9tZ5BFfKROqeTNgRjSeT1bj2KjjhahjKwTfjCpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYoKj22q3w2K5Qtu/AXKXRYyJ25pkSL7ny3WxwPhifyVJ4KD2hwCvgB38DW157eLd
	 CdiCTdQJaW+Mg0Kk2k7RqYGdT+5stFdobEDmgXYmAP7rkeJ3+SWouCodYzvot/UNJV
	 Imynwsl1frOLTHLusxEkULc1XNB2FEY9kKIPcI6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 072/112] bcache: fixup multi-threaded bch_sectors_dirty_init() wake-up race
Date: Thu, 30 Nov 2023 16:21:59 +0000
Message-ID: <20231130162142.610502672@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

commit 2faac25d7958c4761bb8cec54adb79f806783ad6 upstream.

We get a kernel crash about "unable to handle kernel paging request":

```dmesg
[368033.032005] BUG: unable to handle kernel paging request at ffffffffad9ae4b5
[368033.032007] PGD fc3a0d067 P4D fc3a0d067 PUD fc3a0e063 PMD 8000000fc38000e1
[368033.032012] Oops: 0003 [#1] SMP PTI
[368033.032015] CPU: 23 PID: 55090 Comm: bch_dirtcnt[0] Kdump: loaded Tainted: G           OE    --------- -  - 4.18.0-147.5.1.es8_24.x86_64 #1
[368033.032017] Hardware name: Tsinghua Tongfang THTF Chaoqiang Server/072T6D, BIOS 2.4.3 01/17/2017
[368033.032027] RIP: 0010:native_queued_spin_lock_slowpath+0x183/0x1d0
[368033.032029] Code: 8b 02 48 85 c0 74 f6 48 89 c1 eb d0 c1 e9 12 83 e0
03 83 e9 01 48 c1 e0 05 48 63 c9 48 05 c0 3d 02 00 48 03 04 cd 60 68 93
ad <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 02
[368033.032031] RSP: 0018:ffffbb48852abe00 EFLAGS: 00010082
[368033.032032] RAX: ffffffffad9ae4b5 RBX: 0000000000000246 RCX: 0000000000003bf3
[368033.032033] RDX: ffff97b0ff8e3dc0 RSI: 0000000000600000 RDI: ffffbb4884743c68
[368033.032034] RBP: 0000000000000001 R08: 0000000000000000 R09: 000007ffffffffff
[368033.032035] R10: ffffbb486bb01000 R11: 0000000000000001 R12: ffffffffc068da70
[368033.032036] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
[368033.032038] FS:  0000000000000000(0000) GS:ffff97b0ff8c0000(0000) knlGS:0000000000000000
[368033.032039] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[368033.032040] CR2: ffffffffad9ae4b5 CR3: 0000000fc3a0a002 CR4: 00000000003626e0
[368033.032042] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[368033.032043] bcache: bch_cached_dev_attach() Caching rbd479 as bcache462 on set 8cff3c36-4a76-4242-afaa-7630206bc70b
[368033.032045] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[368033.032046] Call Trace:
[368033.032054]  _raw_spin_lock_irqsave+0x32/0x40
[368033.032061]  __wake_up_common_lock+0x63/0xc0
[368033.032073]  ? bch_ptr_invalid+0x10/0x10 [bcache]
[368033.033502]  bch_dirty_init_thread+0x14c/0x160 [bcache]
[368033.033511]  ? read_dirty_submit+0x60/0x60 [bcache]
[368033.033516]  kthread+0x112/0x130
[368033.033520]  ? kthread_flush_work_fn+0x10/0x10
[368033.034505]  ret_from_fork+0x35/0x40
```

The crash occurred when call wake_up(&state->wait), and then we want
to look at the value in the state. However, bch_sectors_dirty_init()
is not found in the stack of any task. Since state is allocated on
the stack, we guess that bch_sectors_dirty_init() has exited, causing
bch_dirty_init_thread() to be unable to handle kernel paging request.

In order to verify this idea, we added some printing information during
wake_up(&state->wait). We find that "wake up" is printed twice, however
we only expect the last thread to wake up once.

```dmesg
[  994.641004] alcache: bch_dirty_init_thread() wake up
[  994.641018] alcache: bch_dirty_init_thread() wake up
[  994.641523] alcache: bch_sectors_dirty_init() init exit
```

There is a race. If bch_sectors_dirty_init() exits after the first wake
up, the second wake up will trigger this bug("unable to handle kernel
paging request").

Proceed as follows:

bch_sectors_dirty_init
    kthread_run ==============> bch_dirty_init_thread(bch_dirtcnt[0])
            ...                         ...
    atomic_inc(&state.started)          ...
            ...                         ...
    atomic_read(&state.enough)          ...
            ...                 atomic_set(&state->enough, 1)
    kthread_run ======================================================> bch_dirty_init_thread(bch_dirtcnt[1])
            ...                 atomic_dec_and_test(&state->started)            ...
    atomic_inc(&state.started)          ...                                     ...
            ...                 wake_up(&state->wait)                           ...
    atomic_read(&state.enough)                                          atomic_dec_and_test(&state->started)
            ...                                                                 ...
    wait_event(state.wait, atomic_read(&state.started) == 0)                    ...
    return                                                                      ...
                                                                        wake_up(&state->wait)

We believe it is very common to wake up twice if there is no dirty, but
crash is an extremely low probability event. It's hard for us to reproduce
this issue. We attached and detached continuously for a week, with a total
of more than one million attaches and only one crash.

Putting atomic_inc(&state.started) before kthread_run() can avoid waking
up twice.

Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be multithreaded")
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Cc:  <stable@vger.kernel.org>
Signed-off-by: Coly Li <colyli@suse.de>
Link: https://lore.kernel.org/r/20231120052503.6122-8-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/writeback.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -1014,17 +1014,18 @@ void bch_sectors_dirty_init(struct bcach
 		if (atomic_read(&state.enough))
 			break;
 
+		atomic_inc(&state.started);
 		state.infos[i].state = &state;
 		state.infos[i].thread =
 			kthread_run(bch_dirty_init_thread, &state.infos[i],
 				    "bch_dirtcnt[%d]", i);
 		if (IS_ERR(state.infos[i].thread)) {
 			pr_err("fails to run thread bch_dirty_init[%d]\n", i);
+			atomic_dec(&state.started);
 			for (--i; i >= 0; i--)
 				kthread_stop(state.infos[i].thread);
 			goto out;
 		}
-		atomic_inc(&state.started);
 	}
 
 out:


