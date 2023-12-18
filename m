Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614D437885;
	Mon, 18 Dec 2023 14:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyTUVMtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACF6C433C7;
	Mon, 18 Dec 2023 14:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908894;
	bh=pxi9T3BuCHrrPaNQH32WdWEhzh+4Wq/h+oPeY6ntXGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyTUVMtRbs6C08LxCKLm6GoUniJs5OvGPhnJ909iI63dZlozMdnXP7/XOhP7TvzfD
	 6OtWSxpDJHWjg8Dj+SuC0j8T8t0TLXePJNhNde89dfl63+gPN0mPn0afAZCcjZP/Fh
	 4ekZzIAX/UZeZOL/uBhqU3STIKxQT7dYzVpniQqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5.15 73/83] ring-buffer: Fix writing to the buffer with max_data_size
Date: Mon, 18 Dec 2023 14:52:34 +0100
Message-ID: <20231218135052.937453171@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit b3ae7b67b87fed771fa5bf95389df06b0433603e upstream.

The maximum ring buffer data size is the maximum size of data that can be
recorded on the ring buffer. Events must be smaller than the sub buffer
data size minus any meta data. This size is checked before trying to
allocate from the ring buffer because the allocation assumes that the size
will fit on the sub buffer.

The maximum size was calculated as the size of a sub buffer page (which is
currently PAGE_SIZE minus the sub buffer header) minus the size of the
meta data of an individual event. But it missed the possible adding of a
time stamp for events that are added long enough apart that the event meta
data can't hold the time delta.

When an event is added that is greater than the current BUF_MAX_DATA_SIZE
minus the size of a time stamp, but still less than or equal to
BUF_MAX_DATA_SIZE, the ring buffer would go into an infinite loop, looking
for a page that can hold the event. Luckily, there's a check for this loop
and after 1000 iterations and a warning is emitted and the ring buffer is
disabled. But this should never happen.

This can happen when a large event is added first, or after a long period
where an absolute timestamp is prefixed to the event, increasing its size
by 8 bytes. This passes the check and then goes into the algorithm that
causes the infinite loop.

For events that are the first event on the sub-buffer, it does not need to
add a timestamp, because the sub-buffer itself contains an absolute
timestamp, and adding one is redundant.

The fix is to check if the event is to be the first event on the
sub-buffer, and if it is, then do not add a timestamp.

This also fixes 32 bit adding a timestamp when a read of before_stamp or
write_stamp is interrupted. There's still no need to add that timestamp if
the event is going to be the first event on the sub buffer.

Also, if the buffer has "time_stamp_abs" set, then also check if the
length plus the timestamp is greater than the BUF_MAX_DATA_SIZE.

Link: https://lore.kernel.org/all/20231212104549.58863438@gandalf.local.home/
Link: https://lore.kernel.org/linux-trace-kernel/20231212071837.5fdd6c13@gandalf.local.home
Link: https://lore.kernel.org/linux-trace-kernel/20231212111617.39e02849@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: a4543a2fa9ef3 ("ring-buffer: Get timestamp after event is allocated")
Fixes: 58fbc3c63275c ("ring-buffer: Consolidate add_timestamp to remove some branches")
Reported-by: Kent Overstreet <kent.overstreet@linux.dev> # (on IRC)
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3535,7 +3535,10 @@ __rb_reserve_next(struct ring_buffer_per
 		 * absolute timestamp.
 		 * Don't bother if this is the start of a new page (w == 0).
 		 */
-		if (unlikely(!a_ok || !b_ok || (info->before != info->after && w))) {
+		if (!w) {
+			/* Use the sub-buffer timestamp */
+			info->delta = 0;
+		} else if (unlikely(!a_ok || !b_ok || info->before != info->after)) {
 			info->add_timestamp |= RB_ADD_STAMP_FORCE | RB_ADD_STAMP_EXTEND;
 			info->length += RB_LEN_TIME_EXTEND;
 		} else {
@@ -3686,6 +3689,8 @@ rb_reserve_next_event(struct trace_buffe
 	if (ring_buffer_time_stamp_abs(cpu_buffer->buffer)) {
 		add_ts_default = RB_ADD_STAMP_ABSOLUTE;
 		info.length += RB_LEN_TIME_EXTEND;
+		if (info.length > BUF_MAX_DATA_SIZE)
+			goto out_fail;
 	} else {
 		add_ts_default = RB_ADD_STAMP_NONE;
 	}


