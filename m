Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3944DFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA399C433EF;
	Mon, 15 May 2023 17:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171570;
	bh=2qVUV9OkNHd1g2qmZFWshx7GnnNRYQpXuECWjUBNC9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEJWe1jM1IIb3SAaVP9mMUdnBLvAfdTbB14O/A89zzWrTcxETbRfz0jupMRM/jCQG
	 jpx008ZsG+PDhOwGOstRCMV5Yas/ENuNmgpvnHzDI6GjONCn7H2wL7DAPBTa1moASj
	 kfQMjkFBVD6pRjfiXzI04VOOPTbCzr82XoUCW3xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mhiramat@kernel.org,
	npiggin@gmail.com,
	Cheng-Jui Wang <cheng-jui.wang@mediatek.com>,
	Tze-nan Wu <Tze-nan.Wu@mediatek.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/134] ring-buffer: Ensure proper resetting of atomic variables in ring_buffer_reset_online_cpus
Date: Mon, 15 May 2023 18:27:58 +0200
Message-Id: <20230515161702.947758823@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tze-nan Wu <Tze-nan.Wu@mediatek.com>

[ Upstream commit 7c339fb4d8577792378136c15fde773cfb863cb8 ]

In ring_buffer_reset_online_cpus, the buffer_size_kb write operation
may permanently fail if the cpu_online_mask changes between two
for_each_online_buffer_cpu loops. The number of increases and decreases
on both cpu_buffer->resize_disabled and cpu_buffer->record_disabled may be
inconsistent, causing some CPUs to have non-zero values for these atomic
variables after the function returns.

This issue can be reproduced by "echo 0 > trace" while hotplugging cpu.
After reproducing success, we can find out buffer_size_kb will not be
functional anymore.

To prevent leaving 'resize_disabled' and 'record_disabled' non-zero after
ring_buffer_reset_online_cpus returns, we ensure that each atomic variable
has been set up before atomic_sub() to it.

Link: https://lore.kernel.org/linux-trace-kernel/20230426062027.17451-1-Tze-nan.Wu@mediatek.com

Cc: stable@vger.kernel.org
Cc: <mhiramat@kernel.org>
Cc: npiggin@gmail.com
Fixes: b23d7a5f4a07 ("ring-buffer: speed up buffer resets by avoiding synchronize_rcu for each CPU")
Reviewed-by: Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
Signed-off-by: Tze-nan Wu <Tze-nan.Wu@mediatek.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bacd1f87f941b..83046c6443f1c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5295,6 +5295,9 @@ void ring_buffer_reset_cpu(struct trace_buffer *buffer, int cpu)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
 
+/* Flag to ensure proper resetting of atomic variables */
+#define RESET_BIT	(1 << 30)
+
 /**
  * ring_buffer_reset_cpu - reset a ring buffer per CPU buffer
  * @buffer: The ring buffer to reset a per cpu buffer of
@@ -5311,20 +5314,27 @@ void ring_buffer_reset_online_cpus(struct trace_buffer *buffer)
 	for_each_online_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
 
-		atomic_inc(&cpu_buffer->resize_disabled);
+		atomic_add(RESET_BIT, &cpu_buffer->resize_disabled);
 		atomic_inc(&cpu_buffer->record_disabled);
 	}
 
 	/* Make sure all commits have finished */
 	synchronize_rcu();
 
-	for_each_online_buffer_cpu(buffer, cpu) {
+	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
 
+		/*
+		 * If a CPU came online during the synchronize_rcu(), then
+		 * ignore it.
+		 */
+		if (!(atomic_read(&cpu_buffer->resize_disabled) & RESET_BIT))
+			continue;
+
 		reset_disabled_cpu_buffer(cpu_buffer);
 
 		atomic_dec(&cpu_buffer->record_disabled);
-		atomic_dec(&cpu_buffer->resize_disabled);
+		atomic_sub(RESET_BIT, &cpu_buffer->resize_disabled);
 	}
 
 	mutex_unlock(&buffer->mutex);
-- 
2.39.2



