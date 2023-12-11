Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1B15102A;
	Mon, 11 Dec 2023 18:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZgR7oa6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AB4C433C9;
	Mon, 11 Dec 2023 18:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320644;
	bh=l+iqHDAW0T2sjveyD4CTPnt8FxJK2ET0pQXJ+I6qfnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZgR7oa6H0KUP89TdtWV7Q1RZ3dmG9mHL9Y28/+mMO2u2NuZNX3ch/vSDmTcpNTiJ
	 KHC01IdKV3cSGSWe7U8uAIO8ORHCoXUzXkeV88YevnTJKtKM6lKzbEAEWvBIMTdann
	 Y/ZL8nSh4JPSRaZpnT5o9JRA3qr/zod2W6h53+Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 110/194] ring-buffer: Test last update in 32bit version of __rb_time_read()
Date: Mon, 11 Dec 2023 19:21:40 +0100
Message-ID: <20231211182041.392908888@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit f458a1453424e03462b5bb539673c9a3cddda480 upstream.

Since 64 bit cmpxchg() is very expensive on 32bit architectures, the
timestamp used by the ring buffer does some interesting tricks to be able
to still have an atomic 64 bit number. It originally just used 60 bits and
broke it up into two 32 bit words where the extra 2 bits were used for
synchronization. But this was not enough for all use cases, and all 64
bits were required.

The 32bit version of the ring buffer timestamp was then broken up into 3
32bit words using the same counter trick. But one update was not done. The
check to see if the read operation was done without interruption only
checked the first two words and not last one (like it had before this
update). Fix it by making sure all three updates happen without
interruption by comparing the initial counter with the last updated
counter.

Link: https://lore.kernel.org/linux-trace-kernel/20231206100050.3100b7bb@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: f03f2abce4f39 ("ring-buffer: Have 32 bit time stamps use all 64 bits")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -646,8 +646,8 @@ static inline bool __rb_time_read(rb_tim
 
 	*cnt = rb_time_cnt(top);
 
-	/* If top and bottom counts don't match, this interrupted a write */
-	if (*cnt != rb_time_cnt(bottom))
+	/* If top and msb counts don't match, this interrupted a write */
+	if (*cnt != rb_time_cnt(msb))
 		return false;
 
 	/* The shift to msb will lose its cnt bits */


