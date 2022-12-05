Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275C215C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9B8C433D7;
	Mon,  5 Dec 2022 19:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268650;
	bh=HYYj7R+g9Rr+JE+q8CsL4XZOt3TzagA13sj+0FZvd6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2UNM4WX4sDlIr58QqaN3lx5i1gIvTbc65v0VRL8darOoj3K2HvV6aQ/Q9lf70c3n
	 Qqr6t4+sxJdw581Me99D9GBWcqt75cKghiw18001xmjyfddPh/1i9LnB6tkV+OwMWH
	 aYmXWt5DHiuN/+aPsoXP4Db66whGA2M6gtbcqITg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 55/92] error-injection: Add prompt for function error injection
Date: Mon,  5 Dec 2022 20:10:08 +0100
Message-Id: <20221205190805.333088072@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit a4412fdd49dc011bcc2c0d81ac4cab7457092650 upstream.

The config to be able to inject error codes into any function annotated
with ALLOW_ERROR_INJECTION() is enabled when FUNCTION_ERROR_INJECTION is
enabled.  But unfortunately, this is always enabled on x86 when KPROBES
is enabled, and there's no way to turn it off.

As kprobes is useful for observability of the kernel, it is useful to
have it enabled in production environments.  But error injection should
be avoided.  Add a prompt to the config to allow it to be disabled even
when kprobes is enabled, and get rid of the "def_bool y".

This is a kernel debug feature (it's in Kconfig.debug), and should have
never been something enabled by default.

Cc: stable@vger.kernel.org
Fixes: 540adea3809f6 ("error-injection: Separate error-injection from kprobe")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Kconfig.debug |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1801,8 +1801,14 @@ config NETDEV_NOTIFIER_ERROR_INJECT
 	  If unsure, say N.
 
 config FUNCTION_ERROR_INJECTION
-	def_bool y
+	bool "Fault-injections of functions"
 	depends on HAVE_FUNCTION_ERROR_INJECTION && KPROBES
+	help
+	  Add fault injections into various functions that are annotated with
+	  ALLOW_ERROR_INJECTION() in the kernel. BPF may also modify the return
+	  value of theses functions. This is useful to test error paths of code.
+
+	  If unsure, say N
 
 config FAULT_INJECTION
 	bool "Fault-injection framework"


