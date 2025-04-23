Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672BE20D4F8;
	Wed, 23 Apr 2025 15:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422349; cv=none; b=S8gra/4ntrTadtlAG95Qx4rHwuF8sW0OP8aHycALARKiM4wLH72LXT+xogOg19/32IAXXQ8e35yuKlnaxsqaxRYNi/yApjMZPMnh3rqc9VospIpc2Vb6XRkz17250j/ATlsUC5rpF0RHMMCdjfySNqYymz00mV4vsTcEp60II94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422349; c=relaxed/simple;
	bh=bUXVt2Zva48FdNH/LVn6l8bQ4SJPSkGXxXnkYoSLIJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbAd+ut/tU4wOZe9f8QJtbyn078xwv7UaX2W9JnRKTR4RGutDx6GmHGUq2mOEh7Knmiw424gefX7+x5obeCj+fbyFQFjUZa30lvLnRbCg85LQDnwcSM01wHQXXkVJ2EJoy2jhRZsGO9vLMdNjwQ/3XEs36EdRtjS8XrdwZ/8L6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1mCKXVxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1mCKXVxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF71C4CEE2;
	Wed, 23 Apr 2025 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422349;
	bh=bUXVt2Zva48FdNH/LVn6l8bQ4SJPSkGXxXnkYoSLIJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1mCKXVxu3a2Ka0RdjJEosULVBGG1mWhYjgxUA05D79CX6ha6XW5ZrP+uUgZDlcn3X
	 1essDO7+aXbbQszi0GPM2r0zMNXdlhy/FMYhrOyFulDwu79jlKgZGicTukuckcGWQa
	 XHoSc6QgwKpOYMMBvhBDPmNTDRkFDJJ8P0X1yyV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4dc041c686b7c816a71e@syzkaller.appspotmail.com,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	David Sauerwein <dssauerw@amazon.de>
Subject: [PATCH 6.1 281/291] bpf: avoid holding freeze_mutex during mmap operation
Date: Wed, 23 Apr 2025 16:44:30 +0200
Message-ID: <20250423142635.907894337@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -813,7 +813,7 @@ static const struct vm_operations_struct
 static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct bpf_map *map = filp->private_data;
-	int err;
+	int err = 0;
 
 	if (!map->ops->map_mmap || map_value_has_spin_lock(map) ||
 	    map_value_has_timer(map) || map_value_has_kptrs(map))
@@ -838,7 +838,12 @@ static int bpf_map_mmap(struct file *fil
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
@@ -849,13 +854,11 @@ static int bpf_map_mmap(struct file *fil
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
 


