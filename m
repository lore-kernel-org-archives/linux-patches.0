Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED36C197525;
	Thu,  6 Jun 2024 14:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682964; cv=none; b=eJ0FIlrOfB/40IFLQ08HcRfWqoAR+Fw66d1XkN76Ak27GknTpxjW6TQ77pW3ioFjLlYlp0LYm1LV++Rr7EQY0I58cZ6MeRb/pnFAGYsj4wFjAbSK8UhW7uycN0NB10FCNQtRUHWnmMb6AFW4NTaqelC40jX7LzFZ8Et7QKF7nbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682964; c=relaxed/simple;
	bh=AgVUPRfl/LcWyV2gnjP82G6/B6jiU8NBo7RHr+uSKy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vzgz80/9598B0UduTPnnIgpj3oKv14Gp8HHqlz/kVWzRd1We6lUooHvDOWZBuOSQs9fL3h0m+qoxe7gOUQfwdTvW1orpAD7/UDd89rcOyX+vS7NMS/Tr7gA0IrX4XHGMJF6cjoT/GlKBI5r8lAptQyYGUwVC9nZtLDuBof3rpEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YprnaJfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YprnaJfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1901C32781;
	Thu,  6 Jun 2024 14:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682963;
	bh=AgVUPRfl/LcWyV2gnjP82G6/B6jiU8NBo7RHr+uSKy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YprnaJfe/+PRZMhc3hWLsmnNZR9Pq2caQY6xSDAQygi1zOseoKNcrfGTagb1mSKRm
	 27PsGijZsJJHp4J8r3iem58T2j9/c5XrVWgn6GWOebaJoU7wbEY99wsvnjaR/AaqTJ
	 qwkUyvZgmG113Fux/hnDsnUutgG1GJT7BPn6lDbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 132/374] s390/stacktrace: Skip first user stack frame
Date: Thu,  6 Jun 2024 16:01:51 +0200
Message-ID: <20240606131656.324836011@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 87eceb17a987802aeee718be4decd19b56fc8e33 ]

When walking user stack frames the first stack frame (where the stack
pointer points to) should be skipped: the return address of the current
function is saved in the previous stack frame, not the current stack frame,
which is allocated for to be called functions.

Fixes: aa44433ac4ee ("s390: add USER_STACKTRACE support")
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/stacktrace.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index e580d4cd2729a..1c9e3b7739a22 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -95,6 +95,10 @@ void arch_stack_walk_user_common(stack_trace_consume_fn consume_entry, void *coo
 	while (1) {
 		if (__get_user(sp, &sf->back_chain))
 			break;
+		/* Sanity check: ABI requires SP to be 8 byte aligned. */
+		if (!sp || sp & 0x7)
+			break;
+		sf = (void __user *)sp;
 		if (__get_user(ip, &sf->gprs[8]))
 			break;
 		if (ip & 0x1) {
@@ -110,10 +114,6 @@ void arch_stack_walk_user_common(stack_trace_consume_fn consume_entry, void *coo
 		}
 		if (!store_ip(consume_entry, cookie, entry, perf, ip))
 			return;
-		/* Sanity check: ABI requires SP to be aligned 8 bytes. */
-		if (!sp || sp & 0x7)
-			break;
-		sf = (void __user *)sp;
 		first = false;
 	}
 	pagefault_enable();
-- 
2.43.0



