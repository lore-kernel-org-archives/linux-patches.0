Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CBA46F4AF;
	Tue, 21 Jul 2026 17:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656786; cv=none; b=HKgeV88nqblnLeFtVnwqYLqbjbkgzR7neQq/L5F5gtYJQm58wmNvQkt+KRQs0H/2Txs//G+46ejeIBEoktkSdUFftAL+Qxn5Yf3hbua6raCRERBVtwPycszs+QM4zOlje7Rlr4wFQT+UctoCQQnu6QG6k6YZPmnjvBrD+M378MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656786; c=relaxed/simple;
	bh=43UO6coSkkTB1IE2wASNAQswXM+nuk8+gNChEBhhetk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNFECcvLR9+HnJ85V7HkdNCNWzzQwrZn2KcEBw8B8vcFeqyEAS4I5Xq+V3FTqes3TaXb8AUvph8efgKQoPnj7QAyfGSjn7gV6y9hXsmWSvDE34Lb00cE9rE9hRk4wCuQRyWzIPSf1oexPrNLDZo2lP+qcZxC3rAB3VLpBeWTmxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyt+aVtc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyt+aVtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACB11F000E9;
	Tue, 21 Jul 2026 17:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656784;
	bh=C6ksqRvaOeBCTYQJATreEZ/Zi2cEh+UXLLs2/TLynI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wyt+aVtcsGSZFIo8bkPQdOyJEcdU59oOr9/7p9rbp4QTBPhKMsTtAb48eAhgxfS91
	 R/JbKt5o9bLO7bd9jsDoYfviwNaJeL8ZWVKVXsH8+yYv9vlZvITjDHC+oauBkZdOeM
	 mhUeTDsC3Hjz5hcZwsk6b9z4mXdSyWy8Qziv7jP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0464/1611] s390/process: Fix kernel thread function pointer type
Date: Tue, 21 Jul 2026 17:09:40 +0200
Message-ID: <20260721152525.751314414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit d0478f5d3cba1095bfdeb43a9b063c10cdebef14 ]

In case of a kernel thread __ret_from_fork() calls the specified function
indirectly. Fix the kernel thread function pointer, since kernel threads
return an int instead of void.

Fixes: 56e62a737028 ("s390: convert to generic entry")
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index b107dbca4ed7df..f18d7716c43425 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -51,7 +51,7 @@ void ret_from_fork(void) asm("ret_from_fork");
 
 void __ret_from_fork(struct task_struct *prev, struct pt_regs *regs)
 {
-	void (*func)(void *arg);
+	int (*func)(void *arg);
 
 	schedule_tail(prev);
 
-- 
2.53.0



