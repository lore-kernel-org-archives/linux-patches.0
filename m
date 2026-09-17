Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8964848B1;
	Thu, 17 Sep 2026 18:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670955; cv=none; b=Bf2iIXoTSKxsE47g3nm/3/GOo2bt09WBfn3X2gVCyq89mQShbQyZa9DDt2wvp3qoz6BcdK9rPkxBrL/VS1iqqABHFuRp69q8ljavNs+l/3O/uoXYcnctfwuN5SKNI2nSoxWyiG3C27Wv6t7JwKxQFemJY1Vl/s/WjXOyVV+obAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670955; c=relaxed/simple;
	bh=OPunzSYDtNPDBrABAThy6uaeQpJ2S8Pc1YQzNr5kfHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrH/xEFMP3h1LSi9b6I28fa52FSSi3QJeRz4bCQUpVqGh/wipiRhhGNXgRstpDjS4RT4NO9+Z4lsDls7nMzovomysMi8KHE0vM+ABvWtC3tZsDs0FjQfgRoPZ91TlcsedEO0zB2LppNh6nquhdITfq6t+IP3LtImWBfZxumBaAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZA8Dj27v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZA8Dj27v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D741F000FF;
	Thu, 17 Sep 2026 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670954;
	bh=aBOjRf09MOKWrPq234vnvTpOj4SJs3hU3t24lXUtJmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZA8Dj27voAO2GAd4iiFjDdLxh4bKYnATV3RAeN/vhUKYv6aIN9t0ToVEOw+0VQdaU
	 gC+dTpOYDc3xyUZt/AJX/4bn4UJYmxse8sJ9zpsPyLkKi4tIRgjVLmIcyXarPTKNAB
	 NyagiUk3TUdrEYurI7Z9g0v4EoNiC/Vqs5f4iXpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 0823/1102] tracing: Let histogram values keep the percent and graph modifiers
Date: Thu, 17 Sep 2026 16:12:46 +0100
Message-ID: <20260917151601.166979220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

commit 3d617bfd79330ae3acf94862c18bb3ccf5f5a0f9 upstream.

The .percent and .graph modifiers exist only for histogram values, but a
value carrying either of them has been rejected since v6.3. The example
in Documentation/trace/histogram.rst,

  # echo 'hist:keys=prev_comm:vals=hitcount.percent:nohitcount' > \
	 events/sched/sched_switch/trigger

returns -EINVAL.

parse_field() sets the two flags only when the field is neither a key nor
a variable, that is, only on a value:

	} else if (strncmp(modifier, "percent", 7) == 0) {
		if (*flags & (HIST_FIELD_FL_VAR | HIST_FIELD_FL_KEY))
			goto error;
		*flags |= HIST_FIELD_FL_PERCENT;

__create_val_field() then rejects a value for carrying them, so no field
can reach hist_trigger_print_val(), where both are implemented.

commit e0213434fe3e ("tracing: Do not let histogram values have some
modifiers") added the check after a value with .buckets oopsed in
hist_field_name(). That happens because .buckets and .log2 make
create_hist_field() build a nested field in operands[0] which
hist_field_name() then walks into. The percent and graph flags do not
create an operand and are not read by hist_field_name(); they are only
used when printing a value.

Stop rejecting the two flags on a value. The check for variables is left
alone, where they are unreachable anyway because parse_field() rejects a
variable carrying them first.

With the two flags removed, the trigger above installs and prints as
documented:

  { prev_comm: rcu_preempt  }  hitcount (%):   0.00
  { prev_comm: init         }  hitcount (%):  99.98
  Totals:
      Hits: 237896

Cc: stable@vger.kernel.org
Fixes: e0213434fe3e ("tracing: Do not let histogram values have some modifiers")
Link: https://patch.msgid.link/20260907052113.430818-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -4265,8 +4265,7 @@ static int __create_val_field(struct his
 			goto err;
 	} else {
 		/* Value */
-		if (hist_field->flags & (HIST_FIELD_FL_GRAPH | HIST_FIELD_FL_PERCENT |
-					 HIST_FIELD_FL_BUCKET | HIST_FIELD_FL_LOG2 |
+		if (hist_field->flags & (HIST_FIELD_FL_BUCKET | HIST_FIELD_FL_LOG2 |
 					 HIST_FIELD_FL_SYM | HIST_FIELD_FL_SYM_OFFSET |
 					 HIST_FIELD_FL_SYSCALL | HIST_FIELD_FL_STACKTRACE))
 			goto err;


