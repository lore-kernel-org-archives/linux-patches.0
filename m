Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EBB14012;
	Mon, 24 Feb 2025 14:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408960; cv=none; b=Uwsk7efPaF/awB/U5LR0rDJIfeiruBz/o1qkiDxmMTNNS72gLC3jJd58EoLpwgb1A68rZefPiPaBhiWkaItlLFhvst8GA4zUj7XkEQXUaOxtqmVLhUBmsfBoTRhIma3zVFXnS8JSLQfUb6dZ2dVSzCrfv2mg55WckCYXc6ZflRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408960; c=relaxed/simple;
	bh=eIgpw8ddSyRfQGIFiHzFB6RytL9OCHbCEveKiLquBEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzZQNxuShM21WNmtjgZxJxIeBUlnXIbRGGtYXX8IGPFhhFOInMblo+74TKtmxrmI8+BvmzqELTmfwQQ9CwkSNxAkT8qsgBDBbSHzQkKBCkKsrFGgtRr0EN4feWpg/RO2Ap3LlHl0eBW9ZzCFFtwTaDs7D9/fbRglE3HnLfJozfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6vOWzYw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6vOWzYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A6FC4CED6;
	Mon, 24 Feb 2025 14:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408960;
	bh=eIgpw8ddSyRfQGIFiHzFB6RytL9OCHbCEveKiLquBEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6vOWzYwbhnr5Cj40Tu1hWxChYmhi0XIb9In3FykpknIApfxmg02y8iAdvIWtX/gi
	 HffKyuSAz7OWE/eiwxHiw6ujnO7P8VDuZn6dh0sYKmMeHoo+53GqQUzuhngMHUqDJt
	 Br9P7RKuweDMj3TsSq2e14Z2c7To2i6sNCZTRTFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4dc041c686b7c816a71e@syzkaller.appspotmail.com,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 054/138] bpf: avoid holding freeze_mutex during mmap operation
Date: Mon, 24 Feb 2025 15:34:44 +0100
Message-ID: <20250224142606.603294057@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 60417b79639e5..f086fd8f263f1 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1031,7 +1031,7 @@ static const struct vm_operations_struct bpf_map_default_vmops = {
 static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct bpf_map *map = filp->private_data;
-	int err;
+	int err = 0;
 
 	if (!map->ops->map_mmap || !IS_ERR_OR_NULL(map->record))
 		return -ENOTSUPP;
@@ -1055,7 +1055,12 @@ static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
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
@@ -1072,13 +1077,11 @@ static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
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



