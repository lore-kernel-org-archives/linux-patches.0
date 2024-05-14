Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECDD12FF64;
	Tue, 14 May 2024 11:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684447; cv=none; b=gFz7XuwAlOZQa4KUObaC0A9aByx9/4D+FV27ovNwvUB/4VUwntLGJgNNeOPLyrIpTgui4/1K1NZHKQsEhbGVKK8DtskJ9PvTO0D0QkTW04daZbvIZS+4tYhBNfmRl7ElQbrHEDGrrry1gZTKdx/jrn3WKj9OD+yMU5h2py3ZHsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684447; c=relaxed/simple;
	bh=rFP4LPyA9aX4LekMg/kBQwWZ+AVmqWT4LgfUjg2iJU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tsw+p5e/nsf4zLdMlLzsWv95xBCxj9gaBH/KOiR9Xdttm508pEmE3arjhsReiR2Rj6mYiWwMu8W0iReNGhRMeRoT4I7MXPPpEDUEHPh9vLWFVEm/G3VNaxcwINziu2l8G2rUPZwUx+y1tvmM3+QF9U6VtZnGwrtErXfg0IDHSXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3JwKeMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3JwKeMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3DBC2BD10;
	Tue, 14 May 2024 11:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684447;
	bh=rFP4LPyA9aX4LekMg/kBQwWZ+AVmqWT4LgfUjg2iJU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3JwKeMYuCWMfQOZHZAQWolpSWaM8TRNveisHFqbssQzY7mp+a0++WUuRU5oghlUZ
	 7l5XyY3SIykFjJSVDjlJZ6qyUMb/B3kFI9TVZqbJ+Iw4HgdVY6WdtSZ/It156cXgtF
	 Rp4YYXSqLdW+7AfgSKI3slC+NkliB704LHsTBV7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Pu Lehui <pulehui@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/301] riscv, bpf: Fix incorrect runtime stats
Date: Tue, 14 May 2024 12:15:14 +0200
Message-ID: <20240514101033.871835415@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 10541b374aa05c8118cc6a529a615882e53f261b ]

When __bpf_prog_enter() returns zero, the s1 register is not set to zero,
resulting in incorrect runtime stats. Fix it by setting s1 immediately upon
the return of __bpf_prog_enter().

Fixes: 49b5e77ae3e2 ("riscv, bpf: Add bpf trampoline support for RV64")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/bpf/20240416064208.2919073-3-xukuohai@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 8581693e62d39..b3990874e4818 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -740,6 +740,9 @@ static int invoke_bpf_prog(struct bpf_tramp_link *l, int args_off, int retval_of
 	if (ret)
 		return ret;
 
+	/* store prog start time */
+	emit_mv(RV_REG_S1, RV_REG_A0, ctx);
+
 	/* if (__bpf_prog_enter(prog) == 0)
 	 *	goto skip_exec_of_prog;
 	 */
@@ -747,9 +750,6 @@ static int invoke_bpf_prog(struct bpf_tramp_link *l, int args_off, int retval_of
 	/* nop reserved for conditional jump */
 	emit(rv_nop(), ctx);
 
-	/* store prog start time */
-	emit_mv(RV_REG_S1, RV_REG_A0, ctx);
-
 	/* arg1: &args_off */
 	emit_addi(RV_REG_A0, RV_REG_FP, -args_off, ctx);
 	if (!p->jited)
-- 
2.43.0



