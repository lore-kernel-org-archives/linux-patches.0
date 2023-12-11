Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C014FC06;
	Mon, 11 Dec 2023 18:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkDR41ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F63C433C8;
	Mon, 11 Dec 2023 18:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320193;
	bh=AgKmNADJgK4mdLfe1Pnpx6vpwfSVIr8d+Ii96MC7LWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkDR41ey03osWkzyHo7AhT8rICrwNc0+QbF+zKYHOtzSJwBKhvn9gAHVVqIST9WEY
	 39kXxSDo0ojnDT8s6F7RE2nKocgxejcB8c+rjtCGkACax1xCamQtqz5vEn0Ut1v5RU
	 WkiWyNLDGN+USfP08OnsB4ggWnbQw3QDv3LjiYVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 39/67] tracing: Fix a possible race when disabling buffered events
Date: Mon, 11 Dec 2023 19:22:23 +0100
Message-ID: <20231211182016.739931885@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182015.049134368@linuxfoundation.org>
References: <20231211182015.049134368@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Pavlu <petr.pavlu@suse.com>

commit c0591b1cccf708a47bc465c62436d669a4213323 upstream.

Function trace_buffered_event_disable() is responsible for freeing pages
backing buffered events and this process can run concurrently with
trace_event_buffer_lock_reserve().

The following race is currently possible:

* Function trace_buffered_event_disable() is called on CPU 0. It
  increments trace_buffered_event_cnt on each CPU and waits via
  synchronize_rcu() for each user of trace_buffered_event to complete.

* After synchronize_rcu() is finished, function
  trace_buffered_event_disable() has the exclusive access to
  trace_buffered_event. All counters trace_buffered_event_cnt are at 1
  and all pointers trace_buffered_event are still valid.

* At this point, on a different CPU 1, the execution reaches
  trace_event_buffer_lock_reserve(). The function calls
  preempt_disable_notrace() and only now enters an RCU read-side
  critical section. The function proceeds and reads a still valid
  pointer from trace_buffered_event[CPU1] into the local variable
  "entry". However, it doesn't yet read trace_buffered_event_cnt[CPU1]
  which happens later.

* Function trace_buffered_event_disable() continues. It frees
  trace_buffered_event[CPU1] and decrements
  trace_buffered_event_cnt[CPU1] back to 0.

* Function trace_event_buffer_lock_reserve() continues. It reads and
  increments trace_buffered_event_cnt[CPU1] from 0 to 1. This makes it
  believe that it can use the "entry" that it already obtained but the
  pointer is now invalid and any access results in a use-after-free.

Fix the problem by making a second synchronize_rcu() call after all
trace_buffered_event values are set to NULL. This waits on all potential
users in trace_event_buffer_lock_reserve() that still read a previous
pointer from trace_buffered_event.

Link: https://lore.kernel.org/all/20231127151248.7232-2-petr.pavlu@suse.com/
Link: https://lkml.kernel.org/r/20231205161736.19663-4-petr.pavlu@suse.com

Cc: stable@vger.kernel.org
Fixes: 0fc1b09ff1ff ("tracing: Use temp buffer when filtering events")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2501,13 +2501,17 @@ void trace_buffered_event_disable(void)
 		free_page((unsigned long)per_cpu(trace_buffered_event, cpu));
 		per_cpu(trace_buffered_event, cpu) = NULL;
 	}
+
 	/*
-	 * Make sure trace_buffered_event is NULL before clearing
-	 * trace_buffered_event_cnt.
+	 * Wait for all CPUs that potentially started checking if they can use
+	 * their event buffer only after the previous synchronize_rcu() call and
+	 * they still read a valid pointer from trace_buffered_event. It must be
+	 * ensured they don't see cleared trace_buffered_event_cnt else they
+	 * could wrongly decide to use the pointed-to buffer which is now freed.
 	 */
-	smp_wmb();
+	synchronize_rcu();
 
-	/* Do the work on each cpu */
+	/* For each CPU, relinquish the buffer */
 	on_each_cpu_mask(tracing_buffer_mask, enable_trace_buffered_event, NULL,
 			 true);
 }


