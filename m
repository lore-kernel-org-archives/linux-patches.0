Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0351CA8F;
	Mon,  1 Apr 2024 16:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988346; cv=none; b=icfvINX6VgZzzEwOcCM3M5145PvcahD7Cgjnmg91wNW8wVF1l8FeWv3DQPukqDD6JG1O/Fr0P83AQ/I6xxDWHRzqchQ79WWI5kBkjgu0VS8j4Qo10vgvwInXy5gVTSNMZXUgUnLmuWm6zmNSIX3vyZyNc6ySdWmyweDroiN0w/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988346; c=relaxed/simple;
	bh=eiFWH/pJRzaxrxZwWmX2u8Z0QzVK+jCEzx+ll1dMPtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBhSgxKUad6EQM7CKs3cOrmAIQ3inAFDpkJFkbOr+rxJwwceKAdcdCBdLIZVMjpyU0x6EKtLnuEttGtCySajDD5ywiT8XFHGoYd7YXTT0ReOT1bhKPyWIYl6pLTaPm99tPUsSO64TkmZybdg88uxA26oNr/OBUNmhKVNf9P278E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2C/3WkOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2C/3WkOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4C3C433C7;
	Mon,  1 Apr 2024 16:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988346;
	bh=eiFWH/pJRzaxrxZwWmX2u8Z0QzVK+jCEzx+ll1dMPtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2C/3WkOtdn/gD9aIFCbS/9p8uWQG8RlJ0hGcg6FVzmKtvoKSH4LSPNyOdFCN2zAij
	 HMWMiliVlSIpWFja92jSIdb7vdhnTNeT6fZzcf/2IcE6uq6E+1mVr7rEpAB5ruq+9Y
	 aPN4bBKCX/Swfl0AD6ZuUOMHHDFgEAka1yTfhVzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 157/432] ring-buffer: Do not set shortest_full when full target is hit
Date: Mon,  1 Apr 2024 17:42:24 +0200
Message-ID: <20240401152557.825268183@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 840301b04f31f..72cebeb0c916f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -970,9 +970,10 @@ static bool rb_watermark_hit(struct trace_buffer *buffer, int cpu, int full)
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



