Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC264E4331;
	Thu, 17 Sep 2026 15:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658759; cv=none; b=jrz7y3bRDkNYzuoM8r2sMj+gjj0fpRNFlbti6u+WjdBon3hJWWfyQ9OxnfLcpjLl8yD6iwV2s3M+7ANt+wxnuk4HEPhWD36kLBV0LjTRg4fs1ANayPVYUSnG8j2GCpuUFl+APIF1y6/jAGf01D8WUkVX2IqkcxZhJjnPGjytDq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658759; c=relaxed/simple;
	bh=3rW+l7Z/rLV16lESbtLciVP6QVPfddU5BhQ89hZq+ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpeJ1wDuVJI15EdfdE9MhDHrNpRiwDIh2CIDWxmgo9nwCPiVl3dXgBGSram8R4y9K0gCqXNxLkVZfA317LlwvIQlzus9RR06z6OLS9ujcmoN26OABZNVF0wuTUU9Sxowch9MwOVL/JdaPiplFi8lSwkFmHAyBri7piRXpEUGVec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0x0MJlP4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0x0MJlP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59861F00893;
	Thu, 17 Sep 2026 15:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658743;
	bh=1nTxlg4u8QCSiOscEg5iCak+mijaWRK/oHYq+8OYyTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0x0MJlP4a86d9fMbyf40pAQUurdY2O5Jv1KxsvzoolNvPhB1WrAJvGK1z00zsl9Vp
	 /v2nWm5AFr3DpWkqTeYzml6DdQqouqAzKJ3oiVZ5qZGgmqORA+GEyWueqxbATL5PUD
	 G41xzDvX9n8l/321GeaS2MIYYWISL5+4mw/qRGSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Leon Hwang <leon.hwang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 024/733] bpf: Fix BPF_F_CPU validation for sparse CPU IDs
Date: Thu, 17 Sep 2026 16:05:32 +0100
Message-ID: <20260917151351.305608311@linuxfoundation.org>
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

[ Upstream commit ed54bf564ac52699cf4def3d0c2125d493e756f9 ]

BPF_F_CPU stores the target CPU ID in the upper 32 bits of the map
operation flags. bpf_map_check_op_flags() currently compares that ID
with num_possible_cpus(), which is the number of possible CPUs rather
than a bound on CPU IDs.

On an arm64 QEMU guest with a CPU device-tree hole, the possible CPU
mask was 0,2-3. A userspace program using raw bpf() syscalls creates
a BPF_MAP_TYPE_PERCPU_ARRAY and performs update and lookup operations
for each CPU by setting BPF_F_CPU and the CPU ID in the flags.

With the old check, CPU 1 is incorrectly accepted while valid CPU 3 is
rejected with -ERANGE. The CPU 1 update then reaches the per-CPU map
access path and triggers:

  Unable to handle kernel paging request at virtual address ...
  pc : __pi_memcpy_generic+0x5c/0x22c
  lr : bpf_percpu_array_update+0x2dc/0x2e8
  Call trace:
    __pi_memcpy_generic
    bpf_map_update_value
    map_update_elem
    __sys_bpf

Check the CPU ID against nr_cpu_ids and cpu_possible() instead. This
rejects CPU IDs outside the valid range and CPUs absent from the
possible mask, while allowing valid sparse CPU IDs.

Fixes: 2b421662c788 ("bpf: Introduce BPF_F_CPU and BPF_F_ALL_CPUS flags")
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/bpf/20260813160858.1042834-3-sh_def@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 77e2075f77c73..7798abc7d637b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -4184,7 +4184,7 @@ static inline int bpf_map_check_op_flags(struct bpf_map *map, u64 flags, u64 all
 			return -EINVAL;
 
 		cpu = flags >> 32;
-		if ((flags & BPF_F_CPU) && cpu >= num_possible_cpus())
+		if ((flags & BPF_F_CPU) && (cpu >= nr_cpu_ids || !cpu_possible(cpu)))
 			return -ERANGE;
 	}
 
-- 
2.53.0



