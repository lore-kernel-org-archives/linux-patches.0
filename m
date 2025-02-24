Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76832571CE;
	Mon, 24 Feb 2025 14:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408235; cv=none; b=tdad7hN4D1UYQw0vlxgh/tBcbyTdEe1vljsWGlmPifoj10RmUobdtInxho8Yr7mZeYqFKOC7X8O370TCZNeYWnrl4UKgxumvXiv/agdqYhXvYFUAHhXsLAJ1fEB9FFiAIg51ENnqEYgBpYu02iOmBpwTlV/i/opfZ4FI270/V/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408235; c=relaxed/simple;
	bh=9NWCUzu6nY2UraAUwuGpeXJ171j8EBfLR/42p0f46Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWUHKVuwGTW3RohYTvHM5iJLZ3cyvk5xGBYm6ZIl3m5E4tdGvODH4ZzAozl+4FaDeyKurTo5oKxS2+nlxQwxglPS5AcK6nMWvjR7+1O5pefLLlVih8tyvncZ+r1BbE7kO0HxNK0hITguNUCNnIDuwCQEd2MELDHlF+o7uFGS6dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVZRLr/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVZRLr/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD85EC4CEE6;
	Mon, 24 Feb 2025 14:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408233;
	bh=9NWCUzu6nY2UraAUwuGpeXJ171j8EBfLR/42p0f46Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVZRLr/D6Hnr8LMQDZ4ERtAilo+QCwVyFvajizCnNMhz/dk8QnPMHWaQgIkkpJTra
	 EKz6cEVZgaSa8Vt/xC9Ce/OB4uGBr84nHaaWUf3SI5Agfvg90m30dUGZoy/U+3uGzB
	 WCsCR7jV3UyDPiOcsNzAVlZUJJTTpdUtnpSerwfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4dc041c686b7c816a71e@syzkaller.appspotmail.com,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/140] bpf: avoid holding freeze_mutex during mmap operation
Date: Mon, 24 Feb 2025 15:34:55 +0100
Message-ID: <20250224142606.787290836@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit bc27c52eea189e8f7492d40739b7746d67b65beb ]

We use map->freeze_mutex to prevent races between map_freeze() and
memory mapping BPF map contents with writable permissions. The way we
naively do this means we'll hold freeze_mutex for entire duration of all
the mm and VMA manipulations, which is completely unnecessary. This can
potentially also lead to deadlocks, as reported by syzbot in [0].

So, instead, hold freeze_mutex only during writeability checks, bump
(proactively) "write active" count for the map, unlock the mutex and
proceed with mmap logic. And only if something went wrong during mmap
logic, then undo that "write active" counter increment.

  [0] https://lore.kernel.org/bpf/678dcbc9.050a0220.303755.0066.GAE@google.com/

Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
Reported-by: syzbot+4dc041c686b7c816a71e@syzkaller.appspotmail.com
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20250129012246.1515826-2-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 98d7558e2f2be..9f791b6b09edc 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -882,7 +882,7 @@ static const struct vm_operations_struct bpf_map_default_vmops = {
 static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct bpf_map *map = filp->private_data;
-	int err;
+	int err = 0;
 
 	if (!map->ops->map_mmap || !IS_ERR_OR_NULL(map->record))
 		return -ENOTSUPP;
@@ -906,7 +906,12 @@ static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
 			err = -EACCES;
 			goto out;
 		}
+		bpf_map_write_active_inc(map);
 	}
+out:
+	mutex_unlock(&map->freeze_mutex);
+	if (err)
+		return err;
 
 	/* set default open/close callbacks */
 	vma->vm_ops = &bpf_map_default_vmops;
@@ -923,13 +928,11 @@ static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
 		vm_flags_clear(vma, VM_MAYWRITE);
 
 	err = map->ops->map_mmap(map, vma);
-	if (err)
-		goto out;
+	if (err) {
+		if (vma->vm_flags & VM_WRITE)
+			bpf_map_write_active_dec(map);
+	}
 
-	if (vma->vm_flags & VM_WRITE)
-		bpf_map_write_active_inc(map);
-out:
-	mutex_unlock(&map->freeze_mutex);
 	return err;
 }
 
-- 
2.39.5



