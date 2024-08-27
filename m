Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EBC1B4C4E;
	Tue, 27 Aug 2024 15:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771086; cv=none; b=pgCpp1UO1DHV0iI5mWHp1SEk12oy1jceotDihOuFrKqhCXKsf9JtGvsE0VJZyf+hUqamd879xHWswX2dxEDDa09Z5uPvkrNqjyrIlLjx322wspBHfpLgWMdRwNWeqHTa71RPdaL8CQWzSReBygO3HjLa+8QaA62qHzCwTkrP8bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771086; c=relaxed/simple;
	bh=2yz6Hbs4pvP40myNpak07pz6V+5Pw4b1yoJfpcKMGbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hciK52lXmL4H5+F3OlRhOXpYJrZIaqpvUo6/n1DGSjLQqv9gj1BbKWz248Qa/OuKX5FwW0GbP8v6ATaSYrZC5u4U/UdXE1owMik0Uh3gIHW7+aV4d/hSGYKvt3lpC+03VAsvp3fFvbutgc5xP99nIW9Jv2DxoeYSdkrxoShAayk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdJ7wxhn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdJ7wxhn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6A6C6105B;
	Tue, 27 Aug 2024 15:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771085;
	bh=2yz6Hbs4pvP40myNpak07pz6V+5Pw4b1yoJfpcKMGbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wdJ7wxhnQ925IVqzwKY2pH7FkTf8Q0hKBipE2Yov6RP6Li14KIFFUZ3BcMtRR56hU
	 06cnaBohhMJjW/qVJvgsyctC9epNF6uzp7sFM8SfVUDZZ0E17SVZ9yOA5C2T0q1xLF
	 dZP5+tOhEXmpr51VfPRmuTcXyFocS9iGXoi6dfh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Daniel Hodges <hodgesd@meta.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 082/273] bpf: Fix a kernel verifier crash in stacksafe()
Date: Tue, 27 Aug 2024 16:36:46 +0200
Message-ID: <20240827143836.533175374@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit bed2eb964c70b780fb55925892a74f26cb590b25 ]

Daniel Hodges reported a kernel verifier crash when playing with sched-ext.
Further investigation shows that the crash is due to invalid memory access
in stacksafe(). More specifically, it is the following code:

    if (exact != NOT_EXACT &&
        old->stack[spi].slot_type[i % BPF_REG_SIZE] !=
        cur->stack[spi].slot_type[i % BPF_REG_SIZE])
            return false;

The 'i' iterates old->allocated_stack.
If cur->allocated_stack < old->allocated_stack the out-of-bound
access will happen.

To fix the issue add 'i >= cur->allocated_stack' check such that if
the condition is true, stacksafe() should fail. Otherwise,
cur->stack[spi].slot_type[i % BPF_REG_SIZE] memory access is legal.

Fixes: 2793a8b015f7 ("bpf: exact states comparison for iterator convergence checks")
Cc: Eduard Zingerman <eddyz87@gmail.com>
Reported-by: Daniel Hodges <hodgesd@meta.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20240812214847.213612-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a8845cc299fec..521bd7efae038 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16881,8 +16881,9 @@ static bool stacksafe(struct bpf_verifier_env *env, struct bpf_func_state *old,
 		spi = i / BPF_REG_SIZE;
 
 		if (exact != NOT_EXACT &&
-		    old->stack[spi].slot_type[i % BPF_REG_SIZE] !=
-		    cur->stack[spi].slot_type[i % BPF_REG_SIZE])
+		    (i >= cur->allocated_stack ||
+		     old->stack[spi].slot_type[i % BPF_REG_SIZE] !=
+		     cur->stack[spi].slot_type[i % BPF_REG_SIZE]))
 			return false;
 
 		if (!(old->stack[spi].spilled_ptr.live & REG_LIVE_READ)
-- 
2.43.0



