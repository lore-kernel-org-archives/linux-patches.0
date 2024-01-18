Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839E523775;
	Thu, 18 Jan 2024 11:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575646; cv=none; b=Qikw9iMJs2mdEaSaKiz6hyYXOGwxk+LBiia8gJJbCqiO/e6jMsc8+o/wDFkAxPPcGFeiik6dHz8XAxsx99QPfDrViQ7xH/JShKzRIr/vBv2Gzf0L8Y4S1GpI6cWNThQEBtf0GhqOn0wS6XxwvzLdeQV/lQmI/pbIRuSLruY65QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575646; c=relaxed/simple;
	bh=f6kIzWrf/e3tmxcpQRQrwZ7+tK6onkBdNzeEV2MykAI=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=SC0Y0NoKp7zUt2440H1JpX1mnZPh/qdLJ/CJsv+6uYZdw5vxuaLhGLaLsLVTEZFu4BQ+3Lvm1UmLrsekMMJRWiW46IBpjtGZjRvtgITkpt8sR7P9kWoA/6P+QHayFK+g9+yDsDpgv7S3DWyWhOPz/xalBkE5Dvkmt38IJ1smOQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZFvndjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZFvndjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0852AC433C7;
	Thu, 18 Jan 2024 11:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575646;
	bh=f6kIzWrf/e3tmxcpQRQrwZ7+tK6onkBdNzeEV2MykAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZFvndjq4K/7ntgSKAd/nU+79rkg2nQH2UcbXydexb+WbAcncBX+l4aG7cqe9LWzK
	 EUalmW09j2tiIvZQRcRoTEOR5lrgnEg+oT54HZOgNPcFswxSOgF5tZT+XZPrOhpPJG
	 RodeZVpPNdh/sb4uGURqoOC497v2BCrmWvDbo+Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/100] ring-buffer: Do not record in NMI if the arch does not support cmpxchg in NMI
Date: Thu, 18 Jan 2024 11:49:03 +0100
Message-ID: <20240118104313.293838709@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 712292308af2265cd9b126aedfa987f10f452a33 ]

As the ring buffer recording requires cmpxchg() to work, if the
architecture does not support cmpxchg in NMI, then do not do any recording
within an NMI.

Link: https://lore.kernel.org/linux-trace-kernel/20231213175403.6fc18540@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 71cad4f1323c..1285e7fb597e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3644,6 +3644,12 @@ rb_reserve_next_event(struct trace_buffer *buffer,
 	int nr_loops = 0;
 	int add_ts_default;
 
+	/* ring buffer does cmpxchg, make sure it is safe in NMI context */
+	if (!IS_ENABLED(CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG) &&
+	    (unlikely(in_nmi()))) {
+		return NULL;
+	}
+
 	rb_start_commit(cpu_buffer);
 	/* The commit page can not change after this */
 
-- 
2.43.0



