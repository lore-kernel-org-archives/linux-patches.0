Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3E435C19C;
	Tue, 16 Dec 2025 12:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886747; cv=none; b=rtUcxPgVnFegc4gg2G0DatT71SPpGO/so03FTZkvfvr5TxNs9Y1RKbVFpccdbKyehIDBHKighbPTQxZvj/k7EKg4QXGpClmhXojtwni2Llkqd0qf7w5LZCrrpAeagGC/0mBZM9DbhhIVJ861icYBGWoc5Sst1a1YPf6CrmwQX9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886747; c=relaxed/simple;
	bh=/D11Y70X7O9WuTE+2zL37CzZ3qltVdC4dLo6ILXO6Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feQGTNf2W+92Jf3sNpGxdz+BqYgTOkE9txr1RtaIGqgQ9reRaM9mEgKN5uj9kj67PKOzIKxz5rlZONPQbIqymRMkL+9UpRV4Tm8QEVtxDGywN+hLTyq7R3X50JaDEhXepPl9lYeYB0CUq0XCHhVsldEl8ZGUqY4FJ7BOCQ1nPqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0fYv7VM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0fYv7VM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B13C4CEF1;
	Tue, 16 Dec 2025 12:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886747;
	bh=/D11Y70X7O9WuTE+2zL37CzZ3qltVdC4dLo6ILXO6Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0fYv7VMmdI5DQTmmBA1Nlo+5uCZ54XNKpgDcLaxgpmkgJAVN7nNKdeLvN4HZxq2l
	 zC0zcAx/KOxpaXaRxIiq62PazJT1P5OpmHte0tScZEAW1eSFjXlO6obFjqophi9Q/Q
	 PfaoTRm26Gd4C9jC2IHwVrQgPTE0tqiXlnqIk05Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 020/614] bpf: Fix handling maps with no BTF and non-constant offsets for the bpf_wq
Date: Tue, 16 Dec 2025 12:06:27 +0100
Message-ID: <20251216111402.036883252@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit 5f8d41172931a92339c5cce81a3142065fa56e45 ]

Fix handling maps with no BTF and non-constant offsets for the bpf_wq.

This de-duplicates logic with other internal structs (task_work, timer),
keeps error reporting consistent, and makes future changes to the layout
handling centralized.

Fixes: d940c9b94d7e ("bpf: add support for KF_ARG_PTR_TO_WORKQUEUE")
Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20251010164606.147298-1-mykyta.yatsenko5@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 460107b0449fe..52c01c011c6fb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8479,6 +8479,9 @@ static int check_map_field_pointer(struct bpf_verifier_env *env, u32 regno,
 	case BPF_TASK_WORK:
 		field_off = map->record->task_work_off;
 		break;
+	case BPF_WORKQUEUE:
+		field_off = map->record->wq_off;
+		break;
 	default:
 		verifier_bug(env, "unsupported BTF field type: %s\n", struct_name);
 		return -EINVAL;
@@ -8520,13 +8523,17 @@ static int process_wq_func(struct bpf_verifier_env *env, int regno,
 {
 	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
 	struct bpf_map *map = reg->map_ptr;
-	u64 val = reg->var_off.value;
+	int err;
 
-	if (map->record->wq_off != val + reg->off) {
-		verbose(env, "off %lld doesn't point to 'struct bpf_wq' that is at %d\n",
-			val + reg->off, map->record->wq_off);
-		return -EINVAL;
+	err = check_map_field_pointer(env, regno, BPF_WORKQUEUE);
+	if (err)
+		return err;
+
+	if (meta->map.ptr) {
+		verifier_bug(env, "Two map pointers in a bpf_wq helper");
+		return -EFAULT;
 	}
+
 	meta->map.uid = reg->map_uid;
 	meta->map.ptr = map;
 	return 0;
-- 
2.51.0



