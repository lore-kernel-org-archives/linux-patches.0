Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CD1612D7;
	Tue, 20 Feb 2024 21:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463589; cv=none; b=HuPpXaOHIitI5onyKxhh9PI77HrQjB7TRQn/FMwn/3sQi7fRQcghm//JS4C5+ZkJQCgJHf/uN1C5fDsw+MQNnfZRXjMCxiXUJI0F1fkrwaORZ+W094TLtYufPnOVI2hwJKvmwmzScGbLJ9wgNQ4Dqe3vL2czBDV27tYNQoXfV+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463589; c=relaxed/simple;
	bh=LU1CjDZ9J0YcXfutNg35a6BX1VVW32Khv9vuvh8uy60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4qDHO6pgr9DVxsJg5RLnR1IKjG6TmJCGtsmulEjsY8edhd3JFqXWxtX0ZkUO3I8u2TbmOl5lQTeiMohZCiyIwTEDu9XPorBIcw1wRsw8nqaYIgtpdwRUll+Zqy9JTqOiQX9aQfhY2e1lR6dKd3zJqDs+nmPcuKWMqtaHHoBlUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMHx+iw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMHx+iw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4567BC433C7;
	Tue, 20 Feb 2024 21:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463589;
	bh=LU1CjDZ9J0YcXfutNg35a6BX1VVW32Khv9vuvh8uy60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMHx+iw/OwoxwWKECi7rq2Jk2pAaLx9FG1CjNgqsPHQX1K1mnArQIugjuF5qQzanM
	 4d9MdLHaPEhJFZv0fVWU4iOYQNLoFCnUYAuHkDHa5P1LknoBy7IniJJgmOjcOYYmiD
	 3XgKMPbqzaqtQz7dCLtsqNZ4pQ/HSGkaujeXL0X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/331] mm/memory: Use exception ip to search exception tables
Date: Tue, 20 Feb 2024 21:52:48 +0100
Message-ID: <20240220205639.228235192@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dccf9203dd53..b3be18f1f120 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5315,7 +5315,7 @@ static inline bool get_mmap_lock_carefully(struct mm_struct *mm, struct pt_regs
 		return true;
 
 	if (regs && !user_mode(regs)) {
-		unsigned long ip = instruction_pointer(regs);
+		unsigned long ip = exception_ip(regs);
 		if (!search_exception_tables(ip))
 			return false;
 	}
@@ -5340,7 +5340,7 @@ static inline bool upgrade_mmap_lock_carefully(struct mm_struct *mm, struct pt_r
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



