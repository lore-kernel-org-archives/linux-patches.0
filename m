Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020993;
	b=dP+doyigqa+ZijKSzo08mII1vmUFkyjEWXyBcpf5JoaZG/2xXa8tzVGTgLGB73jMIL1w
	 lNHmcPDKfzTfDcq4kvaZgHPYxnyThAU0954+bsKMmud5Du3Pgnw+j+lz8iJxF8fIW7RuR
	 vaMHKpqD37jThjaGp1xHCe466nLLx7U41SCreaAPy3UwGTRYZpQYuUJxiAYCrsaSQ4nYk
	 TUMOaJuMpupjVAXRkt0Lp+560OX9qiWL7JCVbFVeHmenaQF8uibdLXXQ6Ecz4VcmcvDRY
	 P2kdttUT68iD6TDt9cQkIaH033du8aQSLxlREjDu0j3S3wWmNsrzhY3zkfSMNhrkE5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7/PjIQbg8W5VqFhr0EZqIT6QW5YkK4PPkoz63JxxiUs=;
	b=pylrvxWO1SGywgSfOOZQ21838/p3Elxncf0cyFX66/DERxOQT0iMkFsoh3wyRRDQjli3
	 /8qFp5w8eC0hu9MK1sqQyiDbOzpjUU7RSmFpQF20/vRPoDMkGjotcxoSnL+ghmgnxXmD/
	 0rig9Fx/1acmvfbZ9qL7o3Lu4HKIp8xDesVxfUbGOzsm8XryUIn+SsYifc1xbnN7sWEG7
	 5itqTgxNNsqW7Zk2D2lor9KbVByHNwteIlcVjRcCfS8geTOBKktlZVN/gzQXec1WFfeap
	 3K4VBwpUKsWKH//AiRUOnn5xzPBPqNT1yfuwtPjA7sOVBehyg/wSao0kSgrk4JqBqig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dN4GOtJ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481A9606A31C;
	Wed, 18 Nov 2026 16:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dN4GOtJ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAF71F000C4;
	Wed, 18 Nov 2026 16:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020993;
	bh=7/PjIQbg8W5VqFhr0EZqIT6QW5YkK4PPkoz63JxxiUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dN4GOtJ3iDxQFSe5spscfYZTma8TOqZoIgNQIh1vbFYkfsZZEs4vZr+cVN2G2n/E6
	 R74OPlNsYjgBQXlwyP02BAFSiv7JZLlnSNnWHIgvRtXrMqtI3D/S37CHkEWPgEmp95
	 1aOSP/CmrAMGrHUdAPiuhWnTHer2xihVm59CbqaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masoud Aghasi <maghasi@disroot.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Leon Hwang <leon.hwang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2150/2651] bpf: Fix incorrect handling of user flags in bpf_percpu_array_update
Date: Wed, 18 Nov 2026 15:56:30 +0100
Message-ID: <20261118150403.235255219@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masoud Aghasi <maghasi@disroot.org>

[ Upstream commit a898ff0f3e9968b5f7c248d2af3cf1ddaf239e51 ]

For BPF_MAP_TYPE_PERCPU_ARRAY map, bpf_percpu_array_update()
is not considering the possibility of a combination of
(BPF_NOEXIST, BPF_EXIST) flags with (BPF_F_CPU, BPF_F_ALL_CPUS) flags.
This causes the (BPF_NOEXIST, BPF_EXIST) flags to lose their effect
in some cases.

For example, using the (BPF_F_ALL_CPUS | BPF_EXIST) flag combination
with bpf_map_update_elem() results in an incorrect EINVAL error
response, even though the flag combination is valid.

This patch fixes the bug by adding proper flag validations and checks.
Before this patch, bpf_percpu_array_update() rejected
BPF_F_ALL_CPUS | BPF_EXIST and BPF_F_ALL_CPUS | BPF_NOEXIST with
-EINVAL. Also the BPF_F_CPU | BPF_NOEXIST were accepted.
After the patch BPF_F_ALL_CPUS | BPF_EXIST is accepted and
BPF_F_ALL_CPUS | BPF_NOEXIST and BPF_F_CPU | BPF_NOEXIST
result in -EEXIST.

This patch also starts returning -EINVAL for (BPF_EXIST | BPF_NOEXIST),
with or without BPF_F_CPU, which was previously accepted.

Fixes: 8eb76cb03f0f ("bpf: Add BPF_F_CPU and BPF_F_ALL_CPUS flags support for percpu_array maps")
Signed-off-by: Masoud Aghasi <maghasi@disroot.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://patch.msgid.link/20261008120734.1565972-2-maghasi@disroot.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h   | 3 +++
 kernel/bpf/arraymap.c | 6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b052efd4a0591..a628f182bb64c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -4256,6 +4256,9 @@ static inline bool bpf_map_is_percpu_map(enum bpf_map_type map_type)
 	}
 }
 
+#define BPF_EXIST_FLAGS		(BPF_EXIST | BPF_NOEXIST)
+#define BPF_CPU_FLAGS		(BPF_F_CPU | BPF_F_ALL_CPUS)
+
 static inline int bpf_map_check_op_flags(struct bpf_map *map, u64 flags, u64 allowed_flags)
 {
 	u32 cpu;
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 0fe9afd4a591e..133f189bf6d27 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -438,15 +438,15 @@ int bpf_percpu_array_update(struct bpf_map *map, void *key, void *value,
 	u32 size;
 	int cpu, off = 0;
 
-	if (unlikely((map_flags & BPF_F_LOCK) || (u32)map_flags > BPF_F_ALL_CPUS))
-		/* unknown flags */
+	if (unlikely(((map_flags & BPF_EXIST_FLAGS) == BPF_EXIST_FLAGS) ||
+		     ((u32)map_flags & ~(BPF_EXIST_FLAGS | BPF_CPU_FLAGS))))
 		return -EINVAL;
 
 	if (unlikely(index >= array->map.max_entries))
 		/* all elements were pre-allocated, cannot insert a new one */
 		return -E2BIG;
 
-	if (unlikely(map_flags == BPF_NOEXIST))
+	if (unlikely(map_flags & BPF_NOEXIST))
 		/* all elements already exist */
 		return -EEXIST;
 
-- 
2.53.0



