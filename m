Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A6E51B196;
	Wed, 30 Sep 2026 17:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790102; cv=none; b=jwlQL2i5DA4OkaIjIpxRu478/bTJ5JjV9aNWycvRL3giZm869Vd0ub9pDXup7YvBu8IlA8+H4bBpTS0BfogtnLWU0+txkOYNBNeHyK1a6t0VorkpeLlOcrGhlv0t+c11yUyintK/aRb1JPrdEprcNf0uuo0RSPR4V8kz+TPEk98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790102; c=relaxed/simple;
	bh=amf9mDnWcu+0+qS93U+RIxfbqAlDGTUh+fDaGP6wi4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lla7aNWAWlBQ9UDMjo9JS8F+5h9BAtwGetVf/vK/9DRGnMgscbD4s+eI8SHM7+Apyu+o5ehAnv4wuSGBgLyWYy3glmqDlBFGL9xrlk5YNT6qsV13QVjqSJ2gkV/jUWEPgtbjzQytULBVCsnwRWT9DFwQrtsnuWQvbeHl1dqT/bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1g/sqwT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1g/sqwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D6E1F000FF;
	Wed, 30 Sep 2026 17:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790101;
	bh=JL97SPYypnBNjeQ+eX6JQlnq/uvK8ODd3EbZH3tBpbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1g/sqwThcwjxS/Rr4LLD2ZG4oG8faJ+ZqtvhmMjtCNFb8/2tF0K2B++NSySCwClo
	 6phHDaZ6xcB4XCwRQiT2/oEMZQ+RUk6hP4HonPcsWfTRqZ40jOeq0ji4HbMPkp0VXx
	 XGKtYCW1PGaJZ2zt4w54M4pqJQG9EZeaC320vj1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 711/877] tracing: Fix memory corruption from a "STACKTRACE" histogram key
Date: Wed, 30 Sep 2026 17:27:02 +0200
Message-ID: <20260930152430.027023980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 7f711e62355bb3123a2ca2f97a2facbfebc678c6 ]

"cpu", "CPU", "stacktrace" and "STACKTRACE" are generic fields, defined
with an offset and a size of zero so that the filter code can match them
by name. parse_field() maps them onto their common_* equivalents for
backward compatibility, but unlike the common_* names it hands the
placeholder back to the caller instead of NULL.

create_hist_field() takes a non-NULL field as a promise that the record
carries a stacktrace and picks HIST_FIELD_FN_STACK, so the __data_loc
word is read from offset 0, that is from common_type, and its low 16
bits are followed as an offset into the record. What is found there
becomes the length of an unbounded memcpy. Pick an event whose id is
small enough that the offset stays inside its own record and the length
is a kernel text address:

  # cd /sys/kernel/tracing
  # echo 'hist:keys=STACKTRACE' > events/ftrace/print/trigger
  # echo hello > trace_marker

  Oops: general protection fault, probably for non-canonical address
  RIP: 0010:rb_next+0x23/0x60
   </IRQ>
  RIP: 0010:memcpy+0xc/0x30
   event_hist_trigger+0x2e7/0x12c0
  Kernel panic - not syncing: Fatal exception in interrupt

Leave the field NULL, which is what the comment above the branch says
the code does and what common_stacktrace already does. FILTER_CPU and
FILTER_COMM are left alone, their create_hist_field() branches never
look at the field.

Cc: stable@vger.kernel.org
Fixes: 4b512860bdbd ("tracing: Rename stacktrace field to common_stacktrace")
Link: https://patch.msgid.link/20260907155045.692664-3-donggeunyoo.kernel@gmail.com
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ Adjusted context for the missing FILTER_COMM branch in parse_field(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2379,6 +2379,7 @@ parse_field(struct hist_trigger_data *hi
 				*flags |= HIST_FIELD_FL_CPU;
 			} else if (field && field->filter_type == FILTER_STACKTRACE) {
 				*flags |= HIST_FIELD_FL_STACKTRACE;
+				field = NULL;
 			} else {
 				hist_err(tr, HIST_ERR_FIELD_NOT_FOUND,
 					 errpos(field_name));


