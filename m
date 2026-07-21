Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8111546D570;
	Tue, 21 Jul 2026 18:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658889; cv=none; b=u3Ri4k6tS+o0lnjfEe3jh7+8QgsvYs4LuUpv/bkB8Gj+BvxuXX9eLvBbYQcjxxWlBs6gUoPp5VLGN7oSipbwJ9F6sqPBXtPFpwzkbF8Wv9aHJs4gqu2ihHOdEOOmy4imiOe3GkO0W8dphhTOjDrWJqpVTGZXZ6kZYHEaA8kNh4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658889; c=relaxed/simple;
	bh=SvvwLUrgDtGwsHNTevcLN7WZGCXXBMX6AAKj/0HynjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVibVgHUr/N4Aj3+y1UzQ1cSw3bLDQCY+FRc6SLXyVydJLeR6B4joKGFJb3QtQhSIO5ok2+EDauqCIlxzdKxLo4Hdz55DsEl2lcCswAkKl6Wft7A219dlK/gJbPJTVYa5ahRYesrM1pFt2ASv8nRDCeNDCjTtr9sy0Jk4l+Klls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCRKygUk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCRKygUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED331F000E9;
	Tue, 21 Jul 2026 18:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658888;
	bh=oY0ToXb5cou+XKu0r/S9A+cbqCyUHfZyMAzNFhtzg7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCRKygUkZj1jqQ7l27dsIz1KTmrBRTsCz9wM/pVmHhs9wZsoMonqCRLgPj68obAlT
	 gsstQpTsGspHACxakV7VaekrNpAtG19374Qfp3vWz0gxSUYxa1xGnBg4wAExW9Lopy
	 LtFgaDjw6p75XrpIthop8jdT+HVW+xA0xzhTeJd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 1315/1611] ufs: core: tracing: Do not dereference pointers in TP_printk()
Date: Tue, 21 Jul 2026 17:23:51 +0200
Message-ID: <20260721152545.034666520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit 535fcf4b8a261fbb8cc4f91e4597343c135a90f2 upstream.

The trace events in drivers/ufs/core/ufs_trace.h were converted to take a
pointer to the hba structure as an argument for the tracepoint and then in
TP_printk() the printing of the dev_name from the ring buffer was
converted to using the dev dereferenced pointer from the hba saved
pointer.

This is not allowed as the TP_printk() is executed at the time the trace
event is read from /sys/kernel/tracing/trace file. That can happen
literally, seconds, minutes, hours, weeks, days, or even months later!
There is no guarantee that the hba pointer will still exist by the time it
is dereferenced when the "trace" file is read.

Instead, save the device name from the hba pointer at the time the
tracepoint is called and place it into the ring buffer event. Then the
TP_printk() can read the name directly from the ring buffer and remove the
possibility that it will read a freed pointer and crash the kernel.

This was detected when testing the trace event code that looks for
TP_printk() parameters doing illegal derferences[1]

[1] https://lore.kernel.org/all/20260630184836.74d477b6@gandalf.local.home/

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260630185412.283c26c5@gandalf.local.home
Fixes: 583e518e71003 ("scsi: ufs: core: Add hba parameter to trace events")
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufs_trace.h |   36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

--- a/drivers/ufs/core/ufs_trace.h
+++ b/drivers/ufs/core/ufs_trace.h
@@ -90,16 +90,18 @@ TRACE_EVENT(ufshcd_clk_gating,
 
 	TP_STRUCT__entry(
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__field(int, state)
 	),
 
 	TP_fast_assign(
+		__assign_str(dev_name);
 		__entry->hba = hba;
 		__entry->state = state;
 	),
 
 	TP_printk("%s: gating state changed to %s",
-		dev_name(__entry->hba->dev),
+		__get_str(dev_name),
 		__print_symbolic(__entry->state, UFSCHD_CLK_GATING_STATES))
 );
 
