Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91BE17AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE6BC433C8;
	Wed,  9 Aug 2023 11:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580510;
	bh=5R1n7n3ygwEQ/V8mHRM8rqFfAAtW3FasXhQKms0hvkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIt1i5xzgJqWb4fKOL5XQHcqp17cb7rgngZHWFCGHLP1Y1AYZ7OFaF1UBjvrIOOa2
	 +wSLoTJioMuMgSgUozQeh7ZOF8lJLQ0ngnu1hQG9SQKROUGjUcfR8qlKAOFXC6i75O
	 3/RPu5PIUGIteKK3y8qpCQm9Ui4GaMWsrgiaN+1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/154] ftrace: Check if pages were allocated before calling free_pages()
Date: Wed,  9 Aug 2023 12:40:52 +0200
Message-ID: <20230809103637.658277452@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit 59300b36f85f254260c81d9dd09195fa49eb0f98 ]

It is possible that on error pg->size can be zero when getting its order,
which would return a -1 value. It is dangerous to pass in an order of -1
to free_pages(). Check if order is greater than or equal to zero before
calling free_pages().

Link: https://lore.kernel.org/lkml/20210330093916.432697c7@gandalf.local.home/

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: 26efd79c4624 ("ftrace: Fix possible warning on checking all pages used in ftrace_process_locs()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 97d615988ea35..5f5a766bf73bb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3079,7 +3079,8 @@ ftrace_allocate_pages(unsigned long num_to_init)
 	pg = start_pg;
 	while (pg) {
 		order = get_count_order(pg->size / ENTRIES_PER_PAGE);
-		free_pages((unsigned long)pg->records, order);
+		if (order >= 0)
+			free_pages((unsigned long)pg->records, order);
 		start_pg = pg->next;
 		kfree(pg);
 		pg = start_pg;
@@ -5877,7 +5878,8 @@ void ftrace_release_mod(struct module *mod)
 		clear_mod_from_hashes(pg);
 
 		order = get_count_order(pg->size / ENTRIES_PER_PAGE);
-		free_pages((unsigned long)pg->records, order);
+		if (order >= 0)
+			free_pages((unsigned long)pg->records, order);
 		tmp_page = pg->next;
 		kfree(pg);
 		ftrace_number_of_pages -= 1 << order;
@@ -6222,7 +6224,8 @@ void ftrace_free_mem(struct module *mod, void *start_ptr, void *end_ptr)
 		if (!pg->index) {
 			*last_pg = pg->next;
 			order = get_count_order(pg->size / ENTRIES_PER_PAGE);
-			free_pages((unsigned long)pg->records, order);
+			if (order >= 0)
+				free_pages((unsigned long)pg->records, order);
 			ftrace_number_of_pages -= 1 << order;
 			ftrace_number_of_groups--;
 			kfree(pg);
-- 
2.39.2



