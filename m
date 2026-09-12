Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9B13290B0;
	Sat, 12 Sep 2026 10:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210513; cv=none; b=OCaUvalliAKZs8fxeNC+97LJGYI7scucLQP4z/7qd0XnX05DrueP6xwWBXmUxVh/7GyJrteEpaCxDXdIBhAgJbGPH0x6UqOkYh0fhWGxol7MQwYRjoe5JvusqeOoXn/7razvfkr88BJtvpAk2gEU9NxGgKbyw3IJ/Vc/NLLESNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210513; c=relaxed/simple;
	bh=Y6H/NomIq5jka47IVkDaghCzBal6pOjkfn8Jxocg1iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FczVuqT0T+zfwRdUC/9s+XSgsXR1OZWiTH2STpOKX69SPn93SONYbJjQqdCD2wx+8PhVRtIp0xkqqGcAal3uupXvbzA54WWSTvdfB88BNeUtEUS2h+6Yc1kzvgLp46J6jl9hfJv8EV9W3bOP2miHCw46DWuezfLFWFf/qAoZS1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNGWF1KF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNGWF1KF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10ED1F000FF;
	Sat, 12 Sep 2026 10:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210511;
	bh=+dW/JRtd4Z/qDcom6IdyqB0rOlkSiPeI+gHP28URbuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNGWF1KFmlrO5c3Q6qRyu0x1scJ5YKfsjye/lnuVQeb6JKnG8iNYR5U3TZdO05Ziq
	 4fV/cqTsO7TC0blddPeIzzn2/sP6aO25zYSBDEn6wPByWGuJZ07MibwDRS3Q11MtuG
	 UQArf7NmuYjZdm2/uNH+f4IAEkPeBP6oVkXTMK3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1040/1518] bpf: Factor out stack_map build ID helpers
Date: Sat, 12 Sep 2026 08:53:29 +0200
Message-ID: <20260912065646.977327991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Ihor Solodrai <ihor.solodrai@linux.dev>

[ Upstream commit fc99547a8bda22a6a489284641385d8dcfb3ecd8 ]

Factor out helpers from stack_map_get_build_id_offset() in
preparation for adding a sleepable build ID resolution path:
stack_map_build_id_set_ip(), stack_map_build_id_offset(), and
stack_map_build_id_set_valid().

While here, refactor stack_map_get_build_id_offset():
  * use continue-driven control flow in the main loop and remove
    build_id_valid label
  * update prev_vma and prev_build_id on the fall-back-to-IP branch so
    the cache reflects the actual VMA seen on the previous IP [1]
  * guard fetch_build_id() with vma_is_anonymous() [2] to skip parse
    attempts that would otherwise fail the ELF magic check

[1] https://lore.kernel.org/bpf/CAEf4Bzac9uWWqBvzH0iFzKvJcq3vxscZ3pKm0sUHmN-F-z9wVQ@mail.gmail.com/
[2] https://lore.kernel.org/bpf/226398c1ff3f2b686c0aeb010408d85fb15df13f9ff60a045bee31e79b9e41e9@mail.kernel.org/

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Mykyta Yatsenko <yatsenko@meta.com>
Link: https://lore.kernel.org/bpf/20260525223948.1920986-2-ihor.solodrai@linux.dev
Stable-dep-of: fa9dcacdcdf4 ("bpf: Fix mmap_lock leak in irq_work path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 57 ++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 17 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 49ef03ab0595a..2b647a2f176b4 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -152,6 +152,28 @@ static int fetch_build_id(struct vm_area_struct *vma, unsigned char *build_id, b
 			 : build_id_parse_nofault(vma, build_id, NULL);
 }
 
