Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6E7175D48;
	Mon, 24 Feb 2025 14:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408267; cv=none; b=KWtIIiBSo8hOTInYBa/hU9XJg1qbZfbONtgPnmD6x+LSJbB7+GpIVonQTrZ1zpZiJsEKxs5fWwFkm4mbPFq+EeHZq1UetyjEtUb00cLzsTzxM1/mkalbxbFgdTx7Z+napFPVsYnl7Yy7U6lnaVxF6xpAlWkdk+lI9/NZ9FAm7wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408267; c=relaxed/simple;
	bh=iK9ef/qs0PoGz+0NDCvnf4BGe+XJp2XR9AotwlecOM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9acwv3b0a1NLBBj7i8r7QQtQdV/fvgFlLtuAPvEIOia8eNxn/gf5ilJPot6I40cHHHflDBIQERvWuDQM1dDoJQ3f9pp9/iOgvWs826cZFk0bmqW9w+nJAZ4Y1XtWYbIcQp05azyCo2mgmqSO88LwilvgnvGiQzbyi3m7yi6Fek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADL1+hyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADL1+hyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D91C4CED6;
	Mon, 24 Feb 2025 14:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408267;
	bh=iK9ef/qs0PoGz+0NDCvnf4BGe+XJp2XR9AotwlecOM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADL1+hyMwkwN36fDbOoQ3W2qrhMXsroLev/lJ96xK6IXDZ6S1J6yFvzHcfkhRc/9i
	 m0JgpcUgSobJkYtGBxyp82vik8bEli2txJSAKoVgQCQjzNMm32KLMyg8Va6vJ6Q7+1
	 fLsyY5GMIYnxjKUg/6ZoAnoH57EvahCvAvgzTjZk=
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
Subject: [PATCH 6.6 131/140] ftrace: Do not add duplicate entries in subops manager ops
Date: Mon, 24 Feb 2025 15:35:30 +0100
Message-ID: <20250224142608.158251767@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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
@@ -5233,6 +5233,9 @@ __ftrace_match_addr(struct ftrace_hash *
 			return -ENOENT;
 		free_hash_entry(hash, entry);
 		return 0;
+	} else if (__ftrace_lookup_ip(hash, ip) != NULL) {
+		/* Already exists */
+		return 0;
 	}
 
 	entry = add_hash_entry(hash, ip);


