Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB971C57AB;
	Tue, 27 Aug 2024 15:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772409; cv=none; b=J7QhBYNM5ClIejSMAMc5296aDNp92ctCfxoDZ+d/bvKwEz33M25NwyABrCMBZW7A9Cm/VapBN3ny6bB/Zz+IM7cD9y4ciGzHpl+dtR+5ZYWIwZm/x6X0qVUtyzkT1mDaE5Cqsyo7k9v3yDMbwWkVPZCgpkozE5n6XpBAP0oqD+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772409; c=relaxed/simple;
	bh=rbUvelP94I0/FLjsdcksGYG9PWnKO4gLpQMeakjMJpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGihHk8mJ+XFU94W0yyt2r1pjIKPKRb1Zca4/o2yuRN9WYTZzP6qfzelj1QrYL4cCPqfakw3FiAbKfj8K3kYfTMoXlmO8j5d7VwMLAeR0AVkisvfMCQIa4B79jMdgokFPziHfN3VhE/DICH2EbmVKe7SXLQwc50BNR//gwivhN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhjRpdKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhjRpdKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF8EC4DE12;
	Tue, 27 Aug 2024 15:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772409;
	bh=rbUvelP94I0/FLjsdcksGYG9PWnKO4gLpQMeakjMJpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhjRpdKcgxsykrsX/uytvoB2T7pjFCAyMp1AkAK1FT9uBk3vTYMjrsDvAo1+1p/6p
	 u9EztR1v+YQPnuH7DNwv1AnuVqr6xwzGEMneutb4xCA08wAg4pMLHmf55AK8ePyIXk
	 evKOa1hOBec9Zu8hZGInz8v1VbJkZdT8VCBoOE2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	y0un9n132@gmail.com,
	Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 175/321] x86: Increase brk randomness entropy for 64-bit systems
Date: Tue, 27 Aug 2024 16:38:03 +0200
Message-ID: <20240827143844.891898677@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 279b5e9be80fc..acc83738bf5b4 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -991,7 +991,10 @@ unsigned long arch_align_stack(unsigned long sp)
 
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



