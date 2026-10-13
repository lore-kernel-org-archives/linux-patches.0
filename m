Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97F94E4C5A;
	Tue, 13 Oct 2026 11:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892249; cv=none; b=Qzusc3gKIp2Bm+VRxbe9oOCsyVm6Ghcrp6yJfGKRqnB/KjFWE24rHTpzPwjH0OkqZ6giPtsfrQkVsEuepEQPVxOIk5zUBOT9PzkpQPzlR9vj8V3kdQZIOili9v7MX4a9rxDlXiToI49WO/9U7M7NMauKspFbgbrZi0IR9DGBND4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892249; c=relaxed/simple;
	bh=DBiCRo8kBbd6exXP8ppjnuVlEIMC/Qyupov49uuCfMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TduklV6TgN/AhYt/AcyI6omu4uBi90tE4Rn6E4mUW4kZ3x24PzT6BKiSxPMryXp/as/ZFJ/SIqXeOK9pGLx1+x2UnEz6iEHkUjFYcG+/rze5VhPbscv3X3M0P7nop5+OBFOyKo3sODyHJsLxzAM6Kf7dqPtQT7C64seXFt002Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNYV3Wdc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNYV3Wdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA9B1F000FF;
	Tue, 13 Oct 2026 11:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892248;
	bh=0SAhyPd5qEbg3GKUJMdrL6gWRJGSH1Pv3/mU8Nx2YfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNYV3WdcC9u2i3MSdHEaicY9gHUKjPvHZEl2gVaBo+qkR0rUJiP+AMyNiAifghiL9
	 zc4SyNckz5lHGVWdv1oUZ3xo4zGXrY84AHayBiO9x8Pqmf0ofZcpjb7k8ZMvSnq5W2
	 qAzcfx5dCGvV39a46TbDUtD0ES8mRsEQAw6xAWaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Ziyi Guo <guoziyi114@gmail.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.2 109/281] riscv: futex: untag the user pointer before the atomic access
Date: Tue, 13 Oct 2026 13:37:05 +0200
Message-ID: <20261013112857.789227588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Ziyi Guo <guoziyi114@gmail.com>

commit 405290be962b32eec842776fbe3bdf81f15b1676 upstream.

access_ok() checks untagged_addr(uaddr), but arch_futex_atomic_op_inuser()
and futex_atomic_cmpxchg_inatomic() hand the raw uaddr to the inline asm
amoswap/amoadd/.../lr.w+sc.w through the "+m" (*uaddr) operand.  When the
tagged address ABI is enabled (CONFIG_RISCV_ISA_SUPM, prctl
PR_SET_TAGGED_ADDR_CTRL with PMLEN != 0), those two addresses differ: a
user pointer whose top PMLEN bits hold a tag passes access_ok() after
untagging, but the atomic is then performed on the still-tagged raw
address.

Supervisor-mode data accesses are not subject to the U-mode pointer
masking (that is governed by menvcfg.PMM, which the kernel does not set),
so hardware does not strip the tag for the kernel's own access.  With
Sv57 and PMLEN=16 the tag bits overlap the canonical-address bits, so a
tagged pointer can name a canonical kernel virtual address (e.g. in the
linear map) whose untagged form is a valid user address.  An unprivileged
process can thus make FUTEX_WAKE_OP perform an atomic read-modify-write on
an arbitrary kernel address, with the matching FUTEX_OP_CMP_* result
serving as a read oracle.

get_user()/put_user()/raw_copy_{to,from}_user() already untag the pointer
after the access_ok() check; do the same in the futex helpers so the
atomic operates on the address that was actually validated.

Fixes: 2e1743085887 ("riscv: Add support for the tagged address ABI")
Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Signed-off-by: Ziyi Guo <guoziyi114@gmail.com>
Link: https://patch.msgid.link/20261006140200.877263-1-guoziyi114@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/futex.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/riscv/include/asm/futex.h
+++ b/arch/riscv/include/asm/futex.h
@@ -40,6 +40,7 @@ arch_futex_atomic_op_inuser(int op, int
 
 	if (!access_ok(uaddr, sizeof(u32)))
 		return -EFAULT;
+	uaddr = untagged_addr(uaddr);
 
 	switch (op) {
 	case FUTEX_OP_SET:
@@ -82,6 +83,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 
 	if (!access_ok(uaddr, sizeof(u32)))
 		return -EFAULT;
+	uaddr = untagged_addr(uaddr);
 
 	__enable_user_access();
 	__asm__ __volatile__ (


