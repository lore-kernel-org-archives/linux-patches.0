Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEFB17C;
	Sun,  1 Sep 2024 17:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210078; cv=none; b=At92njdHWhYVQ1FdJbV5zXytw7gAyJ+5elxZU6KIa18dXDb8M5OuSct3eIirf2I/eERYCil5JyQZg4uixpGPEkhCr0e8WLe1Z1OgEJtIsmI42dyCrzw2+vKP8MGRTYiF+03Sx024klSGPyruF8luab9WMLqdWvFe1O1Bzw7EJkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210078; c=relaxed/simple;
	bh=QlPc3L7DFFTMahRxtX2G6PMyoydTa+6zmA2aeqG/Vw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMHsPTYucq1Yqi4QB/Gb3JMqDONuiHDmFg08myTcNjVLl3TAkP7zZmVni/M2GxO/YRrt3ojPJFTmL/4QKZ11CRMxM7PMNRzSWMfx+ycKN4ewUnhlweU3Gjs5pNtWSMLo1bY30kwePjZ6Wwf+2oOoYzdSmiVGWNAqyu4w/h9vB+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8pAEFz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8pAEFz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F735C4CEC3;
	Sun,  1 Sep 2024 17:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210077;
	bh=QlPc3L7DFFTMahRxtX2G6PMyoydTa+6zmA2aeqG/Vw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8pAEFz58hy+1LiIufcYN5zLj+e6t+9EriBJtEffb63r0PwiaNWYD94Xma+zriSyH
	 rnJUEogcjA/Brz1TDHvEPMTjerN1E23+apyj0N7QR7V+fF/xZQJsaPhOzUoljXuF4W
	 73p2kYAR2SYt57Fo2WmBw1uIgtlUi5DWuwGP9flA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	y0un9n132@gmail.com,
	Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/215] x86: Increase brk randomness entropy for 64-bit systems
Date: Sun,  1 Sep 2024 18:16:34 +0200
Message-ID: <20240901160826.456577968@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e6b28c689e9a9..720d99520316a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -937,7 +937,10 @@ unsigned long arch_align_stack(unsigned long sp)
 
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



