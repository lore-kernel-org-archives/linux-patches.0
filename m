Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A7633BBCD;
	Thu,  2 Jul 2026 16:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010854; cv=none; b=lF4IdeOxnp8qrnYDYz+Q3rLoD5xTT5e7R6w6s2rtozDGCs/G75YOMnV10uWG76MJLmtXNjJTUFGOMPZS50/F8X6F55XLXMEg4CioNXjEkqjCd/fmjtM+4WBlonLewOyAfTMdO3LUuPf6vDwq0sMWvwNxyvQ1kQDS6hM+dBpYUJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010854; c=relaxed/simple;
	bh=liVp4zpbSCev2RK6txmObTm8OGxTQw69sOI0sZDV66I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AK0nNVbqn5qvhvgaS0y9zHBu/8h2McG41FdDTvlYPpfldrA59/5Nbv70fvMFzMwv2T4VovlfZCduwzbDe3XLo5fyGEEl2wSy/eJrWssaaQxm2vxThwF9HZbZyeCAs+Sz2CF5PEQ/dHVTbLOxGxWLdvaHQFSVUht4qXFVZj3clU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iupdgd72; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iupdgd72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAA61F000E9;
	Thu,  2 Jul 2026 16:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010853;
	bh=6VQcI42tr2xojNXVv8Nz1ngrYcCFYswc/vGlfxnXRJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iupdgd72zUY4OGI+Vy+nD/YJhfs/z0iGKzCGT2siNCBXC9lbOEX0E3IYdYWHU57OZ
	 HVOiMf1ul6H5r6Kpvoks91J86lOGxZgKnjDMLhyrJc3z23HZ8RZEXTBrWMnbabBfUX
	 LFiDbyIqiJr+/918Py9COZ6hwcomkhsiVgEOdKto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bpf <bpf@vger.kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Martin Kelly <martin.kelly@crowdstrike.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Subject: [PATCH 6.6 063/175] ftrace: Update the mcount_loc check of skipped entries
Date: Thu,  2 Jul 2026 18:19:24 +0200
Message-ID: <20260702155117.121153956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 4a3efc6baff931da9a85c6d2e42c87bd9a827399 ]

Now that weak functions turn into skipped entries, update the check to
make sure the amount that was allocated would fit both the entries that
were allocated as well as those that were skipped.

Cc: bpf <bpf@vger.kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Zheng Yejian <zhengyejian1@huawei.com>
Cc: Martin  Kelly <martin.kelly@crowdstrike.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Link: https://lore.kernel.org/20250218200023.055162048@goodmis.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6632,7 +6632,28 @@ static int ftrace_process_locs(struct mo
 
 	/* We should have used all pages unless we skipped some */
 	if (pg_unuse) {
-		WARN_ON(!skipped);
+		unsigned long pg_remaining, remaining = 0;
+		unsigned long skip;
+
+		/* Count the number of entries unused and compare it to skipped. */
+		pg_remaining = (ENTRIES_PER_PAGE << pg->order) - pg->index;
+
+		if (!WARN(skipped < pg_remaining, "Extra allocated pages for ftrace")) {
+
+			skip = skipped - pg_remaining;
+
+			for (pg = pg_unuse; pg; pg = pg->next)
+				remaining += 1 << pg->order;
+
+			skip = DIV_ROUND_UP(skip, ENTRIES_PER_PAGE);
+
+			/*
+			 * Check to see if the number of pages remaining would
+			 * just fit the number of entries skipped.
+			 */
+			WARN(skip != remaining, "Extra allocated pages for ftrace: %lu with %lu skipped",
+			     remaining, skipped);
+		}
 		/* Need to synchronize with ftrace_location_range() */
 		synchronize_rcu();
 		ftrace_free_pages(pg_unuse);


