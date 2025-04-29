Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA68F245007;
	Tue, 29 Apr 2025 17:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947260; cv=none; b=ZMCZ2Kp2KfMuzO4GND4PD4vJJclCVrvmmF9oeWuX9GUgPg5qCsnn6A+H+6j2At5IhTHvGiSkMtBx0vFLglC5nwaLvsZ/4yGFWkfNrOsktbVE/QjaRt24+RryzaZraSs+TRtq5wvkbrX186FJ6wCgANK5drb1HbHh/3iU6IOjTDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947260; c=relaxed/simple;
	bh=0wan7wTzfs6I0+86HrgXeZVyH51tPsR0UfgQSJIPG60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSKsdxtfRXW61cGMtFXbfq94dfeXjJyWZyjJJVOdXTIASUaNiOByTYA+oed3UljJDYbLQ2vBJZuT5yxvWef9mOj+CjSUW5WMZNcrjGAQyvOY1pMqOtitML+8q6YlXlgw2hcx0LnweJL5E2CkPLXn8DJZL7PmEHGUZZSOFqHK/L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyhk+gC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyhk+gC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEF7C4CEE3;
	Tue, 29 Apr 2025 17:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947260;
	bh=0wan7wTzfs6I0+86HrgXeZVyH51tPsR0UfgQSJIPG60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyhk+gC022GtFJaUuVfD9irbrCouBWJ6kId5uzqr+2kBxwI7zsT5tFKZ1SYfhlfr7
	 eBBZywkRrmKf7CGSH74gBhRMvazsA6U8cbpH9eoGidCNz+FTpRT2Diq1gSNakLKHnb
	 miCCyS+Qg1HQ7feTogj5yI5Q+EYtoqQp1Z2UgCcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Douglas Raillard <douglas.raillard@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/286] tracing: Fix synth event printk format for str fields
Date: Tue, 29 Apr 2025 18:41:40 +0200
Message-ID: <20250429161116.026183122@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Raillard <douglas.raillard@arm.com>

[ Upstream commit 4d38328eb442dc06aec4350fd9594ffa6488af02 ]

The printk format for synth event uses "%.*s" to print string fields,
but then only passes the pointer part as var arg.

Replace %.*s with %s as the C string is guaranteed to be null-terminated.

The output in print fmt should never have been updated as __get_str()
handles the string limit because it can access the length of the string in
the string meta data that is saved in the ring buffer.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: 8db4d6bfbbf92 ("tracing: Change synthetic event string format to limit printed length")
Link: https://lore.kernel.org/20250325165202.541088-1-douglas.raillard@arm.com
Signed-off-by: Douglas Raillard <douglas.raillard@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_synth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index 4878758ceea2a..613d45e7b608d 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -290,7 +290,7 @@ static const char *synth_field_fmt(char *type)
 	else if (strcmp(type, "gfp_t") == 0)
 		fmt = "%x";
 	else if (synth_field_is_string(type))
-		fmt = "%.*s";
+		fmt = "%s";
 	else if (synth_field_is_stack(type))
 		fmt = "%s";
 
-- 
2.39.5



