Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BA634F497;
	Fri, 21 Nov 2025 13:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732476; cv=none; b=ZRyL60TVNlJp/sV26d/3oJ5ady+T10saKwycBlpIK2SMxmz2Ydb+CgO96egUtZH+9lMenRlew1kN8no5CoedRyHUQ7d0Zr5hLOY+BZ2YjuE69eHN1MQTwHDFQ5t/Z0BSz7hlTl1ssufCH3d4//wHwMWY+tKOeMoq6+1ffFjsUwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732476; c=relaxed/simple;
	bh=VsokRfjmWXoQTeRIdRao5EghOHRiMu3zIgyNULmrGro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fb42babtQyHW5ZsPEr9poDh3iRd9q3fHJ1SAF5uP+x/UgRt1Pur5zjvbNoaGyQ1bhwnbYFtynALr5ffy0zw+B359EswdluHWQmbgWDtbLQ6/B5pJfq8BUjElf1kRX9LXQUcczYK1ZWhKlEN7mCAvVvr9hY62TWrNYh7ZPFz7yb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kb+R1pBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kb+R1pBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CBFC4CEFB;
	Fri, 21 Nov 2025 13:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732475;
	bh=VsokRfjmWXoQTeRIdRao5EghOHRiMu3zIgyNULmrGro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kb+R1pBl6JOafDx926yeYcIZESe2V/3DG6LzY46CHgBduhYgxfZOyZ4pQ0SmjPf7+
	 gr3yp6+XPYV82lcGrWwD1Z9+wT7ltIDzlrOfM9p+En8Cx2+Xa2LJ9TYOU5hhNlWiea
	 96TtBGh5WpT8dD+TJw53pk4iBMjQQwWkW+oftMcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Pu Lehui <pulehui@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/529] riscv: bpf: Fix uninitialized symbol retval_off
Date: Fri, 21 Nov 2025 14:06:40 +0100
Message-ID: <20251121130234.618367766@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghao Duan <duanchenghao@kylinos.cn>

[ Upstream commit d0bf7cd5df18466d969bb60e8890b74cf96081ca ]

In the __arch_prepare_bpf_trampoline() function, retval_off is only
meaningful when save_ret is true, so the current logic is correct.
However, in the original logic, retval_off is only initialized under
certain conditions; for example, in the fmod_ret logic, the compiler is
not aware that the flags of the fmod_ret program (prog) have set
BPF_TRAMP_F_CALL_ORIG, which results in an uninitialized symbol
compilation warning.

So initialize retval_off unconditionally to fix it.

Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/r/20250922062244.822937-2-duanchenghao@kylinos.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 16eb4cd11cbd6..5426dc2697f94 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -855,10 +855,9 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 	stack_size += 16;
 
 	save_ret = flags & (BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_RET_FENTRY_RET);
-	if (save_ret) {
+	if (save_ret)
 		stack_size += 16; /* Save both A5 (BPF R0) and A0 */
-		retval_off = stack_size;
-	}
+	retval_off = stack_size;
 
 	stack_size += nregs * 8;
 	args_off = stack_size;
-- 
2.51.0



