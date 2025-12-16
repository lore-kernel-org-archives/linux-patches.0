Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C6A24E4C6;
	Tue, 16 Dec 2025 12:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887470; cv=none; b=Q1mCrwloqW+h9DxNy5EalHFLx76S0Ak1jEOKi4rZsPZtQDXHImSXxFC6BK6MEbs5D14K0GqW54les6xVoN6gKOV4dEi7m+xYNUPz44ISFnZEplfzuf5dwA/Sz1jMyykPbxMRcbXrJTk61Xe1wsbG98VuayhTMRx8uySnNmj7VV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887470; c=relaxed/simple;
	bh=S96FJ54ZeYGGfVIxvfL8cGFuOTGMzGy/ohpOUOypMK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4LNX0TcV6qZxHFdvLqe3/HuEDYAGzjdfCH4IAuy2xMT69ziZq+DEe9sl4WcMLwz0QKKpvi265EkfQkvagSw55JanBud9LjnC9oQY0JZWek/z35Hb5BzDu7bdHhH6t7lFi9VzKArYHG0tkEtqVzPYZ4d9MsBOeGcZ16KW8SaGpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3cKtQrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3cKtQrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35361C4CEF1;
	Tue, 16 Dec 2025 12:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887470;
	bh=S96FJ54ZeYGGfVIxvfL8cGFuOTGMzGy/ohpOUOypMK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3cKtQrzHr/geu9b7t7YBdLn0Sv2pwGP7SkBjeUtSTutdzgOYVuTB3MWg1s6mstXQ
	 o+hEwq7m2C6tbFNFkt2ZIcwXRJGWFlTuO5joR7GUbqOVvFIGe0DxfaFZgscyfEbTzZ
	 OkmoJGh1baAw4sjLiXfgnT8xg6V4d/yeCej9D8hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Ingo Molnar <mingo@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 207/614] entry,unwind/deferred: Fix unwind_reset_info() placement
Date: Tue, 16 Dec 2025 12:09:34 +0100
Message-ID: <20251216111408.875727821@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit cf76553aaa363620f58a6b6409bf544f4bcfa8de ]

Stephen reported that on KASAN builds he's seeing:

vmlinux.o: warning: objtool: user_exc_vmm_communication+0x15a: call to __kasan_check_read() leaves .noinstr.text section
vmlinux.o: warning: objtool: exc_debug_user+0x182: call to __kasan_check_read() leaves .noinstr.text section
vmlinux.o: warning: objtool: exc_int3+0x123: call to __kasan_check_read() leaves .noinstr.text section
vmlinux.o: warning: objtool: noist_exc_machine_check+0x17a: call to __kasan_check_read() leaves .noinstr.text section
vmlinux.o: warning: objtool: fred_exc_machine_check+0x17e: call to __kasan_check_read() leaves .noinstr.text section

This turns out to be atomic ops from unwind_reset_info() that have
explicit instrumentation. Place unwind_reset_info() in the preceding
instrumentation_begin() section.

Fixes: c6439bfaabf2 ("Merge tag 'trace-deferred-unwind-v6.17' of git://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20251105100014.GY4068168@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irq-entry-common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/irq-entry-common.h b/include/linux/irq-entry-common.h
index d643c7c87822e..ba1ed42f8a1c2 100644
--- a/include/linux/irq-entry-common.h
+++ b/include/linux/irq-entry-common.h
@@ -253,11 +253,11 @@ static __always_inline void exit_to_user_mode_prepare(struct pt_regs *regs)
 static __always_inline void exit_to_user_mode(void)
 {
 	instrumentation_begin();
+	unwind_reset_info();
 	trace_hardirqs_on_prepare();
 	lockdep_hardirqs_on_prepare();
 	instrumentation_end();
 
-	unwind_reset_info();
 	user_enter_irqoff();
 	arch_exit_to_user_mode();
 	lockdep_hardirqs_on(CALLER_ADDR0);
-- 
2.51.0



