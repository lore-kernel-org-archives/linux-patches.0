Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF323955F4;
	Tue, 21 Jul 2026 15:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649319; cv=none; b=O/Ev0hyqDR9VGq0yVo17nMwVUFj115B80RD4wcwJ6AjaGEZbT/c+KDMKUIZ/gZjKRHOck9zL6ZOcWEc4XSGI4M+RdTJ2sDPr4xTf9t2xc2ko8jlU90lPm2jDeqOdeNvNT7ONgA3ckC8T/uPfRhfZnHHQxNFgCah27/O/M+QuXoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649319; c=relaxed/simple;
	bh=VM/1qsdL5SviYayWqAASCMX7ZVjXHyMhUxcoJldOisQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ww9i1OvPWJVLdzOinfYncbxO1ma4pMUv2iRXamept6wHWepbqcAz2hkifJEjzsUOnmc25j9QBJM0sYxfpRObXADvP210crp1g3fNbaFBdNH5E5iZP9EkxQ6oPTxcacX2TWIuidoFu7FcI/97KQ6rbjYbJmGUryH4F0ihzHg9Wbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvkyPaQd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvkyPaQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E311F000E9;
	Tue, 21 Jul 2026 15:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649318;
	bh=FXJ+QxTFJhRvpSSzlLJpXwC92Gm4F/oL/AWcKTUyqns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LvkyPaQdyIyiTXC5YxXGfnX1C1u+T/hPJajdzKCKho+5G/gGDa9UG7/0ItsyBS/C3
	 6Z1eXaqRidBiqA2/yCLQZ7H2pF8F8HiiOVJWMfsxFkz4yRRVPq1BVo2L5m3F8smlct
	 efRc6aPWmN/nDiHHezrIxNd2sDtv/TJ7kTNQBKHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Windsor <dwindsor@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0532/2077] bpf: Reject sleepable BPF_LSM_CGROUP programs at load time
Date: Tue, 21 Jul 2026 17:03:25 +0200
Message-ID: <20260721152605.352134764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 16da9f76804aad..c34bf4169d5c9c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -19545,8 +19545,10 @@ static bool can_be_sleepable(struct bpf_prog *prog)
 			return false;
 		}
 	}
-	return prog->type == BPF_PROG_TYPE_LSM ||
-	       prog->type == BPF_PROG_TYPE_KPROBE /* only for uprobes */ ||
+	if (prog->type == BPF_PROG_TYPE_LSM)
+		return prog->expected_attach_type != BPF_LSM_CGROUP;
+
+	return prog->type == BPF_PROG_TYPE_KPROBE /* only for uprobes */ ||
 	       prog->type == BPF_PROG_TYPE_STRUCT_OPS ||
 	       prog->type == BPF_PROG_TYPE_RAW_TRACEPOINT ||
 	       prog->type == BPF_PROG_TYPE_TRACEPOINT;
-- 
2.53.0



