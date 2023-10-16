Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5554214288
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGMJnZic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF048C433C9;
	Mon, 16 Oct 2023 14:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467920;
	bh=9z7wpK3dsblAi5FDC1AxiMBy06yFNjb8FT9ZRNkhO0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGMJnZicyKbR607IDfOyd/9x7aHG/LQGqagn65Cb5c5fRDWMFgGc1X29gOG7I+dbY
	 PTsWRdAVrow2ycpdVEmNzVbUxAe5emgnTB0K5NcUlknUx+0NtmSz3B2iSWZh41uy89
	 /ksjd97xlwGGtuDb2Pxe9Qvc0y5VuIQXpV0ZkXKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth Swaminathan <prashanthsw@google.com>,
	Andy Chiu <andy.chiu@sifive.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.5 092/191] riscv: signal: fix sigaltstack frame size checking
Date: Mon, 16 Oct 2023 10:41:17 +0200
Message-ID: <20231016084017.542847711@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Chiu <andy.chiu@sifive.com>

commit 14a270bfab7ab1c4b605c01eeca5557447ad5a2b upstream.

The alternative stack checking in get_sigframe introduced by the Vector
support is not needed and has a problem. It is not needed as we have
already validate it at the beginning of the function if we are already
on an altstack. If not, the size of an altstack is always validated at
its allocation stage with sigaltstack_size_valid().

Besides, we must only regard the size of an altstack if the handler of a
signal is registered with SA_ONSTACK. So, blindly checking overflow of
an altstack if sas_ss_size not equals to zero will check against wrong
signal handlers if only a subset of signals are registered with
SA_ONSTACK.

Fixes: 8ee0b41898fa ("riscv: signal: Add sigcontext save/restore for vector")
Reported-by: Prashanth Swaminathan <prashanthsw@google.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Link: https://lore.kernel.org/r/20230822164904.21660-1-andy.chiu@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/signal.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -311,13 +311,6 @@ static inline void __user *get_sigframe(
 	/* Align the stack frame. */
 	sp &= ~0xfUL;
 
-	/*
-	 * Fail if the size of the altstack is not large enough for the
-	 * sigframe construction.
-	 */
-	if (current->sas_ss_size && sp < current->sas_ss_sp)
-		return (void __user __force *)-1UL;
-
 	return (void __user *)sp;
 }
 


