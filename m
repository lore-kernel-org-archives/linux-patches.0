Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F6533CD1;
	Fri, 24 Nov 2023 18:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjMoTcvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADECBC433C7;
	Fri, 24 Nov 2023 18:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852227;
	bh=JIU44eoLhHKSBFymy4/Rek9l9yrJBWA8ECcZd6xONEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjMoTcvipLS1k9UZ+JYuTmqLGf/oMRQRF4tN6gYE24csDSYWs9WyIkp/az/XmIJLc
	 ElzExlA9sdSmGQx62bG8HBP3c/xKLZzOikQBE24tBNzetV/94svTD9lv28Wgvkrbon
	 nWQt8Rti59VuPFdrZUvabGw6X9e5i1O3ktesS5YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	kernel test robot <lkp@intel.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 246/372] tracing: Have the user copy of synthetic event address use correct context
Date: Fri, 24 Nov 2023 17:50:33 +0000
Message-ID: <20231124172018.737112780@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 4f7969bcd6d33042d62e249b41b5578161e4c868 upstream.

A synthetic event is created by the synthetic event interface that can
read both user or kernel address memory. In reality, it reads any
arbitrary memory location from within the kernel. If the address space is
in USER (where CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE is set) then
it uses strncpy_from_user_nofault() to copy strings otherwise it uses
strncpy_from_kernel_nofault().

But since both functions use the same variable there's no annotation to
what that variable is (ie. __user). This makes sparse complain.

Quiet sparse by typecasting the strncpy_from_user_nofault() variable to
a __user pointer.

Link: https://lore.kernel.org/linux-trace-kernel/20231031151033.73c42e23@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Fixes: 0934ae9977c2 ("tracing: Fix reading strings from synthetic events");
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311010013.fm8WTxa5-lkp@intel.com/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_synth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -473,7 +473,7 @@ static unsigned int trace_string(struct
 
 #ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 		if ((unsigned long)str_val < TASK_SIZE)
-			ret = strncpy_from_user_nofault(str_field, str_val, STR_VAR_LEN_MAX);
+			ret = strncpy_from_user_nofault(str_field, (const void __user *)str_val, STR_VAR_LEN_MAX);
 		else
 #endif
 			ret = strncpy_from_kernel_nofault(str_field, str_val, STR_VAR_LEN_MAX);


