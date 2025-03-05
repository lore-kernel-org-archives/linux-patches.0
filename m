Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6701256C96;
	Wed,  5 Mar 2025 18:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198778; cv=none; b=iYj4wKHWS85jCvwEZzNfokvgkPVHp2WeyljwoAZaQNnkI1lGbvo6oma77qggjnavulgSi/Ud/bBD2ioJTVwsGIFEncaVr+1MfNkZixSOykiwm7T6YoeLy0Yk+bmx5l+tAhYzVY6UpaPKoRvCc1Fu8qRLa2pqrnOlNfGBXEmlfJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198778; c=relaxed/simple;
	bh=QDAlVy4Jwoxm8o74ZV0/L0qHw4gSMfn4CUFfks+TPyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XMIjVEWQhlkkpC/PfA3fKN5DJUZ+WqGQRfElBh20Cc+ZQKeT/XpGt0gsKz28SScmbQ/LtUh980sv+4+uFCReZogC/50c7YLfYipxV6JxHD694KwQznVdDczikf3Z2UBiwKEIIzjXFT51DoXoUopBTgLgoEFeo0oL/iDjPO/hU5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2hDN4cw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2hDN4cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF1FC4CED1;
	Wed,  5 Mar 2025 18:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198777;
	bh=QDAlVy4Jwoxm8o74ZV0/L0qHw4gSMfn4CUFfks+TPyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2hDN4cw4SFyoEvoXpIQ2M5GwNmhnJmNgCt7sQEekDMRk7gKRuv/7wjJfHKQxaXoa
	 ilvtBmLg/Y+bFkUKPFRCycMfQqjS/L0G6NM2Vq737di7OkEbgQeAlf15WBEi2h6uRa
	 tw12HEkt3R5VZSUm1uNe9ALs/qnDF3wJhxK5a6uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@suse.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.13 144/157] riscv/futex: sign extend compare value in atomic cmpxchg
Date: Wed,  5 Mar 2025 18:49:40 +0100
Message-ID: <20250305174511.086323201@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


