Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB14320A00;
	Mon, 27 Oct 2025 18:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591531; cv=none; b=O8KkqSULVsFYlLN0BZJj1bnuvEChpePPjpitTXQHc9b9A5wbco59bKtnFaQvSWXPIvxt5N99HGpGd6wa7+nXHwcNhLhdQ8/pl3BxG5zxivlbLfjgCSFMPoqwhvwjqkLqW+S4uA8R6JY8+cvQgUJG95+tPdW+H57r3fxuiuJDbfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591531; c=relaxed/simple;
	bh=c+qDXSQQm6c3mutdKHQS8Z1Xl1+N/CDye03pg2SH9MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7Ns4SstW665nhTBFvSgDcwpDGsADhdVcRAbG7tAgNv132OHm6FgpUMxenErhEh1AACx+yeGmeYVmE1cdthug7Jvi2GCE5Kkt/cLBztgdQQsFoRnXeSfhlSl/9/8cgWL31VSeG3J7/pE1JbD6+M3dTbtPju3Gci+D5EyTIUPqoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ti/1nyfv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ti/1nyfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D52FC4CEF1;
	Mon, 27 Oct 2025 18:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591530;
	bh=c+qDXSQQm6c3mutdKHQS8Z1Xl1+N/CDye03pg2SH9MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ti/1nyfvOd6wy6xS+wydctU92UqLo+f5d6+pPbIgUgPnD519Omc1J6nA9KTiFwzry
	 0dfn4NUTQ6rUsECrSudvW+22jzBMcwSJSR7U80Gsvwy8kQ//2zNsivPkVpDuFZKJZ9
	 zWNUucqRBDpvV0dOK+E+LjTtSMAuzJG1F8VUzPrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Eric Dumazet <edumazet@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Isabella Basso <isabbasso@riseup.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sander Vanheule <sander@svanheule.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yury Norov <yury.norov@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Kees Cook <keescook@chromium.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 5.10 194/332] overflow, tracing: Define the is_signed_type() macro once
Date: Mon, 27 Oct 2025 19:34:07 +0100
Message-ID: <20251027183529.816948999@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 92d23c6e94157739b997cacce151586a0d07bb8a ]

There are two definitions of the is_signed_type() macro: one in
<linux/overflow.h> and a second definition in <linux/trace_events.h>.

As suggested by Linus Torvalds, move the definition of the
is_signed_type() macro into the <linux/compiler.h> header file. Change
the definition of the is_signed_type() macro to make sure that it does
not trigger any sparse warnings with future versions of sparse for
bitwise types. See also:
https://lore.kernel.org/all/CAHk-=whjH6p+qzwUdx5SOVVHjS3WvzJQr6mDUwhEyTf6pJWzaQ@mail.gmail.com/
https://lore.kernel.org/all/CAHk-=wjQGnVfb4jehFR0XyZikdQvCZouE96xR_nnf5kqaM5qqQ@mail.gmail.com/

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Isabella Basso <isabbasso@riseup.net>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sander Vanheule <sander@svanheule.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220826162116.1050972-3-bvanassche@acm.org
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler.h     |    6 ++++++
 include/linux/overflow.h     |    1 -
 include/linux/trace_events.h |    2 --
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -246,6 +246,12 @@ static inline void *offset_to_ptr(const
 #define __must_be_array(a)	BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
 
 /*
+ * Whether 'type' is a signed type or an unsigned type. Supports scalar types,
+ * bool and also pointer types.
+ */
+#define is_signed_type(type) (((type)(-1)) < (__force type)1)
+
+/*
  * This is needed in functions which generate the stack canary, see
  * arch/x86/kernel/smpboot.c::start_secondary() for an example.
  */
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -29,7 +29,6 @@
  * https://mail-index.netbsd.org/tech-misc/2007/02/05/0000.html -
  * credit to Christian Biere.
  */
-#define is_signed_type(type)       (((type)(-1)) < (type)1)
 #define __type_half_max(type) ((type)1 << (8*sizeof(type) - 1 - is_signed_type(type)))
 #define type_max(T) ((T)((__type_half_max(T) - 1) + __type_half_max(T)))
 #define type_min(T) ((T)((T)-type_max(T)-(T)1))
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -700,8 +700,6 @@ extern int trace_add_event_call(struct t
 extern int trace_remove_event_call(struct trace_event_call *call);
 extern int trace_event_get_offsets(struct trace_event_call *call);
 
-#define is_signed_type(type)	(((type)(-1)) < (type)1)
-
 int ftrace_set_clr_event(struct trace_array *tr, char *buf, int set);
 int trace_set_clr_event(const char *system, const char *event, int set);
 int trace_array_set_clr_event(struct trace_array *tr, const char *system,


