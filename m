Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60B21D12B;
	Mon, 18 Dec 2023 13:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0c0jvCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D465C433C8;
	Mon, 18 Dec 2023 13:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907969;
	bh=bmv9Yj7nNj/i690w6lQveLxSg/jqxLw9nAUIXfAeT/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0c0jvCxrpF2DGe84bf/ftoUIYFx2YxgB2t9unbBFoEzgD53ywrM3nwfmJMlf2Ryw
	 oxZ8wPUURE/NH7KD5bhwRtcLWTpS85v5dGCSsz8Y1+zxSRY+e6wRwDcOTg+8J4jouD
	 qTtj61IGaC4fmbvkqjr2i7qYv1ui4CDPMhjZd7Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 100/106] ring-buffer: Fix a race in rb_time_cmpxchg() for 32 bit archs
Date: Mon, 18 Dec 2023 14:51:54 +0100
Message-ID: <20231218135059.335798770@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135055.005497074@linuxfoundation.org>
References: <20231218135055.005497074@linuxfoundation.org>
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

commit fff88fa0fbc7067ba46dde570912d63da42c59a9 upstream.

Mathieu Desnoyers pointed out an issue in the rb_time_cmpxchg() for 32 bit
architectures. That is:

 static bool rb_time_cmpxchg(rb_time_t *t, u64 expect, u64 set)
 {
	unsigned long cnt, top, bottom, msb;
	unsigned long cnt2, top2, bottom2, msb2;
	u64 val;

	/* The cmpxchg always fails if it interrupted an update */
	 if (!__rb_time_read(t, &val, &cnt2))
		 return false;

	 if (val != expect)
		 return false;

<<<< interrupted here!

	 cnt = local_read(&t->cnt);

The problem is that the synchronization counter in the rb_time_t is read
*after* the value of the timestamp is read. That means if an interrupt
were to come in between the value being read and the counter being read,
it can change the value and the counter and the interrupted process would
be clueless about it!

The counter needs to be read first and then the value. That way it is easy
to tell if the value is stale or not. If the counter hasn't been updated,
then the value is still good.

Link: https://lore.kernel.org/linux-trace-kernel/20231211201324.652870-1-mathieu.desnoyers@efficios.com/
Link: https://lore.kernel.org/linux-trace-kernel/20231212115301.7a9c9a64@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Fixes: 10464b4aa605e ("ring-buffer: Add rb_time_t 64 bit operations for speeding up 32 bit")
Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -711,6 +711,9 @@ static int rb_time_cmpxchg(rb_time_t *t,
 	unsigned long cnt2, top2, bottom2, msb2;
 	u64 val;
 
+	/* Any interruptions in this function should cause a failure */
+	cnt = local_read(&t->cnt);
+
 	/* The cmpxchg always fails if it interrupted an update */
 	 if (!__rb_time_read(t, &val, &cnt2))
 		 return false;
@@ -718,7 +721,6 @@ static int rb_time_cmpxchg(rb_time_t *t,
 	 if (val != expect)
 		 return false;
 
-	 cnt = local_read(&t->cnt);
 	 if ((cnt & 3) != cnt2)
 		 return false;
 


