Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CF621D3C2;
	Mon, 24 Feb 2025 14:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408501; cv=none; b=LCKPaLhp6M6TmVsjv275MzlTIvvyQnbARurgT0lwDjh7iK8bbdbxB92E0tUGPAFhmZaPzsECYRYTuOgJ4frbtNY0+rbKNwezYriLkZNnJ/S8HYyo6Vv7gamj3FXEYfO8abRF9/SBbjI6VViOIzNBXnPFLAm0+eQLCfGAMvHkYw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408501; c=relaxed/simple;
	bh=oEHT6q710WUfZ7UFABo0v+8wdnH0PDRaXaPSrO8F55c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/3SMoCWBglAiquEs8YIvYEOdQE+bDg1iQ5eygu+WwH34tbcH7OVynMAlkNUlH69vMFmwmbUUsuEsSWJukvkS9YwHOYI94JGCKpIeSr8B4BQ7PjzZu9bpYw3pHrlBFYkZVLaC4JrvqPKumxKS1q65d+ILClGcG5Bi+M3Dr2zkyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGIcuiIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGIcuiIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D56C4CED6;
	Mon, 24 Feb 2025 14:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408501;
	bh=oEHT6q710WUfZ7UFABo0v+8wdnH0PDRaXaPSrO8F55c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGIcuiIVqwWLxCsusrz2qkVROd1Feoj0bWJBtXhHC4zzEiflCFwBxAsMhURjMX6Uf
	 pMxHdA6lI3NBnKjP7HDvll0YxHCu+Vt/7AeOLyKxIFXTWPzLdwEZlbL5AAKEvhhQAu
	 cJyZ9C5qyY9UPRvJEra7LUCxSarzxQ9+Z0WlxgRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4dc041c686b7c816a71e@syzkaller.appspotmail.com,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/154] bpf: avoid holding freeze_mutex during mmap operation
Date: Mon, 24 Feb 2025 15:34:35 +0100
Message-ID: <20250224142610.059644117@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fa43f26ce0dac..3200372ea28ce 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -936,7 +936,7 @@ static const struct vm_operations_struct bpf_map_default_vmops = {
 static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct bpf_map *map = filp->private_data;
-	int err;
+	int err = 0;
 
 	if (!map->ops->map_mmap || !IS_ERR_OR_NULL(map->record))
 		return -ENOTSUPP;
@@ -960,7 +960,12 @@ static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
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
@@ -977,13 +982,11 @@ static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
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