+static inline void stack_map_build_id_set_ip(struct bpf_stack_build_id *id)
+{
+	id->status = BPF_STACK_BUILD_ID_IP;
+	memset(id->build_id, 0, BUILD_ID_SIZE_MAX);
+}
+
+static inline u64 stack_map_build_id_offset(unsigned long vm_pgoff,
+					    unsigned long vm_start, u64 ip)
+{
+	return (vm_pgoff << PAGE_SHIFT) + ip - vm_start;
+}
+
+static inline void stack_map_build_id_set_valid(struct bpf_stack_build_id *id,
+						u64 offset,
+						const unsigned char *build_id)
+{
+	id->status = BPF_STACK_BUILD_ID_VALID;
+	id->offset = offset;
+	if (id->build_id != build_id)
+		memcpy(id->build_id, build_id, BUILD_ID_SIZE_MAX);
+}
+
 /*
  * Expects all id_offs[i].ip values to be set to correct initial IPs.
  * They will be subsequently:
@@ -165,44 +187,45 @@ static int fetch_build_id(struct vm_area_struct *vma, unsigned char *build_id, b
 static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
 					  u32 trace_nr, bool user, bool may_fault)
 {
-	int i;
 	struct mmap_unlock_irq_work *work = NULL;
 	bool irq_work_busy = bpf_mmap_unlock_get_irq_work(&work);
+	bool has_user_ctx = user && current && current->mm;
 	struct vm_area_struct *vma, *prev_vma = NULL;
-	const char *prev_build_id;
+	const unsigned char *prev_build_id = NULL;
+	int i;
 
 	/* If the irq_work is in use, fall back to report ips. Same
 	 * fallback is used for kernel stack (!user) on a stackmap with
 	 * build_id.
 	 */
-	if (!user || !current || !current->mm || irq_work_busy ||
-	    !mmap_read_trylock(current->mm)) {
+	if (!has_user_ctx || irq_work_busy || !mmap_read_trylock(current->mm)) {
 		/* cannot access current->mm, fall back to ips */
-		for (i = 0; i < trace_nr; i++) {
-			id_offs[i].status = BPF_STACK_BUILD_ID_IP;
-			memset(id_offs[i].build_id, 0, BUILD_ID_SIZE_MAX);
-		}
+		for (i = 0; i < trace_nr; i++)
+			stack_map_build_id_set_ip(&id_offs[i]);
 		return;
 	}
 
 	for (i = 0; i < trace_nr; i++) {
 		u64 ip = READ_ONCE(id_offs[i].ip);
+		u64 offset;
 
-		if (range_in_vma(prev_vma, ip, ip)) {
+		if (prev_build_id && range_in_vma(prev_vma, ip, ip)) {
 			vma = prev_vma;
-			memcpy(id_offs[i].build_id, prev_build_id, BUILD_ID_SIZE_MAX);
-			goto build_id_valid;
+			offset = stack_map_build_id_offset(vma->vm_pgoff, vma->vm_start, ip);
+			stack_map_build_id_set_valid(&id_offs[i], offset, prev_build_id);
+			continue;
 		}
 		vma = find_vma(current->mm, ip);
-		if (!vma || fetch_build_id(vma, id_offs[i].build_id, may_fault)) {
+		if (!vma || vma_is_anonymous(vma) ||
+		    fetch_build_id(vma, id_offs[i].build_id, may_fault)) {
 			/* per entry fall back to ips */
-			id_offs[i].status = BPF_STACK_BUILD_ID_IP;
-			memset(id_offs[i].build_id, 0, BUILD_ID_SIZE_MAX);
+			stack_map_build_id_set_ip(&id_offs[i]);
+			prev_vma = vma;
+			prev_build_id = NULL;
 			continue;
 		}
-build_id_valid:
-		id_offs[i].offset = (vma->vm_pgoff << PAGE_SHIFT) + ip - vma->vm_start;
-		id_offs[i].status = BPF_STACK_BUILD_ID_VALID;
+		offset = stack_map_build_id_offset(vma->vm_pgoff, vma->vm_start, ip);
+		stack_map_build_id_set_valid(&id_offs[i], offset, id_offs[i].build_id);
 		prev_vma = vma;
 		prev_build_id = id_offs[i].build_id;
 	}
-- 
2.53.0



