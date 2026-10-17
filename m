Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3B63BCD20;
	Sat, 17 Oct 2026 16:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255361; cv=none; b=df6bhlXKxJjxi1zxenaQZJxp8gpYl+AZ7wZIixg8IYJEwe+Ya6fEA10yEUiv36Xo48nrro4UNx/36Ypsj6t1rzvIXolEeTB0WH2UcyAmiJ45eAgv95UTU21yDWoV2MUKTWr7Gu1ChiQ+W5SoD19rClYmvFFIFmHkw1I7sDRks2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255361; c=relaxed/simple;
	bh=KwNR6Fnes6kmkpPy3N2ZEcKvEwFt3cTQK+h9vbCm5EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbZS4sY+hePL5NgyIImELfAenttGWPVjDqICtppEMyFObxg5MAyUqTj+kiW979QQI1CTeYCp/TV0T1B1XlqrdtLKfSJ7wRPEnrQUeJS270ZcfUcdxQuNW8H9Tvy8R5pWCpO1QetDquRL9eCtDTJiu7z1DWdUG7yB75M5oaBkL1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/NHG7Ol; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/NHG7Ol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3461F000C4;
	Sat, 17 Oct 2026 16:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255360;
	bh=spj2PwywmGe/0YulW147wBHr3R4Td+EzetunWuhRi4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/NHG7OlV8Bp0EVdCa9X9fpF+JlOGEqdNdbgDwKZtNFsqwJ7orAnybj3Z593zmR1m
	 XAgDbQELO6PoK4v0sqcDKzNk0vV+FdYmqs4RdR3+Lbc2Bu3vN0LNt2kZxlQoAgR4Sp
	 xm//OuKxloW5cnszM9NaUvii16WHpfAUBZfxLkI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 707/869] bpf: Reject rdonly/rdwr_buf_size kfunc arguments that exceed u32 max
Date: Sat, 17 Oct 2026 17:59:08 +0200
Message-ID: <20261017160055.089506884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 03b6093327187..7c814248e842c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12347,6 +12347,11 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 				}
 
 				meta->r0_size = reg->var_off.value;
+				if (meta->r0_size > U32_MAX) {
+					verbose(env, "R%d rdonly/rdwr_buf_size exceeds u32 max\n",
+						regno);
+					return -EINVAL;
+				}
 				ret = mark_chain_precision(env, regno);
 				if (ret)
 					return ret;
-- 
2.53.0



