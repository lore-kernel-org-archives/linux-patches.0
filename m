Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF9CFBE1;
	Mon, 11 Dec 2023 18:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aC9IRDSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D12C433C8;
	Mon, 11 Dec 2023 18:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319468;
	bh=28fT1pQ+mLXfts5ZOllyFIALHGAM7Dbf21e/Z6Zzyrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aC9IRDSo4pb5LM87BMq592jx1QDEvSsr3ItTDwxTeC+BnekguYoQv8Xm5isHvotLm
	 iRCKRnnXv9nf9EK/YIPksaU1rKR/CAGt8u02MsXKUUGgy5GiDQPxa+d3R+ihK4hG5S
	 lrLudd35WvTiBm/vo0UJqEVkDso/F+sv3NhdW0IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/244] tracing: Fix a warning when allocating buffered events fails
Date: Mon, 11 Dec 2023 19:20:10 +0100
Message-ID: <20231211182051.052232107@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit 34209fe83ef8404353f91ab4ea4035dbc9922d04 ]

Function trace_buffered_event_disable() produces an unexpected warning
when the previous call to trace_buffered_event_enable() fails to
allocate pages for buffered events.

The situation can occur as follows:

* The counter trace_buffered_event_ref is at 0.

* The soft mode gets enabled for some event and
  trace_buffered_event_enable() is called. The function increments
  trace_buffered_event_ref to 1 and starts allocating event pages.

* The allocation fails for some page and trace_buffered_event_disable()
  is called for cleanup.

* Function trace_buffered_event_disable() decrements
  trace_buffered_event_ref back to 0, recognizes that it was the last
  use of buffered events and frees all allocated pages.

* The control goes back to trace_buffered_event_enable() which returns.
  The caller of trace_buffered_event_enable() has no information that
  the function actually failed.

* Some time later, the soft mode is disabled for the same event.
  Function trace_buffered_event_disable() is called. It warns on
  "WARN_ON_ONCE(!trace_buffered_event_ref)" and returns.

Buffered events are just an optimization and can handle failures. Make
trace_buffered_event_enable() exit on the first failure and left any
cleanup later to when trace_buffered_event_disable() is called.

Link: https://lore.kernel.org/all/20231127151248.7232-2-petr.pavlu@suse.com/
Link: https://lkml.kernel.org/r/20231205161736.19663-3-petr.pavlu@suse.com

Fixes: 0fc1b09ff1ff ("tracing: Use temp buffer when filtering events")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a40d6baf101f0..689d063dd2062 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2769,8 +2769,11 @@ void trace_buffered_event_enable(void)
 	for_each_tracing_cpu(cpu) {
 		page = alloc_pages_node(cpu_to_node(cpu),
 					GFP_KERNEL | __GFP_NORETRY, 0);
-		if (!page)
-			goto failed;
+		/* This is just an optimization and can handle failures */
+		if (!page) {
+			pr_err("Failed to allocate event buffer\n");
+			break;
+		}
 
 		event = page_address(page);
 		memset(event, 0, sizeof(*event));
@@ -2784,10 +2787,6 @@ void trace_buffered_event_enable(void)
 			WARN_ON_ONCE(1);
 		preempt_enable();
 	}
-
-	return;
- failed:
-	trace_buffered_event_disable();
 }
 
 static void enable_trace_buffered_event(void *data)
-- 
2.42.0



