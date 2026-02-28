Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3718338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301776; cv=none; b=Aju/c92ZFlgYzqQhF5in4j0vfu/sulaN7iatNGKdNwf3HHh44V0QAuxmGoEho6saSIcBAyeUnsM9vYYTjy4IrVETt30fInZaYSZnk6rzVK3yEedjMeq68On9tjX9R+fuDvWNNbW//4L6/GNKsj4+e6lQXQRHwNIdsvexAIAtn/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301776; c=relaxed/simple;
	bh=oWEKnfXX31THv7PulVjbObRYYgVGKOhnu6i4WkPzQlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpMjASYPAbXxtTEKC6j/HBaqv2J5ckuczsSolrScwjm7XdsahkBbkTUhUX+Awf3XlmfvBd4/rnqzB9acE7mcrWCTY+VORpTNwaUndcp5csulhrUdk1znw72hLeWA53DcKpAjGu4D6amsydLoW1W37YfoQf1gO9aR5acIFKj9llQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wcv3PtxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wcv3PtxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF74C19424;
	Sat, 28 Feb 2026 18:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301776;
	bh=oWEKnfXX31THv7PulVjbObRYYgVGKOhnu6i4WkPzQlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wcv3PtxBqfEJXboYBQ5V82vjJwSrOQgf/LoeGzxkgu0c++j487jpqGgmKuoVGqWZ+
	 Yj/DhkhE0gNrqak7WpNiv2OwtbueB/Qh/AOcqB2dWAOJ2W00zs2Gs9xV4M2XQoBiv7
	 PgCj7I3XUZ5XUbuJkRpDgDjQyvUXaaPbjXzwbrJdfDvCw/XEcMX2csEdwo1qUebTNs
	 oKTWxDr7NIuJnj7RHTKCWKtN57Eiz955R+aZzC5FbaRabhAL1CjzoSdgMwbdlBO2oO
	 GLo1janeBbDvtC536ZwGoF27DD3QhCPLTOzmUErlf3fYGXzb8Fh7+BEs+8oubgAoEz
	 CC/vQKrUUTvaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Abhishek Bapat <abhishekbapat@google.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 185/385] quota: fix livelock between quotactl and freeze_super
Date: Sat, 28 Feb 2026 12:56:47 -0500
Message-ID: <20260228180011.1568201-185-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Abhishek Bapat <abhishekbapat@google.com>

[ Upstream commit 77449e453dfc006ad738dec55374c4cbc056fd39 ]

When a filesystem is frozen, quotactl_block() enters a retry loop
waiting for the filesystem to thaw. It acquires s_umount, checks the
freeze state, drops s_umount and uses sb_start_write() - sb_end_write()
pair to wait for the unfreeze.

However, this retry loop can trigger a livelock issue, specifically on
kernels with preemption disabled.

The mechanism is as follows:
1. freeze_super() sets SB_FREEZE_WRITE and calls sb_wait_write().
2. sb_wait_write() calls percpu_down_write(), which initiates
   synchronize_rcu().
3. Simultaneously, quotactl_block() spins in its retry loop, immediately
   executing the sb_start_write() - sb_end_write() pair.
4. Because the kernel is non-preemptible and the loop contains no
   scheduling points, quotactl_block() never yields the CPU. This
   prevents that CPU from reaching an RCU quiescent state.
5. synchronize_rcu() in the freezer thread waits indefinitely for the
   quotactl_block() CPU to report a quiescent state.
6. quotactl_block() spins indefinitely waiting for the freezer to
   advance, which it cannot do as it is blocked on the RCU sync.

This results in a hang of the freezer process and 100% CPU usage by the
quota process.

While this can occur intermittently on multi-core systems, it is
reliably reproducing on a node with the following script, running both
the freezer and the quota toggle on the same CPU:

  # mkfs.ext4 -O quota /dev/sda 2g && mkdir a_mount
  # mount /dev/sda -o quota,usrquota,grpquota a_mount
  # taskset -c 3 bash -c "while true; do xfs_freeze -f a_mount; \
    xfs_freeze -u a_mount; done" &
  # taskset -c 3 bash -c "while true; do quotaon a_mount; \
    quotaoff a_mount; done" &

Adding cond_resched() to the retry loop fixes the issue. It acts as an
RCU quiescent state, allowing synchronize_rcu() in percpu_down_write()
to complete.

Fixes: 576215cffdef ("fs: Drop wait_unfrozen wait queue")
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Link: https://patch.msgid.link/20260115213103.1089129-1-abhishekbapat@google.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/quota.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 290157bc7bec2..04c6712d4031c 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -899,6 +899,7 @@ static struct super_block *quotactl_block(const char __user *special, int cmd)
 		sb_start_write(sb);
 		sb_end_write(sb);
 		put_super(sb);
+		cond_resched();
 		goto retry;
 	}
 	return sb;
-- 
2.51.0

