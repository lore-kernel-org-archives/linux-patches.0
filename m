Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44269664C6;
	Mon, 24 Feb 2025 14:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408744; cv=none; b=czdpHbrcT+n+LcGtIZl6T2aZJRcGXLL3g4Y1cqAOSy3/FdDN3B2W0qXGfByv7yZc46TgBj0jNGrW9UQCjQBP+VJppt91v1YwlHMBpTZklKH5R6/YWATm8uMeCiD7TnxrEO2O+XCx+2OAeVqE47lBauIE4h9crOWx7hDdSG9usDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408744; c=relaxed/simple;
	bh=l4D67vfPmHcHJm9DVMBGNyzLjlp+rwoEXx72QtwXWf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2OHlEh4pMoJo8W9ul6teByQHCYn2tay87raKOOZxrFPYxW/iaqrJepDsagTyMKPxmClUANi8VF6+MeZeq6eHpMwDgvpdc3k6zvP5USvaIBwaRKU0OHm8m2Kk9ExsqgvNxWRWnvuqBi2tgcdwHpu6IYsx3AWMYLBDUgOwNC1t1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxhcb9lo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxhcb9lo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5345C4CED6;
	Mon, 24 Feb 2025 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408744;
	bh=l4D67vfPmHcHJm9DVMBGNyzLjlp+rwoEXx72QtwXWf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxhcb9lopOKEi8jl52XdxA0bk8uDOCI2E+8rbswoizIPI6lC+PGF06V8pt/UTI3w2
	 6OQlzowl/G/rFNnWcTP7NrPa5Q05GD8rqMWmmobrh6dPDKkhXJP8r3q7YmnyWTKzLh
	 3gjAu50bYuGMdRRu9JB154cqcygOYL+IhkPTG3t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 147/154] ftrace: Do not add duplicate entries in subops manager ops
Date: Mon, 24 Feb 2025 15:35:46 +0100
Message-ID: <20250224142612.802127470@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 8eb4b09e0bbd30981305643229fe7640ad41b667 upstream.

Check if a function is already in the manager ops of a subops. A manager
ops contains multiple subops, and if two or more subops are tracing the
same function, the manager ops only needs a single entry in its hash.

Cc: stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Link: https://lore.kernel.org/20250220202055.226762894@goodmis.org
Fixes: 4f554e955614f ("ftrace: Add ftrace_set_filter_ips function")
Tested-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5758,6 +5758,9 @@ __ftrace_match_addr(struct ftrace_hash *
 			return -ENOENT;
 		free_hash_entry(hash, entry);
 		return 0;
+	} else if (__ftrace_lookup_ip(hash, ip) != NULL) {
+		/* Already exists */
+		return 0;
 	}
 
 	entry = add_hash_entry(hash, ip);


