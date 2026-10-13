Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28644F68AD;
	Tue, 13 Oct 2026 12:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893062; cv=none; b=JUtcoBvoXys7BtI+2Sjmkk36bJk/cGQADR7a53sxW0REdgF6dh9SdTwb281m+TpjrGOcOlzLqZCAAqfcgFvds7sCyIAgoVPntaR5lw9dcikRt/dTRVDM/x+RYPuHNOF77PHpI4QjAJHYNnzwmQG9U/PrwtE7hR/JftobrFQO0ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893062; c=relaxed/simple;
	bh=0GK4RytUWv46CwzP6hqOACE9TsTWuKWLPLUmGcDR8kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNC+rqa8W6vw+OfeefqidznI5XuAacSq5Cqui+mxl7k0yH9WN8K/ZWuNaeAFxdAvJFuF1OIhEBzJHkp6YjtqbZTVO0rgQzzqW5Q3UulZIokzOF5y+HeVvCNr9WRRjBkV3Q6N+wsG8uXE3MKMQ5Ygw5EgxSfCX8dUszyP3MKFwh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bd5s2J8T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bd5s2J8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189A11F000FF;
	Tue, 13 Oct 2026 12:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893061;
	bh=wu5V5h+QnviWF5C5bReP0xLANjtfuFX+f8W2kcbRcl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bd5s2J8TuHophR+aJ6vj1lgKjXTBHnDtuTGbJFD/jpV4Jf3z95BE3hg8W54wFlZMs
	 nNasmaQVMmesRsTP9e4YgJd1v4zbJSbJM7fPWDpiQNAfIHXewzluxkCEqDih0umkOB
	 Q5IpASPKEE0WXYvoveTj/UJ+6VfP07330DnklD9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Ziyi Guo <guoziyi114@gmail.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 099/621] riscv: futex: untag the user pointer before the atomic access
Date: Tue, 13 Oct 2026 13:31:34 +0200
Message-ID: <20261013112923.199045112@linuxfoundation.org>
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


