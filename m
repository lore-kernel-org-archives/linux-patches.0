Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4F81917D7;
	Tue, 10 Sep 2024 10:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964044; cv=none; b=Yq8N0QxXOcd47bMgQZX4mVZd2w48ev6hH4NmgFJcT//M6zJ/mOxD2YDyF5EQxIuYslUO327Itac10yfOvohoIDsCP5V7Y5nBAGNy66PitNi86IfpnM8OgERphGRx+pRTrHPyGHDcgUSf7AWZCLnjRdoZZ6zcMyjA9RjLUHx+K40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964044; c=relaxed/simple;
	bh=tHbIM1d9C4i/28mvyrgykO8pkL/C3b7qhPNQAIkNSsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0TvEtqRrID5Neu4NWy8S3KrgnE8Ejo9+zSMXSOYRavu117K7AtgPj/fQeBLoxxrgLH2QcH1hCE2Zs+n9oi2c7nui+jVxX1EtwxnMjGDzItmDD7JFczc0FnjolZ2VkplQvxHYcjKq2TfS3yPzQVP3vVP5qU504HnzD2GGTnBdyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9yqKyj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9yqKyj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87942C4CEC3;
	Tue, 10 Sep 2024 10:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964043;
	bh=tHbIM1d9C4i/28mvyrgykO8pkL/C3b7qhPNQAIkNSsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9yqKyj0LcJQN9jWebXryjgk+cQ1smLN0oVh/1a/v3zON6OA3ppIZtkY2m1HBhTi4
	 0ymZXUMJd8ZAKJSZjb5RjJeXZUM0PSGnTifCW4zT+73NGqwxRc5sROLCj4R+2VKtuJ
	 iWctP1Bj66gv6JYOE9ITch3oIPLurQazBfpbr0sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Chi Zhiling <chizhiling@kylinos.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 048/269] eventfs: Use list_del_rcu() for SRCU protected list variable
Date: Tue, 10 Sep 2024 11:30:35 +0200
Message-ID: <20240910092609.960004408@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit d2603279c7d645bf0d11fa253b23f1ab48fc8d3c upstream.

