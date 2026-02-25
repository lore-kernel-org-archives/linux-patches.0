Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BC813D51E;
	Wed, 25 Feb 2026 01:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983997; cv=none; b=K81PX6QOO/jdhLaCd6E3DZimCgnpmWCFbPy+tpmxCO12xi6m5ks1SEtycWvKbe4YOsMp6+BuqooSJoIVKXC69xEEVjNkWKyAiRStlLdmmYntv4GtOkiDv02X9aGyUEZAOkvU03GqNnweOcnSwGn+WXK7Msm/5kc9qcNXmaZ5fwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983997; c=relaxed/simple;
	bh=zwvB+AZjghFxvN8uspH4jrtFdu3RJaPzl0Ts7A4EQK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiwjWLsZJzGuuEkkrJ5pK0Bh/BEugBU3Aln/5Cvo3oF645MWvVtvf9+dpXBYTC9/8wk2OI4uD9LMCtCKUZI7UtHPmL93wQhJmOoVx77Ih2B5OmWsVMg5QqZexSzie61kK8BM0xsuqAFcJyIEs7l0jbT5Uv/L0SQZaJ6bYpQCjyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7Cnr3Ob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7Cnr3Ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914E8C116D0;
	Wed, 25 Feb 2026 01:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983997;
	bh=zwvB+AZjghFxvN8uspH4jrtFdu3RJaPzl0Ts7A4EQK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7Cnr3ObIjaWUkf2pXu/oFkOWAq0aK/MrNZCY23jAEYVm23fxbyAw+zDKIKn/KzYG
	 HpsIXDFNn4u0oWfZwLllUqK4mMihfKbUVhuIFc0IsCW8THgQ/1A0whEHRkGmz8IFHj
	 D6+PWE13B5p3byknXb8VyjpOGQ0dY3bVYZi/BnJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Bapat <abhishekbapat@google.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 251/641] quota: fix livelock between quotactl and freeze_super
Date: Tue, 24 Feb 2026 17:19:37 -0800
Message-ID: <20260225012354.929959023@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 7c2b75a444852..de4379a9c7920 100644
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



