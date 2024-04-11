Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7701474B0;
	Thu, 11 Apr 2024 10:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831674; cv=none; b=FbdPEz2ETSjqUjcraONVvdqPPb8X+M36TEvMiU2qgjEGEMo5KvXnQ+yXN5mHsJCsvK4VzMB89yroD6xeCEkeBDWSflACyAe9S/XALETfl+P/yqv76nx2a3dOwJlRfxVU/m4hMfhDP9HHxQSoSET3wbizx2wV4Mq4biZ0EX53Tho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831674; c=relaxed/simple;
	bh=Oq+BfmrDP7XQosqCh/P4zavSoxF0/xDp01yav11hSz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyyjbWoeDbwT56K+aXkkzEHbsS1M24oMHj67x9dqTZ/Cm5Mnl5Wh1P5kdwjlK13T8QnvOo9UHH3qPWGBhAQH0c8xE+x1hlsUC8LDkpNKu5yiJnQy4NMTYsOVGcF/KAemtiM4byRZQUB+OUgiG49zDLGFT3sAju+dVHDL1BUgrNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llaMPxob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llaMPxob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA79EC433F1;
	Thu, 11 Apr 2024 10:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831674;
	bh=Oq+BfmrDP7XQosqCh/P4zavSoxF0/xDp01yav11hSz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=llaMPxobyRStq4b5Bf3MyOcnzFwe4SYDgbCMsGND3bf3lWbDt7hZ5+5Quww9eLJV2
	 CA0OOoE1tn/a+940B9oCE8j0HN46qmCucHPaNsxeNSuqIPPn3FzLuvPuDTTh5k1AI4
	 f6N5ILuksof8tdNMlIT+1tLOkoJS0yQDBTBNUlFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/294] ring-buffer: Do not set shortest_full when full target is hit
Date: Thu, 11 Apr 2024 11:54:11 +0200
Message-ID: <20240411095438.332572399@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 761d9473e27f0c8782895013a3e7b52a37c8bcfc ]

The rb_watermark_hit() checks if the amount of data in the ring buffer is
above the percentage level passed in by the "full" variable. If it is, it
returns true.

But it also sets the "shortest_full" field of the cpu_buffer that informs
writers that it needs to call the irq_work if the amount of data on the
ring buffer is above the requested amount.

The rb_watermark_hit() always sets the shortest_full even if the amount in
the ring buffer is what it wants. As it is not going to wait, because it
has what it wants, there's no reason to set shortest_full.

Link: https://lore.kernel.org/linux-trace-kernel/20240312115641.6aa8ba08@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: 42fb0a1e84ff5 ("tracing/ring-buffer: Have polling block on watermark")
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 936b560989a3e..5b665e5991bf7 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -887,9 +887,10 @@ static bool rb_watermark_hit(struct trace_buffer *buffer, int cpu, int full)
 		pagebusy = cpu_buffer->reader_page == cpu_buffer->commit_page;
 		ret = !pagebusy && full_hit(buffer, cpu, full);
 
-		if (!cpu_buffer->shortest_full ||
-		    cpu_buffer->shortest_full > full)
-			cpu_buffer->shortest_full = full;
+		if (!ret && (!cpu_buffer->shortest_full ||
+			     cpu_buffer->shortest_full > full)) {
+		    cpu_buffer->shortest_full = full;
+		}
 		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 	}
 	return ret;
-- 
2.43.0



