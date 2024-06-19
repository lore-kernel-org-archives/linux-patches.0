Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6866E147C60;
	Wed, 19 Jun 2024 13:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802013; cv=none; b=kZji/PXkfLsDrjDvq6GzWi4pXjTOI7ofKloD6N0pZiKB9ukfrXqhFXVdULfWBm4b+e7fG+GfBcAwCK6PiMTQCf8JqnpwCtiPCGkrppHF7/60zoPig4foG5z91i3BHHug8k03TO20c656c4HXVphL6KFRLR8Mn8ZrDH/UqsF2M5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802013; c=relaxed/simple;
	bh=eNOAKkUYvQ7hSg1v4BGMvwQItebbpz0+1vRUyUOadxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMpPp8J4a2y+F9RbgZO82ikmoKMHlf4Q1EZsDM3LNRupnKfY1ARjSeRP7BbGGuV9OHrV/GUfVBt/LqVUxARwMWt9HzuSvG1g9wma+Kd/FOCMKOF/ZL+t9EVgrfKVjw7K9Dbj/qGFoFk1b9+gky2MK5ynhiojRffbrmJZlNawSt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKySTF9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKySTF9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6EBC32786;
	Wed, 19 Jun 2024 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802013;
	bh=eNOAKkUYvQ7hSg1v4BGMvwQItebbpz0+1vRUyUOadxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZKySTF9syDmXs/GJatthYWTEBjWkI89Xj9C1uFxS3T77DN0bMNksPkpwmDi82cGpM
	 wJuI+XBpgo2F/bkztvefT+Lcn1r/RiQZoeQhSAWZOWrep16kwtSTqUNDtssEnXZhg+
	 GvoLdpsW3IjevA2jl8x4Y+LBbl37l9B97k3IAPZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/267] bpf: Store ref_ctr_offsets values in bpf_uprobe array
Date: Wed, 19 Jun 2024 14:52:52 +0200
Message-ID: <20240619125607.170347989@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 4930b7f53a298533bc31d7540b6ea8b79a000331 ]

We will need to return ref_ctr_offsets values through link_info
interface in following change, so we need to keep them around.

Storing ref_ctr_offsets values directly into bpf_uprobe array.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/bpf/20231125193130.834322-3-jolsa@kernel.org
Stable-dep-of: 2884dc7d08d9 ("bpf: Fix a potential use-after-free in bpf_link_free()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 1e79084a9d9d2..8edbafe0d4cdf 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3030,6 +3030,7 @@ struct bpf_uprobe_multi_link;
 struct bpf_uprobe {
 	struct bpf_uprobe_multi_link *link;
 	loff_t offset;
+	unsigned long ref_ctr_offset;
 	u64 cookie;
 	struct uprobe_consumer consumer;
 };
@@ -3169,7 +3170,6 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 {
 	struct bpf_uprobe_multi_link *link = NULL;
 	unsigned long __user *uref_ctr_offsets;
-	unsigned long *ref_ctr_offsets = NULL;
 	struct bpf_link_primer link_primer;
 	struct bpf_uprobe *uprobes = NULL;
 	struct task_struct *task = NULL;
@@ -3244,18 +3244,12 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (!uprobes || !link)
 		goto error_free;
 
-	if (uref_ctr_offsets) {
-		ref_ctr_offsets = kvcalloc(cnt, sizeof(*ref_ctr_offsets), GFP_KERNEL);
-		if (!ref_ctr_offsets)
-			goto error_free;
-	}
-
 	for (i = 0; i < cnt; i++) {
 		if (ucookies && __get_user(uprobes[i].cookie, ucookies + i)) {
 			err = -EFAULT;
 			goto error_free;
 		}
-		if (uref_ctr_offsets && __get_user(ref_ctr_offsets[i], uref_ctr_offsets + i)) {
+		if (uref_ctr_offsets && __get_user(uprobes[i].ref_ctr_offset, uref_ctr_offsets + i)) {
 			err = -EFAULT;
 			goto error_free;
 		}
@@ -3286,7 +3280,7 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	for (i = 0; i < cnt; i++) {
 		err = uprobe_register_refctr(d_real_inode(link->path.dentry),
 					     uprobes[i].offset,
-					     ref_ctr_offsets ? ref_ctr_offsets[i] : 0,
+					     uprobes[i].ref_ctr_offset,
 					     &uprobes[i].consumer);
 		if (err) {
 			bpf_uprobe_unregister(&path, uprobes, i);
@@ -3298,11 +3292,9 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (err)
 		goto error_free;
 
-	kvfree(ref_ctr_offsets);
 	return bpf_link_settle(&link_primer);
 
 error_free:
-	kvfree(ref_ctr_offsets);
 	kvfree(uprobes);
 	kfree(link);
 	if (task)
-- 
2.43.0



