Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2498F192D97;
	Mon, 24 Feb 2025 15:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409259; cv=none; b=rlA7uUfwbMdLRGi0isW9JNK2ti2cYs/rdnYZHENdALnPUip0kNYeLHkJW3qDQZdPuKsJa9qKwjvv2/wHQozbdDQVISCZt3HODQ8We+AEK2H3IZxlVVbq0J+iygJRqVwmv7xtGkLbWy777QA05C8Tz0eS1C0taQIGxbKz87/5kb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409259; c=relaxed/simple;
	bh=50RBF2/uqVQpNmQBBTUdqgQ/M5+vb6dM5npquOgMi60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/O5mBacYQDJZw/tanNbgCHrDeume14tunCcgEIM3V9aDmPwiSOMispEIDp1wgZe7hv/TnLfvcdiBqYWSgpZ6UqOeaF+CwP4WxPcx6FefGp1FelaY8HJCuBfxTg8qm4F7qvcMW8JbQldnYFuJt5LGiKmYatpd2qgnv0mU98WMVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cq2oXnB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cq2oXnB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865A6C4CEE9;
	Mon, 24 Feb 2025 15:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409259;
	bh=50RBF2/uqVQpNmQBBTUdqgQ/M5+vb6dM5npquOgMi60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cq2oXnB14NB3IJTpmNXmZVfNO8Ibxosz8FIUcorbHNt7G92T5dbeluAtT8nZUU47T
	 asy8xwiSHF2tYHEszoqHVomv00iZufUv+DoJmyfBvW6c8JOsniu9xxsKvOd0+bCAmO
	 D4qRTDFZtZ8n35E/2VKwnKC3gpTTn6+f2k9g7+vQ=
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
Subject: [PATCH 6.13 133/138] ftrace: Do not add duplicate entries in subops manager ops
Date: Mon, 24 Feb 2025 15:36:03 +0100
Message-ID: <20250224142609.698076334@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5770,6 +5770,9 @@ __ftrace_match_addr(struct ftrace_hash *
 			return -ENOENT;
 		free_hash_entry(hash, entry);
 		return 0;
+	} else if (__ftrace_lookup_ip(hash, ip) != NULL) {
+		/* Already exists */
+		return 0;
 	}
 
 	entry = add_hash_entry(hash, ip);


