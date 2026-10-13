Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ADD4E4C4C;
	Tue, 13 Oct 2026 12:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893685; cv=none; b=K8JLKeGDCEUasZ6LeXtvSp9bANjusHilfOAJJLNNzw0UkEL2xxpHoIxkxrGKyG0qnYtIYHBJPXhsdDodSA4KCcifNwwDFOAP1qHDWAQi2yWT7VkqjOnGuI2OitLt+55kCPyC4pXHyEME9//x/B55MQ1fDybjDqmBIaQMbaFTPIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893685; c=relaxed/simple;
	bh=fnL47PTfcerAvt7dSRKnmYOIHTckwmLuwq0YYnAVx4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfMw/mgeZfBJdPsh4LCFjYC8si/ouJJ9bZN+Xjwz/BS6OzNkMzZhL8r3kuzpkJaBsnGdD4pd3HLC0HMpKW7ECqNtJJB3WmaO8/bJ7Hqcc0cqmf+c4Q+rrbxqsW416tZM7SlUVjJqeuAr1uYkbWiqReE08/FRdyoIAGegIRQei4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vAOGLTu0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vAOGLTu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700DE1F000FF;
	Tue, 13 Oct 2026 12:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893684;
	bh=aqa25g6QiCNbx7sNQensEfOdpPoleinUf5ddmm0eO5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vAOGLTu0ORQLU+CdV9Rb2u7zA++/dIQLn4wf8A9WKZm3/VTH1c9bDcvovFA2JJJdz
	 fhi8bmmLrDKKypr/24Jqp5zqW+36Ql8er9YPZ/AW9p1aiCgetOgrRvRni7Z4ScbyUF
	 tpEqmzSdb+KC9d98uxJK/RwjSxb+Kn9rjzKvZcXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Windsor <dwindsor@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 309/621] bpf: Reject sleepable BPF_LSM_CGROUP programs at load time
Date: Tue, 13 Oct 2026 13:35:04 +0200
Message-ID: <20261013112928.187554311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 9247549b5a772..34ebabc01fa1e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -24479,8 +24479,10 @@ static bool can_be_sleepable(struct bpf_prog *prog)
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



