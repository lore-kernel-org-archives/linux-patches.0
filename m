Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8279315CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5226FC43470;
	Tue,  8 Nov 2022 14:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916353;
	bh=Fbe1ZDyX7ko00ZZoe9ItYmKYJKXuQsXotGJtvNtSY6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3QvH/CGsHnfB4HgF3O8QoWibE3niR7nUbz9TQWImRkzKymnDLrwaOFaTnYvhkDiZ
	 J9wR1pSrHqBIAW95F8WW+ZEvcPeZBcFeqo+/Kw2ITWFlN5+ajRU2jvq64h3f+Vjgfu
	 Dz0yvLDqBJBZq42eholpzN/CJdjK2uKK9viF1cxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Noonan <steven.noonan@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Roland Ruckerbauer <roland.rucky@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 109/144] ring-buffer: Check for NULL cpu_buffer in ring_buffer_wake_waiters()
Date: Tue,  8 Nov 2022 14:39:46 +0100
Message-Id: <20221108133349.913542205@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 7433632c9ff68a991bd0bc38cabf354e9d2de410 upstream.

On some machines the number of listed CPUs may be bigger than the actual
CPUs that exist. The tracing subsystem allocates a per_cpu directory with
access to the per CPU ring buffer via a cpuX file. But to save space, the
ring buffer will only allocate buffers for online CPUs, even though the
CPU array will be as big as the nr_cpu_ids.

With the addition of waking waiters on the ring buffer when closing the
file, the ring_buffer_wake_waiters() now needs to make sure that the
buffer is allocated (with the irq_work allocated with it) before trying to
wake waiters, as it will cause a NULL pointer dereference.

While debugging this, I added a NULL check for the buffer itself (which is
OK to do), and also NULL pointer checks against buffer->buffers (which is
not fine, and will WARN) as well as making sure the CPU number passed in
is within the nr_cpu_ids (which is also not fine if it isn't).

Link: https://lore.kernel.org/all/87h6zklb6n.wl-tiwai@suse.de/
Link: https://lore.kernel.org/all/CAM6Wdxc0KRJMXVAA0Y=u6Jh2V=uWB-_Fn6M4xRuNppfXzL1mUg@mail.gmail.com/
Link: https://lkml.kernel.org/linux-trace-kernel/20221101191009.1e7378c8@rorschach.local.home

Cc: stable@vger.kernel.org
Cc: Steven Noonan <steven.noonan@gmail.com>
Bugzilla: https://bugzilla.opensuse.org/show_bug.cgi?id=1204705
Reported-by: Takashi Iwai <tiwai@suse.de>
Reported-by: Roland Ruckerbauer <roland.rucky@gmail.com>
Fixes: f3ddb74ad079 ("tracing: Wake up ring buffer waiters on closing of the file")
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -901,6 +901,9 @@ void ring_buffer_wake_waiters(struct tra
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct rb_irq_work *rbwork;
 
+	if (!buffer)
+		return;
+
 	if (cpu == RING_BUFFER_ALL_CPUS) {
 
 		/* Wake up individual ones too. One level recursion */
@@ -909,7 +912,15 @@ void ring_buffer_wake_waiters(struct tra
 
 		rbwork = &buffer->irq_work;
 	} else {
+		if (WARN_ON_ONCE(!buffer->buffers))
+			return;
+		if (WARN_ON_ONCE(cpu >= nr_cpu_ids))
+			return;
+
 		cpu_buffer = buffer->buffers[cpu];
+		/* The CPU buffer may not have been initialized yet */
+		if (!cpu_buffer)
+			return;
 		rbwork = &cpu_buffer->irq_work;
 	}
 


