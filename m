Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B84D15957A;
	Mon, 29 Jan 2024 17:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548087; cv=none; b=ov/bVE5Ei64PSUmjOLVXh7cnvlr4VgAnoAmmTZfj34x6D+KTIM1m8RHLKSP4XF8uvcUrnzB5YqzbDK5OF6LMNouZPxbT6wg1kJ/c7dhQqoZAJN7oAOBy49S5PLbE/Bb/rpLfDgPPoAkmN0XJAqRU4AHu1F15f9Pnm3x0y9aib1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548087; c=relaxed/simple;
	bh=BwFmundTnuCYmdiGaWlWhTKVaYmy1juRn4qriHZkRg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACC/mFe2P7DcvwiwEB7F2GwEYzZ1XX2c8nrVSTxSLDY6Iym8yMC7QD+KooGQ8xuLoSB5dZ00UwUGBSILUE6zyRjnuj+BeYoPEdwL0887mxYjdY0PGmSgGFOI8KClANLKRKAymomKQJdI+D2HyuSzJv0pSU6bqXrJqeCp7R+35wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQtrBvOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQtrBvOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5180FC433C7;
	Mon, 29 Jan 2024 17:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548087;
	bh=BwFmundTnuCYmdiGaWlWhTKVaYmy1juRn4qriHZkRg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQtrBvOw+vs5hu6QvHZcAUW7DQI1XMSDhgXuzD0US7ZSpapTE2dmQ+t90PaVPyHrf
	 IH0jaoDDePlvlwK8G8m6VDKA7pgD55IgIVkQQGY5PSnq5I5ZBJlJ6EQnbzSN9zqL9k
	 GjAg4sknYJxUrPbL7RH8J9sUHyKgK1wo6YJzYMMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@linux.alibaba.com>,
	Guo Ren <guoren@kernel.org>,
	Leonardo Bras <leobras@redhat.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.7 102/346] riscv: mm: Fixup compat arch_get_mmap_end
Date: Mon, 29 Jan 2024 09:02:13 -0800
Message-ID: <20240129170019.405020133@linuxfoundation.org>
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

commit 97b7ac69be2e5a683e898f5267f659fde52efdd5 upstream.

When the task is in COMPAT mode, the arch_get_mmap_end should be 2GB,
not TASK_SIZE_64. The TASK_SIZE has contained is_compat_mode()
detection, so change the definition of STACK_TOP_MAX to TASK_SIZE
directly.

Cc: stable@vger.kernel.org
Fixes: add2cc6b6515 ("RISC-V: mm: Restrict address space for sv39,sv48,sv57")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Leonardo Bras <leobras@redhat.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20231222115703.2404036-3-guoren@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -16,7 +16,7 @@
 
 #ifdef CONFIG_64BIT
 #define DEFAULT_MAP_WINDOW	(UL(1) << (MMAP_VA_BITS - 1))
-#define STACK_TOP_MAX		TASK_SIZE_64
+#define STACK_TOP_MAX		TASK_SIZE
 
 #define arch_get_mmap_end(addr, len, flags)			\
 ({								\


