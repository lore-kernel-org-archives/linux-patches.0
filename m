Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B988251C2D;
	Mon, 11 Dec 2023 18:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+8y2wNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442CBC433C8;
	Mon, 11 Dec 2023 18:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320737;
	bh=ZRVjUnex08DMKUHpg8q737YltNIDvitXBS85VP4xhxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+8y2wNgh43qWpxEzLzxVjhAQT8VIWKUu5SQHgbm/Svs6nj7FLhq3UHrjCvOGXZRm
	 ecC/zSGgVflFHPKTwA2XTecmn9w71COf92ayNng2Lfsxjr4AB8dN5UaDuF2i54W0lN
	 fklJPQAKamDBEDm47E0qTklac7swHdu2TX3QRj9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mhiramat@kernel.org,
	Zheng Yejian <zhengyejian1@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/194] tracing: Set actual size after ring buffer resize
Date: Mon, 11 Dec 2023 19:22:14 +0100
Message-ID: <20231211182043.053446362@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Yejian <zhengyejian1@huawei.com>

[ Upstream commit 6d98a0f2ac3c021d21be66fa34e992137cd25bcb ]

Currently we can resize trace ringbuffer by writing a value into file
'buffer_size_kb', then by reading the file, we get the value that is
usually what we wrote. However, this value may be not actual size of
trace ring buffer because of the round up when doing resize in kernel,
and the actual size would be more useful.

Link: https://lore.kernel.org/linux-trace-kernel/20230705002705.576633-1-zhengyejian1@huawei.com

Cc: <mhiramat@kernel.org>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: d78ab792705c ("tracing: Stop current tracer when resizing buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2e1c6fd0d3f17..048728807f265 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6215,6 +6215,15 @@ static void set_buffer_entries(struct array_buffer *buf, unsigned long val)
 		per_cpu_ptr(buf->data, cpu)->entries = val;
 }
 
+static void update_buffer_entries(struct array_buffer *buf, int cpu)
+{
+	if (cpu == RING_BUFFER_ALL_CPUS) {
+		set_buffer_entries(buf, ring_buffer_size(buf->buffer, 0));
+	} else {
+		per_cpu_ptr(buf->data, cpu)->entries = ring_buffer_size(buf->buffer, cpu);
+	}
+}
+
 #ifdef CONFIG_TRACER_MAX_TRACE
 /* resize @tr's buffer to the size of @size_tr's entries */
 static int resize_buffer_duplicate_size(struct array_buffer *trace_buf,
@@ -6292,18 +6301,12 @@ static int __tracing_resize_ring_buffer(struct trace_array *tr,
 		return ret;
 	}
 
-	if (cpu == RING_BUFFER_ALL_CPUS)
-		set_buffer_entries(&tr->max_buffer, size);
-	else
-		per_cpu_ptr(tr->max_buffer.data, cpu)->entries = size;
+	update_buffer_entries(&tr->max_buffer, cpu);
 
  out:
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
-	if (cpu == RING_BUFFER_ALL_CPUS)
-		set_buffer_entries(&tr->array_buffer, size);
-	else
-		per_cpu_ptr(tr->array_buffer.data, cpu)->entries = size;
+	update_buffer_entries(&tr->array_buffer, cpu);
 
 	return ret;
 }
-- 
2.42.0



