Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF872AD35;
	Sat, 12 Sep 2026 07:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198104; cv=none; b=g24jsQCfDaetM9RkWBgTP75byjvgCsZikpl+hED6ps2TL7qqCgPq2qg8nQorK2Q3TQHjxP8GqmhRynQxDrAhRDQmCdn40N5/i2otg5OkY7DMWslNq1NXVFRlLXHGAp3h8XttRzVJ623/pFLtu34hbKTksk6cQKdb1OLAII3mI7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198104; c=relaxed/simple;
	bh=0Ursj7RikVxPHwnqUUVw2efuT6wntLh0/kYLN4ak4t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELpypH9MZQrxf4HGrFQd0MFXFkFsbrWLD1B+tOz8jDOG9bdG+hbmUCXFUt7vabIrrDGw6OAJjrtlvQlUvdRGFk7jw/RRKt7UIwAeZkl1NcbDZWpTIebp3OjpGEIWjOjuh+fbIA+iZClkEtz8OIMp3dZ1K6I/KSbToKcuNq5T408=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=faeoTSGX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faeoTSGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247551F000FF;
	Sat, 12 Sep 2026 07:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198101;
	bh=pubVIx0xzZaHCKB17B6PIrKF/qVgHdzPHkNB/DXZZ3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=faeoTSGXwDTkIVtqB8oIrdZ+MD+alVgDOoG6TFosEKBDZrW6DACl6sZEdBhKtquqj
	 t4jymDZ6wEPj1SxdDUOmRDqtUXVMeNqO+qSPixmu7eOwtol86PhZCBx1jddb1KUeyX
	 sHdSiTKw1NB7VgN2pGSZ6rIWtlGvCrVhCWsO9nnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0310/1815] bpf: Reject rdonly/rdwr_buf_size kfunc arguments that exceed u32 max
Date: Sat, 12 Sep 2026 08:34:20 +0200
Message-ID: <20260912065656.223330043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Nicholas Dudar <main.kalliope@gmail.com>

[ Upstream commit 2aaf67f0516fde29620d0edfc29c01b9ea7ad430 ]

check_kfunc_args() detects a kfunc argument named rdonly_buf_size or
rdwr_buf_size and stores reg->var_off.value into meta->r0_size, a u64,
and does not bound it. check_kfunc_call() later copies that value into
the returned register's mem_size field:

  meta->r0_size = reg->var_off.value;
  ...
  regs[BPF_REG_0].mem_size = meta.r0_size;

regs[BPF_REG_0].mem_size is u32. A constant whose upper 32 bits are set
gets truncated instead of causing a load-time rejection, so the verifier
records a PTR_TO_MEM register with an approximately 4 GiB mem_size for
whatever allocation the kfunc returned. A later access check against
that register uses the truncated, wrong bound.

Reject rdonly_buf_size/rdwr_buf_size values that exceed U32_MAX at the
point meta->r0_size is set.

Fixes: eb1f7f71c126 ("bpf/verifier: allow kfunc to return an allocated mem")
Signed-off-by: Nicholas Dudar <main.kalliope@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20260709155837.1879230-2-main.kalliope@gmail.com
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a3b66adbc83c7..2cfe54d848b6a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12049,6 +12049,11 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 				}
 
 				meta->r0_size = reg->var_off.value;
+				if (meta->r0_size > U32_MAX) {
+					verbose(env, "%s rdonly/rdwr_buf_size exceeds u32 max\n",
+						reg_arg_name(env, argno));
+					return -EINVAL;
+				}
 				if (regno >= 0)
 					ret = mark_chain_precision(env, regno);
 				else
-- 
2.53.0



