Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C57E2B9C7;
	Sun,  1 Sep 2024 16:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208835; cv=none; b=l0FpXvfXhDjrdvW2wTxVj0MbqAlet3ZhSfobIpi1/M1LqorVwLh2RC3OtVW4D4sYrkInqd2jCK72kuON+qtbXZ59PWMJ0YJSEebEbakHsIa2JFpZH+gpmNXC/hW5E7VZscJzIuFc1DmnufHckeW58v1U7R6rBiQJZTWh8E6Ligs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208835; c=relaxed/simple;
	bh=VHQh11OdeVQnYAbipgDOjsU3Mw7ml38aC8a/8ubNalU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9fC2ytUcXanxU5W1EpkUOUP25Z4R92T40u1b8Uu5CZWAWYPNIL5KDTnUxA24wZzAIGfi5c7ETOr8BI4Hn4ezKTWudnCq7OO+CMfgoaqa3YBSx5etAH/rPg+ekwEWuBsTP6sQqhSoaQyLSi7s6pVpPKwVs/G0q+xHGq3LOppqOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yXmiD9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yXmiD9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8343C4CEC3;
	Sun,  1 Sep 2024 16:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208835;
	bh=VHQh11OdeVQnYAbipgDOjsU3Mw7ml38aC8a/8ubNalU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yXmiD9+pRT69TxqSrYG1YgjhSbchXVoeIf6kcpvrilNfGnnTlUj7ZhYDami4lhOz
	 1262c9F1oxufYJkJeGsY79Zs4e8T85QmabZ4FRpzBd7rdIUBnqgr8qtytLgFFzfh4Y
	 FYqGFODpoeKPqVFU7XAqRHgA+SziHxr389JA2FXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	y0un9n132@gmail.com,
	Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/134] x86: Increase brk randomness entropy for 64-bit systems
Date: Sun,  1 Sep 2024 18:16:38 +0200
Message-ID: <20240901160812.066581339@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 44c76825d6eefee9eb7ce06c38e1a6632ac7eb7d ]

In commit c1d171a00294 ("x86: randomize brk"), arch_randomize_brk() was
defined to use a 32MB range (13 bits of entropy), but was never increased
when moving to 64-bit. The default arch_randomize_brk() uses 32MB for
32-bit tasks, and 1GB (18 bits of entropy) for 64-bit tasks.

Update x86_64 to match the entropy used by arm64 and other 64-bit
architectures.

Reported-by: y0un9n132@gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Jiri Kosina <jkosina@suse.com>
Closes: https://lore.kernel.org/linux-hardening/CA+2EKTVLvc8hDZc+2Yhwmus=dzOUG5E4gV7ayCbu0MPJTZzWkw@mail.gmail.com/
Link: https://lore.kernel.org/r/20240217062545.1631668-1-keescook@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/process.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index b8de27bb6e09c..c402b079b74e8 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -793,7 +793,10 @@ unsigned long arch_align_stack(unsigned long sp)
 
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
-	return randomize_page(mm->brk, 0x02000000);
+	if (mmap_is_ia32())
+		return randomize_page(mm->brk, SZ_32M);
+
+	return randomize_page(mm->brk, SZ_1G);
 }
 
 /*
-- 
2.43.0



