Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E7A134AC;
	Mon, 12 Aug 2024 16:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480022; cv=none; b=kWlwkvh25wurS7ssufXs3G1002TOL2bccRKVVb6Kr0zy13X7T1x6pEG6CMSCy3FKw3Q/0y8FDZaCZEXmWvjhlest4Q5/Uyb3k9ToSgEy9tvn/lNfHRqKoacWFMVAC5NByCx5WMj47+b8Ex0vp0XF77vBzDgAabxk5YDU+BAYn7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480022; c=relaxed/simple;
	bh=tGqHcvLzETfqdueGl4rmBbL2jVcCAI7EwU7BeGC/bok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxbpUZLXUwo9wHP4u6/VhInigM0w0X3MTZgFPQscpHnitXG7bQCCfiO3zLaYn3afywUJ/c6f5xNy8JKpOWZtno5iwUU98Wnvcnt/9QZbVgHEr9cJNgoMFNCeX1Dqx5onmIZpbZ/poaMH0wEPX4q5CEWXJAW6ZYmPgB/ts6Mu+gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fgu5GyHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fgu5GyHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EE9C32782;
	Mon, 12 Aug 2024 16:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480022;
	bh=tGqHcvLzETfqdueGl4rmBbL2jVcCAI7EwU7BeGC/bok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fgu5GyHbA/WtQ2Ar2n5Y4oleEASRZ5COHcThfsmlUZ1JzT7Dxsc+6Be28SNfb8uNc
	 me36ercAh2TcGlvg8SuDlXXj57ZkaGZOKUrJLGo50TJn5tD9qVpRIaB5mIZIeb2sBa
	 69Hbl/SWCAMRuHfXquK5fdcoVplxs2RYR9thEHks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 072/263] wifi: mac80211: fix NULL dereference at band check in starting tx ba session
Date: Mon, 12 Aug 2024 18:01:13 +0200
Message-ID: <20240812160149.299675272@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 021d53a3d87eeb9dbba524ac515651242a2a7e3b ]

In MLD connection, link_data/link_conf are dynamically allocated. They
don't point to vif->bss_conf. So, there will be no chanreq assigned to
vif->bss_conf and then the chan will be NULL. Tweak the code to check
ht_supported/vht_supported/has_he/has_eht on sta deflink.

