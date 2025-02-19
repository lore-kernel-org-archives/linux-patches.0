Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B501DF732;
	Wed, 19 Feb 2025 09:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956525; cv=none; b=PklGjumUTqoYwt37+bc13qeY+rFCf1HIUGkpD9Mx4XV5BjqAEiFDD1CIwMyoVG32r+nVxTDCcPQG/CrdCZ78bBdi5MniTHvgtTQHxbs9Gzk2z7Vawtw7EhC+r9VsUW1EMW6y92Bdtx1V4DVMf6Ec5JAQ8XZ9BnxY5DCHtgABmL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956525; c=relaxed/simple;
	bh=CsTBlu4PxzMm58+7iDpVQaMfkefep16Cd8DGhQ3z9z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lN9y1zwf86mvbkXGHtOD5PMx2o+hFttw7F8vxTlfFBxe7JhcdL1w2sVzibXaA8gpws8hHbmh8gCfDXGxCdeaPxmlGVn7no3iroBE5jwwkihwGEZRz+BZF4L8+uDexjdNwD83F+IJHiItNVNt0p2/7GWIfkxaLiAMKBaCGzG4pvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8TRMQcE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8TRMQcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156F1C4CEE6;
	Wed, 19 Feb 2025 09:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956525;
	bh=CsTBlu4PxzMm58+7iDpVQaMfkefep16Cd8DGhQ3z9z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8TRMQcELYUxVdPvJ5lCUInj7sehoS/tSEJHfwcgDlEQPwtucx3AA+KBVFj1bOx7d
	 xuDoCnYn0UHEI29pXCaKs5+wJTVIPUq0deaPX4q5qcZ0y5RBjuES/3cDmerKfl79HM
	 5nBe1SaYkDKv0EKvPyg3TaD2mCXTdekq+9UOcRJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Naveen N Rao <naveen@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/578] module: Extend the preempt disabled section in dereference_symbol_descriptor().
Date: Wed, 19 Feb 2025 09:23:31 +0100
Message-ID: <20250219082701.205158327@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit a145c848d69f9c6f32008d8319edaa133360dd74 ]

dereference_symbol_descriptor() needs to obtain the module pointer
belonging to pointer in order to resolve that pointer.
The returned mod pointer is obtained under RCU-sched/ preempt_disable()
guarantees and needs to be used within this section to ensure that the
module is not removed in the meantime.

Extend the preempt_disable() section to also cover
dereference_module_function_descriptor().

Fixes: 04b8eb7a4ccd9 ("symbol lookup: introduce dereference_symbol_descriptor()")
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Helge Deller <deller@gmx.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: linux-parisc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20250108090457.512198-2-bigeasy@linutronix.de
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kallsyms.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 0cd33be7142ad..6d10bd2b9e0fe 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -57,10 +57,10 @@ static inline void *dereference_symbol_descriptor(void *ptr)
 
 	preempt_disable();
 	mod = __module_address((unsigned long)ptr);
-	preempt_enable();
 
 	if (mod)
 		ptr = dereference_module_function_descriptor(mod, ptr);
+	preempt_enable();
 #endif
 	return ptr;
 }
-- 
2.39.5



