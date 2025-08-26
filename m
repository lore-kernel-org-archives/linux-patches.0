Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A6623F439;
	Tue, 26 Aug 2025 13:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213434; cv=none; b=uSk7g1G3FBaeUWe3x7Y33osPi6zq6IIb+dkOSrvvyspORz8dCnVJcaOF6a5N8Bdm+6GCEkXx+TCufmGeurAWp55L5M+R9kunDJpXVK0NrTJ7E7bVLB5snYrGdVVO+MBZos9AvImURyTQdiWtALHcLRzctPaZsKvelkvJY+omxfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213434; c=relaxed/simple;
	bh=EhvqosMmgakwY4FV+PnL2Q1CdP87eHyxGrCKLQ/R7E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jH5Jv3mHteY4ltfqkxkQA5UKikT6q9K/0ruhxKfqEi2G4qi9ZRk65+9JHbRu/u5TyJZ4YBt8vIihRDAYnFLD3kvCmjVIohSprLHBuG2pjl7nLJrckiRueKvD5U606qQl9aHovLuRhC70+moRHpjFEO7Pv2q2LAu4VzSeLSFs0mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9Kd6Fe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9Kd6Fe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D9FC113CF;
	Tue, 26 Aug 2025 13:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213432;
	bh=EhvqosMmgakwY4FV+PnL2Q1CdP87eHyxGrCKLQ/R7E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9Kd6Fe9+oFwqhZAZjRm7Xyjsxgc3Z5vYm4G69D+5DapuC9wcpRbkVNlTny3nxZ6Z
	 RlR5AXlIzkJV1JFZGW3Qj+ISs9eGnqfWItPzqT8u3rnPY3tCrsQF8rlqzA6VByqqFZ
	 kqA8mpEAA03tvtWPRmhI335zQ2q8rSEMMYXVwOyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 347/587] tracing: fprobe-event: Sanitize wildcard for fprobe event name
Date: Tue, 26 Aug 2025 13:08:16 +0200
Message-ID: <20250826111001.742361497@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit ec879e1a0be8007aa232ffedcf6a6445dfc1a3d7 upstream.

Fprobe event accepts wildcards for the target functions, but unless user
specifies its event name, it makes an event with the wildcards.

  /sys/kernel/tracing # echo 'f mutex*' >> dynamic_events
  /sys/kernel/tracing # cat dynamic_events
  f:fprobes/mutex*__entry mutex*
  /sys/kernel/tracing # ls events/fprobes/
  enable         filter         mutex*__entry

To fix this, replace the wildcard ('*') with an underscore.

Link: https://lore.kernel.org/all/175535345114.282990.12294108192847938710.stgit@devnote2/

Fixes: 334e5519c375 ("tracing/probes: Add fprobe events for tracing function entry and exit.")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -2053,7 +2053,7 @@ static inline bool is_good_system_name(c
 static inline void sanitize_event_name(char *name)
 {
 	while (*name++ != '\0')
-		if (*name == ':' || *name == '.')
+		if (*name == ':' || *name == '.' || *name == '*')
 			*name = '_';
 }
 


