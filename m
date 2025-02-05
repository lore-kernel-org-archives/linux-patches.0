Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEE61E89C;
	Wed,  5 Feb 2025 14:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767532; cv=none; b=Zdww41+gk2njr1UMGHNBLPG+HVBYp5K2FIvvgDTGHGnWvO0zG/HPvPm9U9Aue2N5DYgIRoDTa0mTsBYZtZmQt0o90hu5CCKYDbN1JQ2lXHt1JOFid1IvnsE6guXdi0RA8xBngBpqZTsARL0ZqQ/9so9Mh1uOhH/8PR4cMfP63Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767532; c=relaxed/simple;
	bh=6ug3ZpMa8LHSacY12BJSrovdP25OM7hSZAsiy15f9Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHa3ndUMPRVGvAUaX+7F8JnB4V1FCAWufHC2uHmk92YPYNihHGaYnI+gcrGs9prKfEdeiFWIszFIXKBrcT9cozNBE2qAEExuo7GNXvtPRduhylb2XsK3YzpRJOdtAY4eNmmBJUPrmGogz5v6tGCATVfG1SU5Lxhf0TTYXtXi2WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJEKdt7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJEKdt7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BF4C4CED1;
	Wed,  5 Feb 2025 14:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767531;
	bh=6ug3ZpMa8LHSacY12BJSrovdP25OM7hSZAsiy15f9Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJEKdt7WFkLqBXFxg+KEvrXbAzOXxia9SXQlCjF/09eG5P5NMqWAeIqCPGDKrHa0w
	 vvl2PuZPeg5cxUKeoq7AO53FHC62snpMr6BXtvkUI6gl7oHC+do6ko+v65DKt2i5Qw
	 FIZqxvhxAjdls/+Zb70wTgzl6A4gcXtcRsE/5Y4w=
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
Subject: [PATCH 6.12 447/590] module: Extend the preempt disabled section in dereference_symbol_descriptor().
Date: Wed,  5 Feb 2025 14:43:22 +0100
Message-ID: <20250205134512.370195888@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c3f075e8f60cb..1c6a6c1704d8d 100644
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



