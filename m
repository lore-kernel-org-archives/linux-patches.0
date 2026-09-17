Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771AF4CDDFE;
	Thu, 17 Sep 2026 15:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660126; cv=none; b=jUS/kTehVD4cIS3knEGf+gYZqj/jozfNp9W4AKbuMhLbQhm931vyTKEr1buqbq3tF/jk+KXVB4qzuGBcfy9bjaWd6vR27s0Pvcilkn/0uQ/ayFI6MfGl7mnsfqmFRnWlvfBr+ZlZ8ueS64lY5X9+fAscb7kDxriwwoULWSJn0q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660126; c=relaxed/simple;
	bh=Qh38uf6PzIIlaNojt40NTTWOHm1FKKZrBLd7EAr+5Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lz0Dm6zaFGpJU/odvX5jBF6Az2Q3W8w41Y/Kg3WxTBCYAj4oEm44MBc2/iMmaiuQdlxFjqCdqOsbhb8RPP7zBfkqVHQOqvZrD+e8Y5HHUUlQotLHEcJuHSS/UBkSmN+UvQnsouqiWG57ZKrZfuMbt2Q4smZ7qG6Zuo8lxb+JPw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0b0V2oi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0b0V2oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88EC1F00898;
	Thu, 17 Sep 2026 15:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660118;
	bh=xoT6eGxSRLreUVb00rVph5IgeGSFx1OsNxcUuad9OSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t0b0V2oiIff9tnXb6dPdo+TErONA8l1S2tvyVLG5NaluiZkt8J7OGfHIof4yDLy5Q
	 j2VZv2kMyZy2qOJo/yx8MT57oeYIT/QSAM/VjHYhL6n9uW2oMTPtmDaYOxgW4HLo/0
	 HWpP/i5EdhV0MuPRuRNGyrUghwHiOTABE9DRqmxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.2 484/733] Revert "riscv: Reset pmm when PR_TAGGED_ADDR_ENABLE is not set"
Date: Thu, 17 Sep 2026 16:13:12 +0100
Message-ID: <20260917151404.092234285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Samuel Holland <samuel.holland@sifive.com>

commit 2d2184ac90365a4af3274e23c98d469f09f91749 upstream.

This reverts commit 3033b2b1e3949274f33a140e2a97571b5a307298.

The reverted patch is userspace-visible behavior change, not a bug fix.
The two variables here (pmm and pmlen) control two independent features:
pmm is the _hardware_ pointer masking mode that applies while executing
in userspace. pmlen is the shift amount that the _kernel_ uses when
untagging addresses; PMLEN_0 means no untagging occurs, so the kernel
does not accept tagged addresses in syscall arguments.

It is valid (as documented and tested by the self test) to enable
pointer masking without enabling the tagged address ABI. This separation
is necessary to allow userspace to create an execution environment
similar to what the kernel supports on arm64 by default, where TBI is
enabled but the tagged address ABI is not. (On arm64, there is no
equivalent to PR_PMLEN_MASK because TBI is always enabled.)

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://patch.msgid.link/20260820014551.1979772-1-samuel.holland@sifive.com
Cc: stable@vger.kernel.org
Fixes: 3033b2b1e394 ("riscv: Reset pmm when PR_TAGGED_ADDR_ENABLE is not set")
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/process.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -349,10 +349,8 @@ long set_tagged_addr_ctrl(struct task_st
 	if (arg & PR_TAGGED_ADDR_ENABLE && (tagged_addr_disabled || !pmlen))
 		return -EINVAL;
 
-	if (!(arg & PR_TAGGED_ADDR_ENABLE)) {
+	if (!(arg & PR_TAGGED_ADDR_ENABLE))
 		pmlen = PMLEN_0;
-		pmm = ENVCFG_PMM_PMLEN_0;
-	}
 
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;


