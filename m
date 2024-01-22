Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4654134749;
	Tue, 23 Jan 2024 00:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968112; cv=none; b=Nz7W2yQkpcdU7Nsy/TcYuhzPT2LNlvntFZ3A06zd/mXCJu2IacZOii4y1fsg1kgw1fNHMKDoj/9LZroPdv/J/lXoolt0VVyzm19kscn9n2InbK+8put7L7YKkqR2k289ZDAOfYUl/znVuVwiLoDMy+hn6Mk3LHouxo8B4NhW60U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968112; c=relaxed/simple;
	bh=MFQGIwWqUp6j5KK0nHh9dXPrdwdQWX40C7iy1/JeXNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXJxH/bDRemhZHNDmdTXjoINCJPWzqyegUH7sMRvzoM89W685GOJGOtVQMo31KIpEHf8S8EEQ5q6CSlrs8AHIQBh7hKNZXJuAnWLgNcSt0A4PWXf+zZcv9M5xyLj+yRJl2PWop1XBChxzQBTnEQLzAzYKWaSLUMK+C1t2xxRPpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+V76cH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+V76cH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B53C433F1;
	Tue, 23 Jan 2024 00:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968112;
	bh=MFQGIwWqUp6j5KK0nHh9dXPrdwdQWX40C7iy1/JeXNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+V76cH1AFzQVV23B7V82M99T3wsAe8P4e8uFaMb/cnrNDI+V+MMR3VoN+Q3KYxhV
	 j1mkXsVkeVbgQ2X4RPbp+nvnkjNzUL/9+EGwQc6Dtidovmrvj6o/z4dAJToFk+lFBR
	 UxHd+ccMSJ13Mbpl3TAcHf8kBP68BS+RAkRp9npE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 014/148] ring-buffer: Do not record in NMI if the arch does not support cmpxchg in NMI
Date: Mon, 22 Jan 2024 15:56:10 -0800
Message-ID: <20240122235713.008763811@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index b627bc820540..d2903d8834fe 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2891,6 +2891,12 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 	int nr_loops = 0;
 	u64 diff;
 
+	/* ring buffer does cmpxchg, make sure it is safe in NMI context */
+	if (!IS_ENABLED(CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG) &&
+	    (unlikely(in_nmi()))) {
+		return NULL;
+	}
+
 	rb_start_commit(cpu_buffer);
 
 #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
-- 
2.43.0



