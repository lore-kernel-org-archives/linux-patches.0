Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A771F2459C5;
	Tue, 29 Apr 2025 17:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949152; cv=none; b=BPDX3luvgKzaMVs4h2UInMxu2pHzNpOpHiqmDjaddG1Q1Ah1AyO3LGcC6YTuZij/TIphO57TMFbBLV6xONeawZZXVmPx9z09n2B5nRJAs8i4t2qCTJRvL8gZIaQU1U8zaVcHJFc/K5mSJdaZvsFA1i0oZTC56Z7BWZIgwUZBqBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949152; c=relaxed/simple;
	bh=2Bdrm9XwhJCvqcSFBZ651oKhFZq/wkmqa8XYPl96BbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFfk5H67r6/tFo9UbVR4P+47r1FqKkPxPw4V+rKDynx1kLmADX5qOp+dKHCnxoTLg7dWJCsBgnXZJxlujsoiYPcPUrYoBv3rzkzEO2AntkjHIYkZwUSZqUKIW78x0fw8KdDtYMuaGOZ8vbBwqZw5UGJ7/Kapx5D1O/fw0g4tDug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jv3xAmfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jv3xAmfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0EAC4CEE3;
	Tue, 29 Apr 2025 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949152;
	bh=2Bdrm9XwhJCvqcSFBZ651oKhFZq/wkmqa8XYPl96BbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jv3xAmfk6vMvErTKShXgqKS7PxOVKfMijqwIewEsN90+DpF37o2IhQ+TLir4lgC94
	 fTRKndkaDyWaER4FslDWUsKUYWxxt4nZdrvKOufnY/Ur8cv6va/U349z07G6wTWkdm
	 3YrbhcuLDMjNsUCy7nPgHdnvP2UEnBvuJQIr6cXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4dc041c686b7c816a71e@syzkaller.appspotmail.com,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	David Sauerwein <dssauerw@amazon.de>
Subject: [PATCH 5.15 230/373] bpf: avoid holding freeze_mutex during mmap operation
Date: Tue, 29 Apr 2025 18:41:47 +0200
Message-ID: <20250429161132.605370924@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

commit bc27c52eea189e8f7492d40739b7746d67b65beb upstream.

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
Signed-off-by: David Sauerwein <dssauerw@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/syscall.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -654,7 +654,7 @@ static const struct vm_operations_struct
 static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct bpf_map *map = filp->private_data;
-	int err;
+	int err = 0;
 
 	if (!map->ops->map_mmap || map_value_has_spin_lock(map) ||
 	    map_value_has_timer(map))
@@ -679,7 +679,12 @@ static int bpf_map_mmap(struct file *fil
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
@@ -690,13 +695,11 @@ static int bpf_map_mmap(struct file *fil
 		vma->vm_flags &= ~VM_MAYWRITE;
 
 	err = map->ops->map_mmap(map, vma);
-	if (err)
-		goto out;
+	if (err) {
+		if (vma->vm_flags & VM_WRITE)
+			bpf_map_write_active_dec(map);
+	}
 
-	if (vma->vm_flags & VM_MAYWRITE)
-		bpf_map_write_active_inc(map);
-out:
-	mutex_unlock(&map->freeze_mutex);
 	return err;
 }
 


