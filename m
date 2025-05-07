Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593D929A0;
	Wed,  7 May 2025 18:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643554; cv=none; b=PhATlp3wabJqWazsTxHgQRUq+PxdtQXhTDAYBSiwv3+XW2kHT9CT3FaIB9wx/b5QdzXDMUXXiJxuh/y/Ycse9LWmHS39neIGt2LumSogXwi4u++ddHjzpIVAM8VobFLntSUBnCxBtGmphku3/AJVFkHLNPdYljUkV+6BzMvUZPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643554; c=relaxed/simple;
	bh=VtUnojbH2G8fYbyQ+fyK7a2NEk4YBYR/t/9umPRGDb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXrZ8ONo/MHH1jbSZMeln//DDuE++LpVwqmUVHyUdGyUm5AF9UhAUnSkwHl+TctDjNzW3aAMN3f9Gy0VdHEUvpMRGtEzYBRCD0dZUPo1iLe5F8o8bf49haI+lY7GMRDgk1GaFwbBmRJDXBFXt9ZuB+veWkCJI6DBQYT6tmdWnxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6qyZjAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6qyZjAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9681C4CEEB;
	Wed,  7 May 2025 18:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643554;
	bh=VtUnojbH2G8fYbyQ+fyK7a2NEk4YBYR/t/9umPRGDb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6qyZjATe9jRzKkE0qUVS+PV2bNj1/1P8KatfN6oWjohMtkQPen5DO+xqk5kddyUC
	 QPlfMAOsYoYLloUqcMp33jPmOpsRMi7JM//EC1eGrjFJ9syyFKJ5pkf+IX1chV0X7F
	 GDURJQhxYyqlocFtQp6WOvvuDHLBSPE8XgnxX8+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LongPing Wei <weilongping@oppo.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 40/97] dm-bufio: dont schedule in atomic context
Date: Wed,  7 May 2025 20:39:15 +0200
Message-ID: <20250507183808.605491441@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: LongPing Wei <weilongping@oppo.com>

commit a3d8f0a7f5e8b193db509c7191fefeed3533fc44 upstream.

A BUG was reported as below when CONFIG_DEBUG_ATOMIC_SLEEP and
try_verify_in_tasklet are enabled.
[  129.444685][  T934] BUG: sleeping function called from invalid context at drivers/md/dm-bufio.c:2421
[  129.444723][  T934] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 934, name: kworker/1:4
[  129.444740][  T934] preempt_count: 201, expected: 0
[  129.444756][  T934] RCU nest depth: 0, expected: 0
[  129.444781][  T934] Preemption disabled at:
[  129.444789][  T934] [<ffffffd816231900>] shrink_work+0x21c/0x248
[  129.445167][  T934] kernel BUG at kernel/sched/walt/walt_debug.c:16!
[  129.445183][  T934] Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
[  129.445204][  T934] Skip md ftrace buffer dump for: 0x1609e0
[  129.447348][  T934] CPU: 1 PID: 934 Comm: kworker/1:4 Tainted: G        W  OE      6.6.56-android15-8-o-g6f82312b30b9-debug #1 1400000003000000474e5500b3187743670464e8
[  129.447362][  T934] Hardware name: Qualcomm Technologies, Inc. Parrot QRD, Alpha-M (DT)
[  129.447373][  T934] Workqueue: dm_bufio_cache shrink_work
[  129.447394][  T934] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  129.447406][  T934] pc : android_rvh_schedule_bug+0x0/0x8 [sched_walt_debug]
[  129.447435][  T934] lr : __traceiter_android_rvh_schedule_bug+0x44/0x6c
[  129.447451][  T934] sp : ffffffc0843dbc90
[  129.447459][  T934] x29: ffffffc0843dbc90 x28: ffffffffffffffff x27: 0000000000000c8b
[  129.447479][  T934] x26: 0000000000000040 x25: ffffff804b3d6260 x24: ffffffd816232b68
[  129.447497][  T934] x23: ffffff805171c5b4 x22: 0000000000000000 x21: ffffffd816231900
[  129.447517][  T934] x20: ffffff80306ba898 x19: 0000000000000000 x18: ffffffc084159030
[  129.447535][  T934] x17: 00000000d2b5dd1f x16: 00000000d2b5dd1f x15: ffffffd816720358
[  129.447554][  T934] x14: 0000000000000004 x13: ffffff89ef978000 x12: 0000000000000003
[  129.447572][  T934] x11: ffffffd817a823c4 x10: 0000000000000202 x9 : 7e779c5735de9400
[  129.447591][  T934] x8 : ffffffd81560d004 x7 : 205b5d3938373434 x6 : ffffffd8167397c8
[  129.447610][  T934] x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffffffc0843db9e0
[  129.447629][  T934] x2 : 0000000000002f15 x1 : 0000000000000000 x0 : 0000000000000000
[  129.447647][  T934] Call trace:
[  129.447655][  T934]  android_rvh_schedule_bug+0x0/0x8 [sched_walt_debug 1400000003000000474e550080cce8a8a78606b6]
[  129.447681][  T934]  __might_resched+0x190/0x1a8
[  129.447694][  T934]  shrink_work+0x180/0x248
[  129.447706][  T934]  process_one_work+0x260/0x624
[  129.447718][  T934]  worker_thread+0x28c/0x454
[  129.447729][  T934]  kthread+0x118/0x158
[  129.447742][  T934]  ret_from_fork+0x10/0x20
[  129.447761][  T934] Code: ???????? ???????? ???????? d2b5dd1f (d4210000)
[  129.447772][  T934] ---[ end trace 0000000000000000 ]---

dm_bufio_lock will call spin_lock_bh when try_verify_in_tasklet
is enabled, and __scan will be called in atomic context.

Fixes: 7cd326747f46 ("dm bufio: remove dm_bufio_cond_resched()")
Signed-off-by: LongPing Wei <weilongping@oppo.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-bufio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1685,7 +1685,8 @@ static void __scan(struct dm_bufio_clien
 				atomic_long_dec(&c->need_shrink);
 				freed++;
 			}
-			cond_resched();
+			if (!(static_branch_unlikely(&no_sleep_enabled) && c->no_sleep))
+				cond_resched();
 		}
 	}
 }


