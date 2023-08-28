Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991AC11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C777C433C8;
	Mon, 28 Aug 2023 10:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217955;
	bh=K7snnXxsfekplxePqkugp82ZZYCNZyDDtmA94AFbqd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eA9ekM4QMoELlJ53y+gg8xb5PCrOa4avs2FOAs2wdensu7/FIkw+QeWUMUVLyvR3k
	 f2jEEC2IXGKa+H6O8aWONcvqcTLR3vZ7ZliJz5PQ1+7y8WSmA7DLyK1hXgVjJaXxVp
	 Duk1GVUGOlTqnr+aw3Wi/9fnISN6CibcHDonKg+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 014/129] tracing/synthetic: Allocate one additional element for size
Date: Mon, 28 Aug 2023 12:11:33 +0200
Message-ID: <20230828101157.859829678@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit c4d6b5438116c184027b2e911c0f2c7c406fb47c ]

While debugging another issue I noticed that the stack trace contains one
invalid entry at the end:

<idle>-0       [008] d..4.    26.484201: wake_lat: pid=0 delta=2629976084 000000009cc24024 stack=STACK:
=> __schedule+0xac6/0x1a98
=> schedule+0x126/0x2c0
=> schedule_timeout+0x150/0x2c0
=> kcompactd+0x9ca/0xc20
=> kthread+0x2f6/0x3d8
=> __ret_from_fork+0x8a/0xe8
=> 0x6b6b6b6b6b6b6b6b

This is because the code failed to add the one element containing the
number of entries to field_size.

Link: https://lkml.kernel.org/r/20230816154928.4171614-4-svens@linux.ibm.com

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: 00cf3d672a9d ("tracing: Allow synthetic events to pass around stacktraces")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_synth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index a4c58a932dfa6..32109d092b10f 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -528,7 +528,8 @@ static notrace void trace_event_raw_event_synth(void *__data,
 		str_val = (char *)(long)var_ref_vals[val_idx];
 
 		if (event->dynamic_fields[i]->is_stack) {
-			len = *((unsigned long *)str_val);
+			/* reserve one extra element for size */
+			len = *((unsigned long *)str_val) + 1;
 			len *= sizeof(unsigned long);
 		} else {
 			len = fetch_store_strlen((unsigned long)str_val);
-- 
2.40.1



