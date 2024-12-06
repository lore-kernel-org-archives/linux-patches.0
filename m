Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D58149E0E;
	Fri,  6 Dec 2024 14:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496191; cv=none; b=KnpW9Ykzg1RN1kIcwcNmwmnSYdOqaW7/8eWTmopTK5WNxT8UB9t9ydfNSGQTQ3FTMyRiAtEIeZ8mT10fHDsyG89xowaAzDBAzaQNgfL5qBt9IcbNc4o17Ez+sj7Zk6O5HS574SgZ3cNxxnvxmHplaRuHCFfh1DmnPQlNGkUXwqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496191; c=relaxed/simple;
	bh=I0raEAbc7ik7xucTyAiUQ9uk0nvbjZ+jQ5UvS9Jb5HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6ulzTd/yZg3gIATTqbZ6Hzahwq6dxMzEb0VxWA2JjCnv8QnhvIsVgYpvLZ+VyLAQ19bWjR7ohOGDslUhAoIvoC5MtsgHipbyXxDHY7aUWIe5unXga1dlxnaAMak3Bh1e+G528xr6h7gLMqrykmM/fItmT2ky79JmB//e/9NTLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2UY9Sjvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2UY9Sjvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78425C4CEDF;
	Fri,  6 Dec 2024 14:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496190;
	bh=I0raEAbc7ik7xucTyAiUQ9uk0nvbjZ+jQ5UvS9Jb5HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2UY9SjvfyAzUQB9sWh20nDi2nHlG9gZOPx8wUiBolejzctgN9m8XdZLEYGB3NX6Sp
	 pySpfWMNICC+wsXZ37IxR9akr+1+wko9Od7mAdCG9bmr3+sCukkkBbQPCBcyoEy+f5
	 JLtrXTfifACIMASRoOQQ/AdctAI3I/H66uzLDDT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 077/146] s390/stacktrace: Use break instead of return statement
Date: Fri,  6 Dec 2024 15:36:48 +0100
Message-ID: <20241206143530.627380747@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit 588a9836a4ef7ec3bfcffda526dfa399637e6cfc upstream.

arch_stack_walk_user_common() contains a return statement instead of a
break statement in case store_ip() fails while trying to store a callchain
entry of a user space process.
This may lead to a missing pagefault_enable() call.

If this happens any subsequent page fault of the process won't be resolved
by the page fault handler and this in turn will lead to the process being
killed.

Use a break instead of a return statement to fix this.

Fixes: ebd912ff9919 ("s390/stacktrace: Merge perf_callchain_user() and arch_stack_walk_user()")
Cc: stable@vger.kernel.org
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/stacktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index 9f59837d159e..40edfde25f5b 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -151,7 +151,7 @@ void arch_stack_walk_user_common(stack_trace_consume_fn consume_entry, void *coo
 				break;
 		}
 		if (!store_ip(consume_entry, cookie, entry, perf, ip))
-			return;
+			break;
 		first = false;
 	}
 	pagefault_enable();
-- 
2.47.1



