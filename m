Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50364CDDE8;
	Thu, 17 Sep 2026 15:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658759; cv=none; b=UuHE+7UR8GvUvwD1xevCp4FllnQmbHt3QFXvv/kSIhqCkLTy9JNXt+YchiQhuzLgN0Ch9TYTrom8nv1EMLJoZKkZ6RaCBclfiQdjWFCKRceTKPySEplIpSFec+4wZbJ/vx+vpbGH6dyzmROPN2g0Lxl765ESDx+iMS5r01VHU3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658759; c=relaxed/simple;
	bh=3wlAdOM72h4DPEMLj85jYI0MdQQk1oIs8zCx8qpv2fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8bwXF2uVm9LjyURQIXqvDaQpirc6ZLgdv2lHDAfLhcd1kjQ3q2y2ed/XR0/in+/li1d346LWiW0I8Ggcr0NTDY9GSQSHAV8WbIvLnw42Y7KE9lCwW4T3lYBnoz/EOVKwVWEcLepFvqZr9EcTKU+YYpW6kesIWCcnE7R94gx37E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNhIwzr3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNhIwzr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95C31F000FF;
	Thu, 17 Sep 2026 15:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658746;
	bh=X2H26vjSFYvq7oxl6e1350W+SkC/f9t1cteOEJ4f02U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gNhIwzr3SUpIV0MVoan/BAaHR5YdbUaXjbPlpLn1xaxCmi3cvfuyPbnOmbD4/ztMn
	 Yfi09U1ikFTy18ezC4/rYEtKy0xPHHxL1Br1caF+e0NGCBE9esElgtCH44kFTCw2he
	 CUTNxW3phHyRwJ/IQb8YsKF1kZ9UBhzo2+d5P2g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Leon Hwang <leon.hwang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 025/733] bpf: Fix percpu map update indexing with sparse CPU IDs
Date: Thu, 17 Sep 2026 16:05:33 +0100
Message-ID: <20260917151351.332328539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit 75b0a6db4300e4c2c9e97a0848deaa7acfb42fb7 ]

Per-CPU array, hash, and cgroup storage map updates without BPF_F_CPU
or BPF_F_ALL_CPUS use a value buffer whose per-CPU slots are packed in
possible-CPU order. The buffer is sized as:

  round_up(value_size, 8) * num_possible_cpus()

The update paths iterate over possible CPUs, but use the logical CPU ID
to calculate the source offset:

  value + size * cpu

This only works when possible CPU IDs are contiguous starting at zero.

For example, with a possible CPU mask of 0,2-3, the buffer contains
three slots corresponding to CPUs 0, 2, and 3. CPU2 is therefore
expected to use slot 1 and CPU3 slot 2. Instead, the current code uses
slots 2 and 3 respectively, causing incorrect per-CPU values and an
out-of-bounds read from the update buffer for CPU3.

The corresponding lookup paths already use a dense offset while
iterating over possible CPUs. Do the same for the array, hash, and
cgroup storage update paths, advancing the source offset once for each
possible CPU. BPF_F_ALL_CPUS continues to use the same value for every
CPU.

Fixes: 8eb76cb03f0f ("bpf: Add BPF_F_CPU and BPF_F_ALL_CPUS flags support for percpu_array maps")
Fixes: c6936161fd55 ("bpf: Add BPF_F_CPU and BPF_F_ALL_CPUS flags support for percpu_hash and lru_percpu_hash maps")
Fixes: 47c79f05aa0d ("bpf: Add BPF_F_CPU and BPF_F_ALL_CPUS flags support for percpu_cgroup_storage maps")
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/bpf/20260813155131.1022745-3-sh_def@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arraymap.c      | 5 +++--
 kernel/bpf/hashtab.c       | 5 +++--
 kernel/bpf/local_storage.c | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 248b4818178cd..cc3f8c25a28b5 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -405,7 +405,7 @@ int bpf_percpu_array_update(struct bpf_map *map, void *key, void *value,
 	void __percpu *pptr;
 	void *ptr, *val;
 	u32 size;
-	int cpu;
+	int cpu, off = 0;
 
 	if (unlikely((map_flags & BPF_F_LOCK) || (u32)map_flags > BPF_F_ALL_CPUS))
 		/* unknown flags */
@@ -437,9 +437,10 @@ int bpf_percpu_array_update(struct bpf_map *map, void *key, void *value,
 	}
 	for_each_possible_cpu(cpu) {
 		ptr = per_cpu_ptr(pptr, cpu);
-		val = (map_flags & BPF_F_ALL_CPUS) ? value : value + size * cpu;
+		val = (map_flags & BPF_F_ALL_CPUS) ? value : value + off;
 		copy_map_value(map, ptr, val);
 		bpf_obj_cancel_fields(map, ptr);
+		off += size;
 	}
 unlock:
 	rcu_read_unlock();
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 9f394e1aa2e85..dd4da18312ac1 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1026,7 +1026,7 @@ static void pcpu_copy_value(struct bpf_htab *htab, void __percpu *pptr,
 	} else {
 		u32 size = round_up(htab->map.value_size, 8);
 		void *val;
-		int cpu;
+		int cpu, off = 0;
 
 		if (map_flags & BPF_F_CPU) {
 			cpu = map_flags >> 32;
@@ -1038,9 +1038,10 @@ static void pcpu_copy_value(struct bpf_htab *htab, void __percpu *pptr,
 
 		for_each_possible_cpu(cpu) {
 			ptr = per_cpu_ptr(pptr, cpu);
-			val = (map_flags & BPF_F_ALL_CPUS) ? value : value + size * cpu;
+			val = (map_flags & BPF_F_ALL_CPUS) ? value : value + off;
 			copy_map_value(&htab->map, ptr, val);
 			bpf_obj_cancel_fields(&htab->map, ptr);
+			off += size;
 		}
 	}
 }
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 23267213a17fb..83cd527a2542b 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -220,7 +220,7 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *_map, void *key,
 	struct bpf_cgroup_storage *storage;
 	void *val;
 	u32 size;
-	int cpu;
+	int cpu, off = 0;
 
 	if ((u32)map_flags & ~(BPF_ANY | BPF_EXIST | BPF_F_CPU | BPF_F_ALL_CPUS))
 		return -EINVAL;
@@ -245,8 +245,9 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *_map, void *key,
 	}
 	size = round_up(_map->value_size, 8);
 	for_each_possible_cpu(cpu) {
-		val = (map_flags & BPF_F_ALL_CPUS) ? value : value + size * cpu;
+		val = (map_flags & BPF_F_ALL_CPUS) ? value : value + off;
 		copy_map_value(_map, per_cpu_ptr(storage->percpu_buf, cpu), val);
+		off += size;
 	}
 unlock:
 	rcu_read_unlock();
-- 
2.53.0



