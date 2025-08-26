Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5D52139C9;
	Tue, 26 Aug 2025 13:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215546; cv=none; b=OAO1R+fF2IGQpTwd3+7JAQSCC56HnM3r6K7uT/ykWyaFSSVP0kDTHMWHomNov4J2d4IaHETEyg36B1uEMDc+NOP+tgNLSRFiz6sT+oxdLzAf0yRdS0jYknkC9GG6MRmP3i89Q3HGW4WHGSpTTkO72BOs8mXPIYRjxNUoKh6ssOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215546; c=relaxed/simple;
	bh=Z4Pjnq+vWZchiNBQO1YRGaXXAZBhbwr2oQuIuYl95EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rfxi/6jrtO+CkJxh1A64SeSN0yYVGuXgBnHWVA/v0JFwPwgz3xhPCKfdMKdyvLZqQYMI7ELLyPJNt6wsfxT+ttPc3UyObEUZj+MifiVh4xCnbXNexKBAN1MuAo3i9pgCgd6s2UJtKYaKLW5TILZf3xqWRIWKpsNWpoQYlsXQa38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yj/Br2gQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yj/Br2gQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7426AC4CEF1;
	Tue, 26 Aug 2025 13:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215546;
	bh=Z4Pjnq+vWZchiNBQO1YRGaXXAZBhbwr2oQuIuYl95EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yj/Br2gQdgi5ApN+Qu+9tZsVGfGZHj5gGeMhNgAIy60F+aIkQZCbn1NBTaotcWYgx
	 Jbwf3Td0U7V7uk/XzHDX12WpeKdeyve0lTup8C4Sl1Nl91wsXj80/Hc0LNhcl+tgpz
	 M13Yvptpdg/dYIIm1B7Nale2zxPXwIDBPJfcMZcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Justin Forbes <jmforbes@linuxtx.org>,
	=?UTF-8?q?Holger=20Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Siddhi Katage <siddhi.katage@oracle.com>
Subject: [PATCH 5.15 075/644] x86: Pin task-stack in __get_wchan()
Date: Tue, 26 Aug 2025 13:02:46 +0200
Message-ID: <20250826110948.356842368@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 0dc636b3b757a6b747a156de613275f9d74a4a66 upstream.

When commit 5d1ceb3969b6 ("x86: Fix __get_wchan() for !STACKTRACE")
moved from stacktrace to native unwind_*() usage, the
try_get_task_stack() got lost, leading to use-after-free issues for
dying tasks.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Fixes: 5d1ceb3969b6 ("x86: Fix __get_wchan() for !STACKTRACE")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215031
Link: https://lore.kernel.org/stable/YZV02RCRVHIa144u@fedora64.linuxtx.org/
Reported-by: Justin Forbes <jmforbes@linuxtx.org>
Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Siddhi Katage <siddhi.katage@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/process.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -975,6 +975,9 @@ unsigned long __get_wchan(struct task_st
 	struct unwind_state state;
 	unsigned long addr = 0;
 
+	if (!try_get_task_stack(p))
+		return 0;
+
 	for (unwind_start(&state, p, NULL, NULL); !unwind_done(&state);
 	     unwind_next_frame(&state)) {
 		addr = unwind_get_return_address(&state);
@@ -985,6 +988,8 @@ unsigned long __get_wchan(struct task_st
 		break;
 	}
 
+	put_task_stack(p);
+
 	return addr;
 }
 


