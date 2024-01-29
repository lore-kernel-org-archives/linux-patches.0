Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBF0157E92;
	Mon, 29 Jan 2024 17:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548088; cv=none; b=JXE2AmrKHhyNP0zIQ8lon0xtiVQZKlMNNnYVuknntJ1pcPDGZvELkVEmV3Aq5RGsVX0LBzctrtZI+Kj16zVIfrJkhbFKEvgP2UCGs1YrYuEAFVm8mLWbtC4xZwukdB7nG+RbJCc2Sp7h48xQbc87YhO8pMiBwmXLw+TB8+/T1/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548088; c=relaxed/simple;
	bh=mobdU4TYJDxEpGp+8Q7ELdXvvWT5znPiKiVA2jSUZlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VO4pkIZw+VkqqjVhNkS93kJQibVXA+cIjq01mPMzdhvxxt74AY8ElxTbKB5mMNJSPxNt3397Y962IupYbFCIrzGXpwthoZqHUfmtT0NhSFDqG5UDYV62YnrUsxcjPeqchJ46elw+607um9dNGkwntxQGFqg15M3hrjmkzoIgGhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PK3KNN6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PK3KNN6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DB4C433C7;
	Mon, 29 Jan 2024 17:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548088;
	bh=mobdU4TYJDxEpGp+8Q7ELdXvvWT5znPiKiVA2jSUZlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PK3KNN6syEXlyXfiJHD6zOAEYAa/mNwtUXL6oft1UX7Wrh8q/dPnlketxsVlHKdBH
	 zs0dC0zIJxW6Z/KfLwMGAsM9SM7mDQQzelWD3lN1bPPsfDULKQ/3oa6AW3Bj7mOX9S
	 c5wZpxxD5flfpmowRqiMOJPKqw8M+als119Kd5dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@linux.alibaba.com>,
	Guo Ren <guoren@kernel.org>,
	Leonardo Bras <leobras@redhat.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.7 103/346] riscv: mm: Fixup compat mode boot failure
Date: Mon, 29 Jan 2024 09:02:14 -0800
Message-ID: <20240129170019.431552808@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo Ren <guoren@linux.alibaba.com>

commit 5f449e245e5b0d9d63eef6c8968fbdc3a8594407 upstream.

In COMPAT mode, the STACK_TOP is DEFAULT_MAP_WINDOW (0x80000000), but
the TASK_SIZE is 0x7fff000. When the user stack is upon 0x7fff000, it
will cause a user segment fault. Sometimes, it would cause boot
failure when the whole rootfs is rv32.

Freeing unused kernel image (initmem) memory: 2236K
Run /sbin/init as init process
Starting init: /sbin/init exists but couldn't execute it (error -14)
Run /etc/init as init process
...

Increase the TASK_SIZE to cover STACK_TOP.

Cc: stable@vger.kernel.org
Fixes: add2cc6b6515 ("RISC-V: mm: Restrict address space for sv39,sv48,sv57")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Leonardo Bras <leobras@redhat.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20231222115703.2404036-2-guoren@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -881,7 +881,7 @@ static inline pte_t pte_swp_clear_exclus
 #define TASK_SIZE_MIN	(PGDIR_SIZE_L3 * PTRS_PER_PGD / 2)
 
 #ifdef CONFIG_COMPAT
-#define TASK_SIZE_32	(_AC(0x80000000, UL) - PAGE_SIZE)
+#define TASK_SIZE_32	(_AC(0x80000000, UL))
 #define TASK_SIZE	(test_thread_flag(TIF_32BIT) ? \
 			 TASK_SIZE_32 : TASK_SIZE_64)
 #else