@@ -112,6 +114,7 @@ TRACE_EVENT(ufshcd_clk_scaling,
 
 	TP_STRUCT__entry(
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__string(state, state)
 		__string(clk, clk)
 		__field(u32, prev_state)
@@ -120,6 +123,7 @@ TRACE_EVENT(ufshcd_clk_scaling,
 
 	TP_fast_assign(
 		__entry->hba = hba;
+		__assign_str(dev_name);
 		__assign_str(state);
 		__assign_str(clk);
 		__entry->prev_state = prev_state;
@@ -127,7 +131,7 @@ TRACE_EVENT(ufshcd_clk_scaling,
 	),
 
 	TP_printk("%s: %s %s from %u to %u Hz",
-		dev_name(__entry->hba->dev), __get_str(state), __get_str(clk),
+		__get_str(dev_name), __get_str(state), __get_str(clk),
 		__entry->prev_state, __entry->curr_state)
 );
 
@@ -139,16 +143,18 @@ TRACE_EVENT(ufshcd_auto_bkops_state,
 
 	TP_STRUCT__entry(
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__string(state, state)
 	),
 
 	TP_fast_assign(
 		__entry->hba = hba;
+		__assign_str(dev_name);
 		__assign_str(state);
 	),
 
 	TP_printk("%s: auto bkops - %s",
-		dev_name(__entry->hba->dev), __get_str(state))
+		__get_str(dev_name), __get_str(state))
 );
 
 DECLARE_EVENT_CLASS(ufshcd_profiling_template,
@@ -159,6 +165,7 @@ DECLARE_EVENT_CLASS(ufshcd_profiling_tem
 
 	TP_STRUCT__entry(
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__string(profile_info, profile_info)
 		__field(s64, time_us)
 		__field(int, err)
@@ -166,13 +173,14 @@ DECLARE_EVENT_CLASS(ufshcd_profiling_tem
 
 	TP_fast_assign(
 		__entry->hba = hba;
+		__assign_str(dev_name);
 		__assign_str(profile_info);
 		__entry->time_us = time_us;
 		__entry->err = err;
 	),
 
 	TP_printk("%s: %s: took %lld usecs, err %d",
-		dev_name(__entry->hba->dev), __get_str(profile_info),
+		__get_str(dev_name), __get_str(profile_info),
 		__entry->time_us, __entry->err)
 );
 
@@ -201,6 +209,7 @@ DECLARE_EVENT_CLASS(ufshcd_template,
 		__field(s64, usecs)
 		__field(int, err)
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__field(int, dev_state)
 		__field(int, link_state)
 	),
@@ -209,13 +218,14 @@ DECLARE_EVENT_CLASS(ufshcd_template,
 		__entry->usecs = usecs;
 		__entry->err = err;
 		__entry->hba = hba;
+		__assign_str(dev_name);
 		__entry->dev_state = dev_state;
 		__entry->link_state = link_state;
 	),
 
 	TP_printk(
 		"%s: took %lld usecs, dev_state: %s, link_state: %s, err %d",
-		dev_name(__entry->hba->dev),
+		__get_str(dev_name),
 		__entry->usecs,
 		__print_symbolic(__entry->dev_state, UFS_PWR_MODES),
 		__print_symbolic(__entry->link_state, UFS_LINK_STATES),
@@ -280,6 +290,7 @@ TRACE_EVENT(ufshcd_command,
 	TP_STRUCT__entry(
 		__field(struct scsi_device *, sdev)
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(&sdev->sdev_dev))
 		__field(enum ufs_trace_str_t, str_t)
 		__field(unsigned int, tag)
 		__field(u32, doorbell)
@@ -292,6 +303,7 @@ TRACE_EVENT(ufshcd_command,
 	),
 
 	TP_fast_assign(
+		__assign_str(dev_name);
 		__entry->sdev = sdev;
 		__entry->hba = hba;
 		__entry->str_t = str_t;
@@ -308,7 +320,7 @@ TRACE_EVENT(ufshcd_command,
 	TP_printk(
 		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 0x%x (%s), group_id: 0x%x, hwq_id: %d",
 		show_ufs_cmd_trace_str(__entry->str_t),
-		dev_name(&__entry->sdev->sdev_dev), __entry->tag,
+		__get_str(dev_name), __entry->tag,
 		__entry->doorbell, __entry->transfer_len, __entry->intr,
 		__entry->lba, (u32)__entry->opcode, str_opcode(__entry->opcode),
 		(u32)__entry->group_id, __entry->hwq_id
@@ -323,6 +335,7 @@ TRACE_EVENT(ufshcd_uic_command,
 
 	TP_STRUCT__entry(
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__field(enum ufs_trace_str_t, str_t)
 		__field(u32, cmd)
 		__field(u32, arg1)
@@ -332,6 +345,7 @@ TRACE_EVENT(ufshcd_uic_command,
 
 	TP_fast_assign(
 		__entry->hba = hba;
+		__assign_str(dev_name);
 		__entry->str_t = str_t;
 		__entry->cmd = cmd;
 		__entry->arg1 = arg1;
@@ -341,7 +355,7 @@ TRACE_EVENT(ufshcd_uic_command,
 
 	TP_printk(
 		"%s: %s: cmd: 0x%x, arg1: 0x%x, arg2: 0x%x, arg3: 0x%x",
-		show_ufs_cmd_trace_str(__entry->str_t), dev_name(__entry->hba->dev),
+		show_ufs_cmd_trace_str(__entry->str_t), __get_str(dev_name),
 		__entry->cmd, __entry->arg1, __entry->arg2, __entry->arg3
 	)
 );
@@ -354,6 +368,7 @@ TRACE_EVENT(ufshcd_upiu,
 
 	TP_STRUCT__entry(
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__field(enum ufs_trace_str_t, str_t)
 		__array(unsigned char, hdr, 12)
 		__array(unsigned char, tsf, 16)
@@ -362,6 +377,7 @@ TRACE_EVENT(ufshcd_upiu,
 
 	TP_fast_assign(
 		__entry->hba = hba;
+		__assign_str(dev_name);
 		__entry->str_t = str_t;
 		memcpy(__entry->hdr, hdr, sizeof(__entry->hdr));
 		memcpy(__entry->tsf, tsf, sizeof(__entry->tsf));
@@ -370,7 +386,7 @@ TRACE_EVENT(ufshcd_upiu,
 
 	TP_printk(
 		"%s: %s: HDR:%s, %s:%s",
-		show_ufs_cmd_trace_str(__entry->str_t), dev_name(__entry->hba->dev),
+		show_ufs_cmd_trace_str(__entry->str_t), __get_str(dev_name),
 		__print_hex(__entry->hdr, sizeof(__entry->hdr)),
 		show_ufs_cmd_trace_tsf(__entry->tsf_t),
 		__print_hex(__entry->tsf, sizeof(__entry->tsf))
@@ -385,16 +401,18 @@ TRACE_EVENT(ufshcd_exception_event,
 
 	TP_STRUCT__entry(
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__field(u16, status)
 	),
 
 	TP_fast_assign(
 		__entry->hba = hba;
+		__assign_str(dev_name);
 		__entry->status = status;
 	),
 
 	TP_printk("%s: status 0x%x",
-		dev_name(__entry->hba->dev), __entry->status
+		__get_str(dev_name), __entry->status
 	)
 );
 


