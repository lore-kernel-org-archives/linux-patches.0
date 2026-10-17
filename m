Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2471419A4;
	Sat, 17 Oct 2026 16:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254621; cv=none; b=VJ/d3kYioGVwRlbcW28uITR8Lr0php94jnIqm5eKUORH4pgPMkZ9ipgI1EN3P6HB9SYXHG7zBues62bx7pzvMclW3pTZL5iSnC44DBR5g2DpUN9PsNvZl3XVONV8y+bTuk/eidZMUYkvrnPrLfn15N+ZSwHB/xPobVm4UGZhL/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254621; c=relaxed/simple;
	bh=ObnlzmFj9/ywBWAMPQvwaoO1Oqou3g3eY5xj/vkNsO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bU17DfVQLbBLyT0j88L8dOcB6Pyd1nJ9y0LFuoMPfu4p+0XwHdRhvJw9RxWer0He2W7b987x4bsKrjrw/acdeFOU78+6gnZMkhpgTaG+27mzdE426LT/yKyYvWTBLl4k0bnjd5g+Ye6kM9zB1EKpEREge6a9aavvvAJWP4K0ivc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TwLe7G6g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TwLe7G6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568561F000C4;
	Sat, 17 Oct 2026 16:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254619;
	bh=0n5i/2YSshwj/4drPXV+w7Sg0fCl0rebPAIU2Lfy7Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwLe7G6glzbNb0WR1Is+grpcMtIz6LKh5ZhE9cFB5gghgV0t2wKHVI3Wn4TqJTgiM
	 AtUJXXP2XY53N+Saic3CPRtQ3E0DZ3WzY3JfaoUnLHf7Hi7S9aa61ebGp7E7QM6MgC
	 UZlN5J3onq1QHJJxkJnzPdLX8fW+AyVB3Ry3zp2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Windsor <dwindsor@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 470/869] bpf: Reject sleepable BPF_LSM_CGROUP programs at load time
Date: Sat, 17 Oct 2026 17:55:11 +0200
Message-ID: <20261017160049.178428083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: David Windsor <dwindsor@gmail.com>

[ Upstream commit 5b038319be442c620f774e6fc9e9283deeca1c75 ]

The cgroup shim runs under rcu_read_lock_dont_migrate(), so we should
not attach any sleepable BPF programs there. Add support to the verifier
to explicitly reject attempts to load sleepable BPF programs destined
for LSM cgroup attachment.

Without this, we get the following splat from a BPF_LSM_CGROUP
program marked BPF_F_SLEEPABLE attached to file_open when it calls
bpf_get_dentry_xattr():

  BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1567
  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 34317, name: load
  preempt_count: 0, expected: 0
  RCU nest depth: 2, expected: 0
  Call Trace:
   down_read+0x76/0x480
   ext4_xattr_get+0x11f/0x700
   __vfs_getxattr+0xf0/0x150
   bpf_get_dentry_xattr+0xbb/0xf0
   bpf_prog_e76a298dac9218c6_test_open+0x6a/0x85
   __cgroup_bpf_run_lsm_current+0x326/0x840
   bpf_trampoline_6442534646+0x62/0x14d
   security_file_open+0x34/0x60
   do_dentry_open+0x340/0x1260
   vfs_open+0x7a/0x440
   path_openat+0x1bac/0x30a0

libbpf provides a .s named section variant for every sleepable
program type except lsm_cgroup, reflecting that per-cgroup LSM programs
are intended to only run in a non-sleepable context.

The above splat was obtained by bypassing libbpf by using bpf(2)
directly.

Fixes: 69fd337a975c ("bpf: per-cgroup lsm flavor")
Signed-off-by: David Windsor <dwindsor@gmail.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/bpf/20260605145707.608579-1-dwindsor@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5a1c8733f3222..03d5e7db3df76 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -22800,8 +22800,10 @@ static bool can_be_sleepable(struct bpf_prog *prog)
 			return false;
 		}
 	}
-	return prog->type == BPF_PROG_TYPE_LSM ||
-	       prog->type == BPF_PROG_TYPE_KPROBE /* only for uprobes */ ||
+	if (prog->type == BPF_PROG_TYPE_LSM)
+		return prog->expected_attach_type != BPF_LSM_CGROUP;
+
+	return prog->type == BPF_PROG_TYPE_KPROBE /* only for uprobes */ ||
 	       prog->type == BPF_PROG_TYPE_STRUCT_OPS;
 }
 
-- 
2.53.0



