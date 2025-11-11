Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71097262A;
	Tue, 11 Nov 2025 01:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823016; cv=none; b=u5I1IP6BaPn2YpRV9FvbrAa4g+abFWbMIDatmvMiS81desyEcpkbIQ5muaIyjMu4L4Eo4Y3s/RtbSeTQgu10xgGaPfC5SZGgk9asNgBuco1wnBRKzUKFaf1c/iv80RUnFcOU+GlYjyAdr8IHsBc3p/Q/Xp1iiw13kX/cZum+hXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823016; c=relaxed/simple;
	bh=Y4aDlYj+WIvTolN1xbeSTbnASPpx6Xh/MO7vdqbVXnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFB47qxnmuT7NMD+5qhC7X1RDeIcswqSkI5Jv1Qvv8HLBhrJT4TsnzlENjl7MwH3PNvs3wT1zQwhOjWt4gIfpBXbRcig76MSD9eD6VLt7PLr3BvXgO7w0ErGJ+cm/U2AxXJhFNOZQV2W4j+Q+OVh9l9C3WWGFhVZVoHtXaKsz+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cq+nB/us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cq+nB/us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599B0C4CEF5;
	Tue, 11 Nov 2025 01:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823016;
	bh=Y4aDlYj+WIvTolN1xbeSTbnASPpx6Xh/MO7vdqbVXnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cq+nB/uspDKuVoRhWzrUVQ22hvlk5PeeY0kL3dAr/SFHOk7K4Z4nssA/jbQKKdalW
	 fyFkVyW+XJDZz81SEb0/qOUrz9BSHL8WEPhWgaeFcG7jvgJVaBHznMG6g2ihn2zxGg
	 EMMkmKScxmVkQPQu+vQZE+pVZf0rJFpQKIHjIVfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Pu Lehui <pulehui@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/565] riscv: bpf: Fix uninitialized symbol retval_off
Date: Tue, 11 Nov 2025 09:40:11 +0900
Message-ID: <20251111004530.426935924@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 497945aa3e2c4..5895c1b2be203 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -906,10 +906,9 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 	stack_size += 16;
 
 	save_ret = flags & (BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_RET_FENTRY_RET);
-	if (save_ret) {
+	if (save_ret)
 		stack_size += 16; /* Save both A5 (BPF R0) and A0 */
-		retval_off = stack_size;
-	}
+	retval_off = stack_size;
 
 	stack_size += nr_arg_slots * 8;
 	args_off = stack_size;
-- 
2.51.0



