Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A584F6ADD;
	Wed,  5 Mar 2025 17:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197247; cv=none; b=TI6x1XF+9jMW8+ZN551aqi8v7FJGUUdL0Uz5/BOxpNbYfmDVS8cftNcW2CY9u4xgnTwIpnX3/Hkm+4qREAd73HBikYQa877olVWlLmymkgH/wiOdVcODZdtPgwXR3zPdKhp5JCmW/bJcQVo+0stux5fH/C6d15xXutzN9Xhjdy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197247; c=relaxed/simple;
	bh=bvPU3/2nkAhMNqEZaZ5LATmzKHwHH1orNTmtxm87Z0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FF3eT+1ry7G5nsfmwmixH35WeGEe92Rhf5NE45XATxBU/KslNXU2jqg0QpFGeqrqRZFQVw4NdORq38m5OVp7JVSWJkUC9bnQb8fgExP+WbWKpDFDYuyGJMmKUCoE6HejGNrS76IlOYcIX+mirDnCwcE/5hKfNFZ/U6aghdUyVfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOsCBFKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOsCBFKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF893C4CED1;
	Wed,  5 Mar 2025 17:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197245;
	bh=bvPU3/2nkAhMNqEZaZ5LATmzKHwHH1orNTmtxm87Z0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MOsCBFKymQPW5YDUaAHf7qjeYia65UlzFsg0j7Tu/i7JoIaQb2AQyxnMgmDfuzyHC
	 Xq5snXixrK7rGk+GgGYVfARPW02JDsn182bjXrVJPkv3TnbZ6QfiGr9tsOgTq5ChDD
	 7V9H44NRgBfxXx8EpVSQfH5MZhpztV8mrzxIlPg4=
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
Subject: [PATCH 6.1 089/176] ftrace: Do not add duplicate entries in subops manager ops
Date: Wed,  5 Mar 2025 18:47:38 +0100
Message-ID: <20250305174509.037497504@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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
@@ -5108,6 +5108,9 @@ __ftrace_match_addr(struct ftrace_hash *
 			return -ENOENT;
 		free_hash_entry(hash, entry);
 		return 0;
+	} else if (__ftrace_lookup_ip(hash, ip) != NULL) {
+		/* Already exists */
+		return 0;
 	}
 
 	return add_hash_entry(hash, ip);


