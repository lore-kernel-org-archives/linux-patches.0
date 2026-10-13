Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0175147604A;
	Tue, 13 Oct 2026 12:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894229; cv=none; b=bbIZfurY2l7OhXrOhmvfexsZKTmR3PLTbGa3ELTzu3b3MwVowN/20f890QUMxloWZE2xH5a6FGIY9G08M8dtEud7i1lVr3yw7xNKxNT7U2XagzCffEB4LkMN0JXlz0CwdEmp81fiScneEbNJpd0OavgVnw7915l0n2Abea9htc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894229; c=relaxed/simple;
	bh=QCbrdXyG360YF1XQhK09+fkGfHbHRorjlgIzE6jZVL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stoyut3ZuIsN6xYlRBGPTedQIgZgtyf1BlVJ1fmRp55SHXuygUn4q+llixv2ajW1fkTl7LASXbihbC+K75bN6TcOR2FmDUcDVwdPLv7VKsd57z/5AGP5QS8mYMQpYwtWTlsFXU4O1o6f7kIJBOHWdZw3/lY37tl7G/FmG9yRwf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixOGC9u1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixOGC9u1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7161F000FF;
	Tue, 13 Oct 2026 12:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894227;
	bh=Zk3MmelrZG3DuKt3hxGScoXoQAuUAE9OD1pkEsX3Cl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ixOGC9u1/YazM7uPdkZMJ1YwbuXpj4nTMWtGIBMhuHqxZa8518b6iFRLvMf0oki5i
	 F8W9UpI7FFd+XmceyYJ5oRSVgPqZTjofhd4xFW+knIkk8r2HCXHwqVqpxFzZAsOswx
	 ylNa5cSWisjLyy/SvyDqnIhie+ygwDyVfOpxdRX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 483/621] bpf: Reject rdonly/rdwr_buf_size kfunc arguments that exceed u32 max
Date: Tue, 13 Oct 2026 13:37:58 +0200
Message-ID: <20261013112932.294853152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index c1e46c0cce981..47549e988f2c7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13410,6 +13410,11 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
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



