Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EACF1ACEDD;
	Wed,  5 Mar 2025 18:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198314; cv=none; b=P051iKLLakXpvL+ymM7TCe6cH9bbt3d9u0bPEyuePuoQj8FmDKjHpqCZ4kqxxrenLYJVSHaIfiXnmXWV0OrjIda8pGlcHjpqTs9bGPHtN6nB0m4muVjbhV0XpVoVwZlk+7nKKQ1gJCk16XFJgBrmZnLs+L2zb3U/ruhGQpbWJD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198314; c=relaxed/simple;
	bh=lVZnCXM6DHSL6ujaOUVb5o4tOiKWd7NNBXJwVsD78Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ovuSDMBzgmzk9f7Jy+pJqlzVitclERVgrsg7CdL0PS5bpEr/TuYHoPD1ogMFY01XG+jZKGR1CGt4w9dHMF9HdlY3gnq02zGMP4DRUfuexk9YHto3QiAaQsl+AIallnVXjTRjGkVX3AY78YDY2gQqm7DQOuEtzDsU0UutDJrewfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oo7UtNJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oo7UtNJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14045C4CED1;
	Wed,  5 Mar 2025 18:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198314;
	bh=lVZnCXM6DHSL6ujaOUVb5o4tOiKWd7NNBXJwVsD78Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oo7UtNJChUtNeE5ammSG+mXzDUsRQm0tbpmTBG6hvFLEsWk8IKPW6VEOFNVdpFnlo
	 bE6wmRo1ZnoTba+1hUx2P73Wx5vPEAAal8VT279oTeGqgO8sKCIN0qZQBj7hVUxVt1
	 ymecleRppX1R4zHMUuZmP+JTYrI5P9otaKlxfZnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@suse.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.12 136/150] riscv/futex: sign extend compare value in atomic cmpxchg
Date: Wed,  5 Mar 2025 18:49:25 +0100
Message-ID: <20250305174509.280969998@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@suse.de>

commit 599c44cd21f4967774e0acf58f734009be4aea9a upstream.

Make sure the compare value in the lr/sc loop is sign extended to match
what lr.w does.  Fortunately, due to the compiler keeping the register
contents sign extended anyway the lack of the explicit extension didn't
result in wrong code so far, but this cannot be relied upon.

Fixes: b90edb33010b ("RISC-V: Add futex support.")
Signed-off-by: Andreas Schwab <schwab@suse.de>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/mvmfrkv2vhz.fsf@suse.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/futex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/futex.h
+++ b/arch/riscv/include/asm/futex.h
@@ -93,7 +93,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 		_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %[r])	\
 		_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %[r])	\
 	: [r] "+r" (ret), [v] "=&r" (val), [u] "+m" (*uaddr), [t] "=&r" (tmp)
-	: [ov] "Jr" (oldval), [nv] "Jr" (newval)
+	: [ov] "Jr" ((long)(int)oldval), [nv] "Jr" (newval)
 	: "memory");
 	__disable_user_access();
 


