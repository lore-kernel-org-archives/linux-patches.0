Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAED8833
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5909C433C7;
	Sun, 16 Jul 2023 20:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540431;
	bh=yR3tLSxtRZAvF1rRQ4nojQYQYF38Es+hEftBMrpqFvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yq5RlW/UwiBYdHGAsT36EfijTCitVXPhUX7wbi6jiWjpx/USz75dtEvACe88DPZ+D
	 mWUsFYZ/T1j0uD9U3YZODqQDxe17iIoiwP5F694U1d2RxZEnr9KAiRgxm97eRD+YWq
	 /yWO+rIcRjOMf1Os6uNsihka/X9+KQ3DdJDMiJgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Will Deacon <will@kernel.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 360/591] arm64: sme: Use STR P to clear FFR context field in streaming SVE mode
Date: Sun, 16 Jul 2023 21:48:19 +0200
Message-ID: <20230716194933.227283046@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Will Deacon <will@kernel.org>

[ Upstream commit 893b24181b4c4bf1fa2841b1ed192e5413a97cb1 ]

The FFR is a predicate register which can vary between 16 and 256 bits
in size depending upon the configured vector length. When saving the
SVE state in streaming SVE mode, the FFR register is inaccessible and
so commit 9f5848665788 ("arm64/sve: Make access to FFR optional") simply
clears the FFR field of the in-memory context structure. Unfortunately,
it achieves this using an unconditional 8-byte store and so if the SME
vector length is anything other than 64 bytes in size we will either
fail to clear the entire field or, worse, we will corrupt memory
immediately following the structure. This has led to intermittent kfence
splats in CI [1] and can trigger kmalloc Redzone corruption messages
when running the 'fp-stress' kselftest:

 | =============================================================================
 | BUG kmalloc-1k (Not tainted): kmalloc Redzone overwritten
 | -----------------------------------------------------------------------------
 |
 | 0xffff000809bf1e22-0xffff000809bf1e27 @offset=7714. First byte 0x0 instead of 0xcc
 | Allocated in do_sme_acc+0x9c/0x220 age=2613 cpu=1 pid=531
 |  __kmalloc+0x8c/0xcc
 |  do_sme_acc+0x9c/0x220
 |  ...

Replace the 8-byte store with a store of a predicate register which has
been zero-initialised with PFALSE, ensuring that the entire field is
cleared in memory.

[1] https://lore.kernel.org/r/CA+G9fYtU7HsV0R0dp4XEH5xXHSJFw8KyDf5VQrLLfMxWfxQkag@mail.gmail.com

Cc: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: 9f5848665788 ("arm64/sve: Make access to FFR optional")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Link: https://lore.kernel.org/r/20230628155605.22296-1-will@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/fpsimdmacros.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
index 5e0910cf48321..696d247cf8fb0 100644
--- a/arch/arm64/include/asm/fpsimdmacros.h
+++ b/arch/arm64/include/asm/fpsimdmacros.h
@@ -294,12 +294,12 @@
  _for n, 0, 15,	_sve_str_p	\n, \nxbase, \n - 16
 		cbz		\save_ffr, 921f
 		_sve_rdffr	0
-		_sve_str_p	0, \nxbase
-		_sve_ldr_p	0, \nxbase, -16
 		b		922f
 921:
-		str		xzr, [x\nxbase]		// Zero out FFR
+		_sve_pfalse	0			// Zero out FFR
 922:
+		_sve_str_p	0, \nxbase
+		_sve_ldr_p	0, \nxbase, -16
 		mrs		x\nxtmp, fpsr
 		str		w\nxtmp, [\xpfpsr]
 		mrs		x\nxtmp, fpcr
-- 
2.39.2



