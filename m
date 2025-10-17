Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41250330B0D;
	Fri, 17 Oct 2025 15:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715284; cv=none; b=G64imBh8Z+8lpw+qChxMRxcm71jVVvRNdkCkq0WXGDJPaUb++xfduJftFEqXD6mJU+FGeXIKbMiBvHVYyjunLeegCMsS9Wg4U4BEJSeN4yb8t60QhhhNtuTBIvtfj9wkHFp1XmCIV9e+aDzPfXXnq24i+NWRm5/dYtOptxYd7js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715284; c=relaxed/simple;
	bh=iNWtDeNwNxqpfMITqTLlRKVobpLrb+vKgSY44xCj0Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBR5h+cZX2hgWyP3U86GYl76iqiezQtdxhOg6xe+zMY/U//8ngU5waHdtu2xi6vTwl1e7TVfEfuIQO4hC2z4ArsKXSvQxBxwphwZvkevAKXCBf9sVRUCxe37r5wCXGCvzwKibN4xpBFQZ08aRo73K6D49mdMLbGCVVfbqwiwNW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swSfT7FU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swSfT7FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF71C4CEE7;
	Fri, 17 Oct 2025 15:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715284;
	bh=iNWtDeNwNxqpfMITqTLlRKVobpLrb+vKgSY44xCj0Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swSfT7FU4wfde4d9iebIhrW6E6cGPJR90snqxJs/krZAxWW8/ytn0lNBtpk5c/eZj
	 NQKQumIlq+bqVzGBSjGvOzrLgjZTl0gX4q+9FdUzVk60KIBs/9r3d/GuRRaVkUrlVJ
	 4FCU8QlWC/y1IvXw0Oig7szMuCNRMAR61zg1rKDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Le Chen <tom2cat@sjtu.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	KaFai Wan <kafai.wan@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 129/371] bpf: Avoid RCU context warning when unpinning htab with internal structs
Date: Fri, 17 Oct 2025 16:51:44 +0200
Message-ID: <20251017145206.599214662@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KaFai Wan <kafai.wan@linux.dev>

[ Upstream commit 4f375ade6aa9f37fd72d7a78682f639772089eed ]

When unpinning a BPF hash table (htab or htab_lru) that contains internal
structures (timer, workqueue, or task_work) in its values, a BUG warning
is triggered:
 BUG: sleeping function called from invalid context at kernel/bpf/hashtab.c:244
 in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 14, name: ksoftirqd/0
 ...

The issue arises from the interaction between BPF object unpinning and
RCU callback mechanisms:
1. BPF object unpinning uses ->free_inode() which schedules cleanup via
   call_rcu(), deferring the actual freeing to an RCU callback that
   executes within the RCU_SOFTIRQ context.
2. During cleanup of hash tables containing internal structures,
   htab_map_free_internal_structs() is invoked, which includes
   cond_resched() or cond_resched_rcu() calls to yield the CPU during
   potentially long operations.

However, cond_resched() or cond_resched_rcu() cannot be safely called from
atomic RCU softirq context, leading to the BUG warning when attempting
to reschedule.

Fix this by changing from ->free_inode() to ->destroy_inode() and rename
bpf_free_inode() to bpf_destroy_inode() for BPF objects (prog, map, link).
This allows direct inode freeing without RCU callback scheduling,
avoiding the invalid context warning.

Reported-by: Le Chen <tom2cat@sjtu.edu.cn>
Closes: https://lore.kernel.org/all/1444123482.1827743.1750996347470.JavaMail.zimbra@sjtu.edu.cn/
Fixes: 68134668c17f ("bpf: Add map side support for bpf timers.")
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: KaFai Wan <kafai.wan@linux.dev>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20251008102628.808045-2-kafai.wan@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 5c2e96b19392a..1a31c87234877 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -775,7 +775,7 @@ static int bpf_show_options(struct seq_file *m, struct dentry *root)
 	return 0;
 }
 
-static void bpf_free_inode(struct inode *inode)
+static void bpf_destroy_inode(struct inode *inode)
 {
 	enum bpf_type type;
 
@@ -790,7 +790,7 @@ const struct super_operations bpf_super_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
 	.show_options	= bpf_show_options,
-	.free_inode	= bpf_free_inode,
+	.destroy_inode	= bpf_destroy_inode,
 };
 
 enum {
-- 
2.51.0



