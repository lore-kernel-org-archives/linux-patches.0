Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386FC1A5BBB;
	Tue, 29 Apr 2025 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950124; cv=none; b=P+boZNNE/gxd02etH7kwRetKVcJ51pB4j6QF+9U8iDQhRPjQPyctXAV5qvlRaVMuqBa8weas2+q5UthIw4t+Bm8TjOuHQ70XITQsjJDWjp23d71ez5FZtRBB5rcoFoFuF7zQVuZAwbWFYI1iNx4jglHDEZfIbaQUdokCg/umRrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950124; c=relaxed/simple;
	bh=A53u3FrEJ3GfYnXWWZ1sGgbPMF1QxKRa8BitI76irHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkgcDdSp8618xaHkCVsw4lJMeYvVDQ/bExtXhKyp/Oyw7HmPPPw4j5tP6CEBaCLF7/BxW+1ZosW0Qgvq0cC/AXQaB5qLqdl7DsqalXxEPk/Dyeg5ZR09YFaUgbYiZUVQKWaM/uDjV+cLyHXYpCcTz8aZiExc5ivHdiI5FNPlVyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0UzMZVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0UzMZVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CDDC4CEE3;
	Tue, 29 Apr 2025 18:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950124;
	bh=A53u3FrEJ3GfYnXWWZ1sGgbPMF1QxKRa8BitI76irHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0UzMZVOF7Rb3aUO1R4XrYwUwS75G/oNTRSRzWchQRy8AfiQjzUWkJA9UG1K+hQCs
	 fkthiskmMl6fvEV0IcU/nQ5ubgN7NIqDM8eqw8OKUYx5FFsaZ6RJu0At5A0RFDgUl5
	 MetqrG0RM6Xx/k8X53TvckD+R756VzMboZkBbJyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Douglas Raillard <douglas.raillard@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 164/167] tracing: Remove pointer (asterisk) and brackets from cpumask_t field
Date: Tue, 29 Apr 2025 18:44:32 +0200
Message-ID: <20250429161058.359062999@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit fab89a09c86f948adfc7e20a7d608bd9f323bbe1 upstream.

To differentiate between long arrays and cpumasks, the __cpumask() field
was created. Part of the TRACE_EVENT() macros test if the type is signed
or not by using the is_signed_type() macro. The __cpumask() field used the
__dynamic_array() helper but because cpumask_t is a structure, it could
not be used in the is_signed_type() macro as that would fail to build, so
instead it passed in the pointer to cpumask_t.

Unfortunately, that creates in the format file:

  field:__data_loc cpumask_t *[] mask;    offset:36;      size:4; signed:0;

Which looks like an array of pointers to cpumask_t and not a cpumask_t
type, which is misleading to user space parsers.

Douglas Raillard pointed out that the "[]" are also misleading, as
cpumask_t is not an array.

Since cpumask() hasn't been created yet, and the parsers currently fail on
it (but will still produce the raw output), make it be:

  field:__data_loc cpumask_t mask;    offset:36;      size:4; signed:0;

Which is the correct type of the field.

Then the parsers can be updated to handle this.

Link: https://lore.kernel.org/lkml/6dda5e1d-9416-b55e-88f3-31d148bc925f@arm.com/
Link: https://lore.kernel.org/linux-trace-kernel/20221212193814.0e3f1e43@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 8230f27b1ccc ("tracing: Add __cpumask to denote a trace event field that is a cpumask_t")
Reported-by: Douglas Raillard <douglas.raillard@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/stages/stage4_event_fields.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/include/trace/stages/stage4_event_fields.h
+++ b/include/trace/stages/stage4_event_fields.h
@@ -48,7 +48,10 @@
 #define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
 
 #undef __cpumask
-#define __cpumask(item) __dynamic_array(cpumask_t *, item, -1)
+#define __cpumask(item) {						\
+	.type = "__data_loc cpumask_t", .name = #item,			\
+	.size = 4, .align = 4,						\
+	.is_signed = 0, .filter_type = FILTER_OTHER },
 
 #undef __sockaddr
 #define __sockaddr(field, len) __dynamic_array(u8, field, len)
@@ -69,7 +72,10 @@
 #define __rel_bitmask(item, nr_bits) __rel_dynamic_array(unsigned long, item, -1)
 
 #undef __rel_cpumask
-#define __rel_cpumask(item) __rel_dynamic_array(cpumask_t *, item, -1)
+#define __rel_cpumask(item) {						\
+	.type = "__rel_loc cpumask_t", .name = #item,			\
+	.size = 4, .align = 4,						\
+	.is_signed = 0, .filter_type = FILTER_OTHER },
 
 #undef __rel_sockaddr
 #define __rel_sockaddr(field, len) __rel_dynamic_array(u8, field, len)


