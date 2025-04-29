Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CCC21ABDB;
	Tue, 29 Apr 2025 17:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947179; cv=none; b=bDRDtvHMrxrpFblELuImlAMQcz9uqJwDoDsBnwrFvOmi5rrlpOvGL5AF/UImnU1DerdWBQRbCbysopvYS7kCwFE1HTV6bDECiqMfFDH8qqCCbFiEqnmgicMAa8pSqNcMNlUAjYAzsVJlMxzE8vSddKES77rLh87mI8EHD6t9kec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947179; c=relaxed/simple;
	bh=ToDGcpWW9rFrxz28jviBQbJbab/hZQ7SoB2srYysP0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qA2omwRsQzAyeNyzwEtd019ZWrB8S0DMXn+sBaNOPf+8/WUth+0PjaMxRFGIYL2bhQGxqEvHigfeCAfSvCNlyPiAvdKqQ4pMCyX+NClvI+SI34ayOEe3S3BaP322Mqzfl6VHXMVdC2LVb+fNgYisWaFqrLhyTwHjByGutdqbaZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ntaE9ox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ntaE9ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AA8C4CEE3;
	Tue, 29 Apr 2025 17:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947179;
	bh=ToDGcpWW9rFrxz28jviBQbJbab/hZQ7SoB2srYysP0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ntaE9oxWdwdUekOUT6v3BmYBYVHwv4gF4Bx9maGp3Vt048mi71BqASg4lqNCnPXo
	 0c0TKaodviHnLbvMn9z6mUjl0bxKpDSElDGzHjDBrXb59P/cC+5180RzIef82RW32p
	 f7VyZzAAC7MKxp/mUmRQy5Z3pJRKWiDtv2WTaHMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4dc041c686b7c816a71e@syzkaller.appspotmail.com,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	David Sauerwein <dssauerw@amazon.de>
Subject: [PATCH 5.10 168/286] bpf: avoid holding freeze_mutex during mmap operation
Date: Tue, 29 Apr 2025 18:41:12 +0200
Message-ID: <20250429161114.797114463@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -647,7 +647,7 @@ static const struct vm_operations_struct
 static int bpf_map_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct bpf_map *map = filp->private_data;
-	int err;
+	int err = 0;
 
 	if (!map->ops->map_mmap || map_value_has_spin_lock(map))
 		return -ENOTSUPP;
@@ -671,7 +671,12 @@ static int bpf_map_mmap(struct file *fil
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
@@ -682,13 +687,11 @@ static int bpf_map_mmap(struct file *fil
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
 


