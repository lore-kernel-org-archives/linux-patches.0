Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4A43A9D94;
	Tue, 16 Jun 2026 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622302; cv=none; b=SKgnSzDQmZchzoP93lJsUDNLmZ3K9vGzMM6CNPmR3NQ5SHqmZKhlG2cb8JreY/65bhZxqpB39Cxa9jwMqePhCLiOjg667u71Nqzd0jikPyqTR/1Q3HfR1yTQhLIW+DtuzSUv/8cEnAk5Qwf1o/P/iPNoLZ07qnUY+f711WFEzn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622302; c=relaxed/simple;
	bh=Fum+62qEJk0Uja4sR7So94wyGrEk4j+Zlps66fsffgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQ3QnGa/e4IaJ9fi24IJBQ0IISPlYmji6npVLecnw9aepNU/ZeOOZKUNh4COqFwdsFthZcnnytmBrFmYVK5lHVjkZrXJgUgc1aNt7h6AuJZOVnqrwlJe9W8AlFEvcUIOM2+7zb3avmJ5YreiwKdeMqnwD8/wOrM49Yk7HMKLVC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNnnteJp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNnnteJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9897E1F000E9;
	Tue, 16 Jun 2026 15:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622301;
	bh=Jmx4mJ6V9g+imjCH/f40yhzKJUIYXfT0oRb9A+HIm/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pNnnteJp0M5aEwlfhLsVSuTHvZbtfbgp3X8KmexUC55AfGt2cLPzVUoCy7rFbOQzJ
	 WDzIFo5j0Xm08eh5QnXlbKICh0IlhuvvHYorUMOVq4AfcVKMhmgUmo47lQw7mHyqs4
	 SVw6zFWabgfF4wuVNy0dhv2Rvd9yIATVZzQRp5ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/325] ARM: allow __do_kernel_fault() to report execution of memory faults
Date: Tue, 16 Jun 2026 20:26:39 +0530
Message-ID: <20260616145057.989124303@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 40b466db1dffb41f0529035c59c5739636d0e5b8 upstream.

Allow __do_kernel_fault() to detect the execution of memory, so we can
provide the same fault message as do_page_fault() would do. This is
required when we split the kernel address fault handling from the
main do_page_fault() code path.

Reviewed-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Tested-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/fault.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index f87f353e5a8b0a..192c8ab196dbab 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -175,6 +175,8 @@ __do_kernel_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
 	 */
 	if (addr < PAGE_SIZE) {
 		msg = "NULL pointer dereference";
+	} else if (is_permission_fault(fsr) && fsr & FSR_LNX_PF) {
+		msg = "execution of memory";
 	} else {
 		if (is_translation_fault(fsr) &&
 		    kfence_handle_page_fault(addr, is_write_fault(fsr), regs))
-- 
2.53.0



