Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAC314A4E6;
	Tue, 20 Feb 2024 21:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464572; cv=none; b=dk3V0Se/Iewzk953hRj5LumlW7Pr+4btEEFdkEoV5oVxwHPR2dxb/YDsix5tzdDChpJtkSCY9TgOGm9VdR9pc0j91lAJ2CGxAkZ51mpXLV9qSMhJ9y6Xk2QiGUKIiEBNhgX1RqK4we6T6Pc/57Nm1zR0CDMxVcW+pAVHiG3+lw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464572; c=relaxed/simple;
	bh=Utarpf+uy9noqZJ3UVosVulBLLZeYso2TezqF11FBeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWrTBJjGEFPtJnhSgdhOhA/mPxo/nOXYb8FadZjJTSagDRk15CCEw+JMJvUUDpZmi+DZZcTJ42lcP0lFHaqJWFDe62AIKTaFjiGHuvtfcbBzxFmNSunYFC30CWumbJWnjsfL4TRn9r8y4Vl7Hy65UGHjvG60+51v+ZAl+zRdw/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSou6wVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSou6wVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FEEC433C7;
	Tue, 20 Feb 2024 21:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464572;
	bh=Utarpf+uy9noqZJ3UVosVulBLLZeYso2TezqF11FBeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSou6wVzcc/f401aZn2N27wHO8ayvxIRGK8BnhO3ielmlZnjoFyXcK+TKADJstJ6Z
	 zU28FdsVxDWL7tRxGCSjRj1fVkclQyLvSO4iox/SU6kEgWX0POmtHjZgscBoa9CWRx
	 AbvSxLM7YLw65NZsCyAlzySKT3Y2cpJ/RYWxY5eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 060/309] mm/memory: Use exception ip to search exception tables
Date: Tue, 20 Feb 2024 21:53:39 +0100
Message-ID: <20240220205635.103258941@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 8fa5070833886268e4fb646daaca99f725b378e9 ]

On architectures with delay slot, instruction_pointer() may differ
from where exception was triggered.

Use exception_ip we just introduced to search exception tables to
get rid of the problem.

Fixes: 4bce37a68ff8 ("mips/mm: Convert to using lock_mm_and_find_vma()")
Reported-by: Xi Ruoyao <xry111@xry111.site>
Link: https://lore.kernel.org/r/75e9fd7b08562ad9b456a5bdaacb7cc220311cc9.camel@xry111.site/
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6e0712d06cd4..f941489d6041 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5373,7 +5373,7 @@ static inline bool get_mmap_lock_carefully(struct mm_struct *mm, struct pt_regs
 		return true;
 
 	if (regs && !user_mode(regs)) {
-		unsigned long ip = instruction_pointer(regs);
+		unsigned long ip = exception_ip(regs);
 		if (!search_exception_tables(ip))
 			return false;
 	}
@@ -5398,7 +5398,7 @@ static inline bool upgrade_mmap_lock_carefully(struct mm_struct *mm, struct pt_r
 {
 	mmap_read_unlock(mm);
 	if (regs && !user_mode(regs)) {
-		unsigned long ip = instruction_pointer(regs);
+		unsigned long ip = exception_ip(regs);
 		if (!search_exception_tables(ip))
 			return false;
 	}
-- 
2.43.0