Chi Zhiling reported:

  We found a null pointer accessing in tracefs[1], the reason is that the
  variable 'ei_child' is set to LIST_POISON1, that means the list was
  removed in eventfs_remove_rec. so when access the ei_child->is_freed, the
  panic triggered.

  by the way, the following script can reproduce this panic

  loop1 (){
      while true
      do
          echo "p:kp submit_bio" > /sys/kernel/debug/tracing/kprobe_events
          echo "" > /sys/kernel/debug/tracing/kprobe_events
      done
  }
  loop2 (){
      while true
      do
          tree /sys/kernel/debug/tracing/events/kprobes/
      done
  }
  loop1 &
  loop2

  [1]:
  [ 1147.959632][T17331] Unable to handle kernel paging request at virtual address dead000000000150
  [ 1147.968239][T17331] Mem abort info:
  [ 1147.971739][T17331]   ESR = 0x0000000096000004
  [ 1147.976172][T17331]   EC = 0x25: DABT (current EL), IL = 32 bits
  [ 1147.982171][T17331]   SET = 0, FnV = 0
  [ 1147.985906][T17331]   EA = 0, S1PTW = 0
  [ 1147.989734][T17331]   FSC = 0x04: level 0 translation fault
  [ 1147.995292][T17331] Data abort info:
  [ 1147.998858][T17331]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
  [ 1148.005023][T17331]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  [ 1148.010759][T17331]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
  [ 1148.016752][T17331] [dead000000000150] address between user and kernel address ranges
  [ 1148.024571][T17331] Internal error: Oops: 0000000096000004 [#1] SMP
  [ 1148.030825][T17331] Modules linked in: team_mode_loadbalance team nlmon act_gact cls_flower sch_ingress bonding tls macvlan dummy ib_core bridge stp llc veth amdgpu amdxcp mfd_core gpu_sched drm_exec drm_buddy radeon crct10dif_ce video drm_suballoc_helper ghash_ce drm_ttm_helper sha2_ce ttm sha256_arm64 i2c_algo_bit sha1_ce sbsa_gwdt cp210x drm_display_helper cec sr_mod cdrom drm_kms_helper binfmt_misc sg loop fuse drm dm_mod nfnetlink ip_tables autofs4 [last unloaded: tls]
  [ 1148.072808][T17331] CPU: 3 PID: 17331 Comm: ls Tainted: G        W         ------- ----  6.6.43 #2
  [ 1148.081751][T17331] Source Version: 21b3b386e948bedd29369af66f3e98ab01b1c650
  [ 1148.088783][T17331] Hardware name: Greatwall GW-001M1A-FTF/GW-001M1A-FTF, BIOS KunLun BIOS V4.0 07/16/2020
  [ 1148.098419][T17331] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  [ 1148.106060][T17331] pc : eventfs_iterate+0x2c0/0x398
  [ 1148.111017][T17331] lr : eventfs_iterate+0x2fc/0x398
  [ 1148.115969][T17331] sp : ffff80008d56bbd0
  [ 1148.119964][T17331] x29: ffff80008d56bbf0 x28: ffff001ff5be2600 x27: 0000000000000000
  [ 1148.127781][T17331] x26: ffff001ff52ca4e0 x25: 0000000000009977 x24: dead000000000100
  [ 1148.135598][T17331] x23: 0000000000000000 x22: 000000000000000b x21: ffff800082645f10
  [ 1148.143415][T17331] x20: ffff001fddf87c70 x19: ffff80008d56bc90 x18: 0000000000000000
  [ 1148.151231][T17331] x17: 0000000000000000 x16: 0000000000000000 x15: ffff001ff52ca4e0
  [ 1148.159048][T17331] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
  [ 1148.166864][T17331] x11: 0000000000000000 x10: 0000000000000000 x9 : ffff8000804391d0
  [ 1148.174680][T17331] x8 : 0000000180000000 x7 : 0000000000000018 x6 : 0000aaab04b92862
  [ 1148.182498][T17331] x5 : 0000aaab04b92862 x4 : 0000000080000000 x3 : 0000000000000068
  [ 1148.190314][T17331] x2 : 000000000000000f x1 : 0000000000007ea8 x0 : 0000000000000001
  [ 1148.198131][T17331] Call trace:
  [ 1148.201259][T17331]  eventfs_iterate+0x2c0/0x398
  [ 1148.205864][T17331]  iterate_dir+0x98/0x188
  [ 1148.210036][T17331]  __arm64_sys_getdents64+0x78/0x160
  [ 1148.215161][T17331]  invoke_syscall+0x78/0x108
  [ 1148.219593][T17331]  el0_svc_common.constprop.0+0x48/0xf0
  [ 1148.224977][T17331]  do_el0_svc+0x24/0x38
  [ 1148.228974][T17331]  el0_svc+0x40/0x168
  [ 1148.232798][T17331]  el0t_64_sync_handler+0x120/0x130
  [ 1148.237836][T17331]  el0t_64_sync+0x1a4/0x1a8
  [ 1148.242182][T17331] Code: 54ffff6c f9400676 910006d6 f9000676 (b9405300)
  [ 1148.248955][T17331] ---[ end trace 0000000000000000 ]---

The issue is that list_del() is used on an SRCU protected list variable
before the synchronization occurs. This can poison the list pointers while
there is a reader iterating the list.

This is simply fixed by using list_del_rcu() that is specifically made for
this purpose.

Link: https://lore.kernel.org/linux-trace-kernel/20240829085025.3600021-1-chizhiling@163.com/

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20240904131605.640d42b1@gandalf.local.home
Fixes: 43aa6f97c2d03 ("eventfs: Get rid of dentry pointers without refcounts")
Reported-by: Chi Zhiling <chizhiling@kylinos.cn>
Tested-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -935,7 +935,7 @@ static void eventfs_remove_rec(struct ev
 	list_for_each_entry(ei_child, &ei->children, list)
 		eventfs_remove_rec(ei_child, level + 1);
 
-	list_del(&ei->list);
+	list_del_rcu(&ei->list);
 	free_ei(ei);
 }
 


