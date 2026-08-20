Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626B237E5D8;
	Thu, 20 Aug 2026 15:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239187; cv=none; b=aERHkLLsF6V9Jq50ZGhYWpXC33Pue3iO75Ypq4ntFEQnL9TOnqNyVgEIDnPJvtDM9/GfiJxGF45iDPJVeK/+0w7R1b7thOKbHH2rGZJscfwnRhBfyXhOREKbGFoDNone6smfE65gvNtuX+pa/G0GZy8lVsbI7TONNbHP4Xoe4gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239187; c=relaxed/simple;
	bh=8AcYi1CifSdB2TlXwCNX2sObxxbfLhx0DPNszopa7oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAjZX4bjrprEXh+ueDqh9Fn7sFXo5pqp5MBXeEP4hFlTvwlMOrLZFWZx8gaikit+IyO9L86+Kei7+LBqDl42oOkNIyOtV+Mk5kZ2rxdA+zDR8GZXUOdjXqNbHeJGCQiQJyaH6lJLnYIDk05r/2+J82NY0qx8DXXzwAnqR8T7Fxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1wGNJXH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1wGNJXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8E81F00A3A;
	Thu, 20 Aug 2026 15:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239185;
	bh=kgiM8z9R7RcTusYWO0u5TG0FQNkuz6NdWpLqOSyvpYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1wGNJXH9RvjcScoVWxsbntXx6Cn6pcCYtxbiKN7LEW3ZYImkrvAQmWO+XOiZx3Yn
	 FgX4Z6hXJDq8jPRBCQ1qFP0qmYUUmFbCo1eBJzjWOje4rWIYWJUpYqsAu5MdbM8mNA
	 6REVHLVz4qVys317ZbnuO8YDwYjxOjkD+zy/kPMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 162/217] ring-buffer: Prevent resizing of persistent ring buffer
Date: Thu, 20 Aug 2026 16:55:30 +0200
Message-ID: <20260820145242.627573553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit 7c727dfce6be04dd009b29091a4a17d952dbfe03 ]

Dynamically resizing a persistent ring buffer is not possible. Disable
the feature.

Cc: stable@vger.kernel.org
Fixes: be68d63a139b ("ring-buffer: Add ring_buffer_alloc_range()")
Link: https://patch.msgid.link/20260806211306.3704194-2-vdonnefort@google.com
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ dropped the incoming `else if (buffer->remote)` block since 6.18 has a plain `else` arm ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2399,6 +2399,8 @@ rb_allocate_cpu_buffer(struct trace_buff
 		if (cpu_buffer->ring_meta->head_buffer)
 			rb_meta_buffer_update(cpu_buffer, bpage);
 		bpage->range = 1;
+
+		atomic_inc(&cpu_buffer->resize_disabled);
 	} else {
 		int order = cpu_buffer->buffer->subbuf_order;
 		bpage->page = alloc_cpu_data(cpu, order);