Crash log (with rtw89 version under MLO development):
[ 9890.526087] BUG: kernel NULL pointer dereference, address: 0000000000000000
[ 9890.526102] #PF: supervisor read access in kernel mode
[ 9890.526105] #PF: error_code(0x0000) - not-present page
[ 9890.526109] PGD 0 P4D 0
[ 9890.526114] Oops: 0000 [#1] PREEMPT SMP PTI
[ 9890.526119] CPU: 2 PID: 6367 Comm: kworker/u16:2 Kdump: loaded Tainted: G           OE      6.9.0 #1
[ 9890.526123] Hardware name: LENOVO 2356AD1/2356AD1, BIOS G7ETB3WW (2.73 ) 11/28/2018
[ 9890.526126] Workqueue: phy2 rtw89_core_ba_work [rtw89_core]
[ 9890.526203] RIP: 0010:ieee80211_start_tx_ba_session (net/mac80211/agg-tx.c:618 (discriminator 1)) mac80211
[ 9890.526279] Code: f7 e8 d5 93 3e ea 48 83 c4 28 89 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc 49 8b 84 24 e0 f1 ff ff 48 8b 80 90 1b 00 00 <83> 38 03 0f 84 37 fe ff ff bb ea ff ff ff eb cc 49 8b 84 24 10 f3
All code
========
   0:	f7 e8                	imul   %eax
   2:	d5                   	(bad)
   3:	93                   	xchg   %eax,%ebx
   4:	3e ea                	ds (bad)
   6:	48 83 c4 28          	add    $0x28,%rsp
   a:	89 d8                	mov    %ebx,%eax
   c:	5b                   	pop    %rbx
   d:	41 5c                	pop    %r12
   f:	41 5d                	pop    %r13
  11:	41 5e                	pop    %r14
  13:	41 5f                	pop    %r15
  15:	5d                   	pop    %rbp
  16:	c3                   	retq
  17:	cc                   	int3
  18:	cc                   	int3
  19:	cc                   	int3
  1a:	cc                   	int3
  1b:	49 8b 84 24 e0 f1 ff 	mov    -0xe20(%r12),%rax
  22:	ff
  23:	48 8b 80 90 1b 00 00 	mov    0x1b90(%rax),%rax
  2a:*	83 38 03             	cmpl   $0x3,(%rax)		<-- trapping instruction
  2d:	0f 84 37 fe ff ff    	je     0xfffffffffffffe6a
  33:	bb ea ff ff ff       	mov    $0xffffffea,%ebx
  38:	eb cc                	jmp    0x6
  3a:	49                   	rex.WB
  3b:	8b                   	.byte 0x8b
  3c:	84 24 10             	test   %ah,(%rax,%rdx,1)
  3f:	f3                   	repz

Code starting with the faulting instruction
===========================================
   0:	83 38 03             	cmpl   $0x3,(%rax)
   3:	0f 84 37 fe ff ff    	je     0xfffffffffffffe40
   9:	bb ea ff ff ff       	mov    $0xffffffea,%ebx
   e:	eb cc                	jmp    0xffffffffffffffdc
  10:	49                   	rex.WB
  11:	8b                   	.byte 0x8b
  12:	84 24 10             	test   %ah,(%rax,%rdx,1)
  15:	f3                   	repz
[ 9890.526285] RSP: 0018:ffffb8db09013d68 EFLAGS: 00010246
[ 9890.526291] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff9308e0d656c8
[ 9890.526295] RDX: 0000000000000000 RSI: ffffffffab99460b RDI: ffffffffab9a7685
[ 9890.526300] RBP: ffffb8db09013db8 R08: 0000000000000000 R09: 0000000000000873
[ 9890.526304] R10: ffff9308e0d64800 R11: 0000000000000002 R12: ffff9308e5ff6e70
[ 9890.526308] R13: ffff930952500e20 R14: ffff9309192a8c00 R15: 0000000000000000
[ 9890.526313] FS:  0000000000000000(0000) GS:ffff930b4e700000(0000) knlGS:0000000000000000
[ 9890.526316] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 9890.526318] CR2: 0000000000000000 CR3: 0000000391c58005 CR4: 00000000001706f0
[ 9890.526321] Call Trace:
[ 9890.526324]  <TASK>
[ 9890.526327] ? show_regs (arch/x86/kernel/dumpstack.c:479)
[ 9890.526335] ? __die (arch/x86/kernel/dumpstack.c:421 arch/x86/kernel/dumpstack.c:434)
[ 9890.526340] ? page_fault_oops (arch/x86/mm/fault.c:713)
[ 9890.526347] ? search_module_extables (kernel/module/main.c:3256 (discriminator 3))
[ 9890.526353] ? ieee80211_start_tx_ba_session (net/mac80211/agg-tx.c:618 (discriminator 1)) mac80211

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Link: https://patch.msgid.link/20240617115217.22344-1-kevin_yang@realtek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/agg-tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 21d55dc539f6c..677bbbac9f169 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -616,7 +616,9 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 		return -EINVAL;
 
 	if (!pubsta->deflink.ht_cap.ht_supported &&
-	    sta->sdata->vif.bss_conf.chanreq.oper.chan->band != NL80211_BAND_6GHZ)
+	    !pubsta->deflink.vht_cap.vht_supported &&
+	    !pubsta->deflink.he_cap.has_he &&
+	    !pubsta->deflink.eht_cap.has_eht)
 		return -EINVAL;
 
 	if (WARN_ON_ONCE(!local->ops->ampdu_action))
-- 
2.43.0



