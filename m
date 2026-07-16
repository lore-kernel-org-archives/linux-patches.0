Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2B93CC9E8;
	Thu, 16 Jul 2026 13:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210356; cv=none; b=S2cm2Igb7pNgrUY4oOufWyakzEPEaehXdS8eF60qnXUCyS6rUa3oXJejKP+2V7viQ2Ixmq5UPZI1dPy1BNPOxsa/Porl9KPF96i5xXFZVxnxm6Kp8KnMCkWPOHV2mqGhHx693IXogk2PnWJAM6390GLZ/kRbn9oURBlIGOzliMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210356; c=relaxed/simple;
	bh=Uk6neQRYKLiqGq3UWVOUsdtDVc54cXbrY9NFuG4ibao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGaWMYH6xRgN+btVdNhKHt5n+dqsZ1ya8SCmlmXUO9C2dNzeSU7CLhVnS9W7LYNHsanZqu/wsLriMBmgE9lXEsrfvXrikX0U5AU0CQzmWqgkm+c9Db2dJSN6BzZZx0ZSHxLZMJa3sibpcqyjkMqrGH3CABT8Au0eb7PmS3l6drY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wUANEwk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wUANEwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA491F000E9;
	Thu, 16 Jul 2026 13:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210355;
	bh=rGjzVhQQkG/oayJSlzVG+Vb4iGj0AqxjD79LytsDEGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2wUANEwksD/MRVrzX6UPqlJClIkcQzAUnmbiNH2xdr94rUWT2SCvXg/yM/yTOVnpw
	 TtDX+h4e81YztgmQt0I+0fu0ztdFZzzcjVkeEH5wqqcHx/RRrqFmYuflc0U9qOwEFv
	 2D66Fz8Nn8aFgAJ41+ElRDjLllSGV3cw0gbD7cNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YH Lin <yhli@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 017/480] f2fs: optimize trace_f2fs_write_checkpoint with enums
Date: Thu, 16 Jul 2026 15:26:04 +0200
Message-ID: <20260716133045.066506857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: YH Lin <yhli@google.com>

[ Upstream commit 8d1cb17aca466b361cca17834b8bb1cf3e3d1818 ]

This patch optimizes the tracepoint by replacing these hardcoded strings
with a new enumeration f2fs_cp_phase.

1.Defines enum f2fs_cp_phase with values for each checkpoint phase.
2.Updates trace_f2fs_write_checkpoint to accept a u16 phase argument
instead of a string pointer.
3.Uses __print_symbolic in TP_printk to convert the enum values
back to their corresponding strings for human-readable trace output.

This change reduces the storage overhead for each trace event
by replacing a variable-length string with a 2-byte integer,
while maintaining the same readable output in ftrace.

Signed-off-by: YH Lin <yhli@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 8712353ed80f ("f2fs: fix to do sanity check on f2fs_get_node_folio_ra()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/checkpoint.c        |    6 +++---
 fs/f2fs/f2fs.h              |    6 ++++++
 include/trace/events/f2fs.h |   19 ++++++++++++++-----
 3 files changed, 23 insertions(+), 8 deletions(-)

--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1685,7 +1685,7 @@ int f2fs_write_checkpoint(struct f2fs_sb
 		goto out;
 	}
 
-	trace_f2fs_write_checkpoint(sbi->sb, cpc->reason, "start block_ops");
+	trace_f2fs_write_checkpoint(sbi->sb, cpc->reason, CP_PHASE_START_BLOCK_OPS);
 
 	err = block_operations(sbi);
 	if (err)
@@ -1693,7 +1693,7 @@ int f2fs_write_checkpoint(struct f2fs_sb
 
 	stat_cp_time(cpc, CP_TIME_OP_LOCK);
 
-	trace_f2fs_write_checkpoint(sbi->sb, cpc->reason, "finish block_ops");
+	trace_f2fs_write_checkpoint(sbi->sb, cpc->reason, CP_PHASE_FINISH_BLOCK_OPS);
 
 	f2fs_flush_merged_writes(sbi);
 
@@ -1759,7 +1759,7 @@ stop:
 
 	/* update CP_TIME to trigger checkpoint periodically */
 	f2fs_update_time(sbi, CP_TIME);
-	trace_f2fs_write_checkpoint(sbi->sb, cpc->reason, "finish checkpoint");
+	trace_f2fs_write_checkpoint(sbi->sb, cpc->reason, CP_PHASE_FINISH_CHECKPOINT);
 out:
 	if (cpc->reason != CP_RESIZE)
 		f2fs_up_write(&sbi->cp_global_sem);
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -319,6 +319,12 @@ struct cp_control {
 	struct cp_stats stats;
 };
 
+enum f2fs_cp_phase {
+	CP_PHASE_START_BLOCK_OPS,
+	CP_PHASE_FINISH_BLOCK_OPS,
+	CP_PHASE_FINISH_CHECKPOINT,
+};
+
 /*
  * indicate meta/data type
  */
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -50,6 +50,9 @@ TRACE_DEFINE_ENUM(CP_PAUSE);
 TRACE_DEFINE_ENUM(CP_RESIZE);
 TRACE_DEFINE_ENUM(EX_READ);
 TRACE_DEFINE_ENUM(EX_BLOCK_AGE);
+TRACE_DEFINE_ENUM(CP_PHASE_START_BLOCK_OPS);
+TRACE_DEFINE_ENUM(CP_PHASE_FINISH_BLOCK_OPS);
+TRACE_DEFINE_ENUM(CP_PHASE_FINISH_CHECKPOINT);
 
 #define show_block_type(type)						\
 	__print_symbolic(type,						\
@@ -175,6 +178,12 @@ TRACE_DEFINE_ENUM(EX_BLOCK_AGE);
 #define S_ALL_PERM	(S_ISUID | S_ISGID | S_ISVTX |	\
 			S_IRWXU | S_IRWXG | S_IRWXO)
 
+#define show_cp_phase(phase)					\
+	__print_symbolic(phase,						\
+		{ CP_PHASE_START_BLOCK_OPS,		"start block_ops" },			\
+		{ CP_PHASE_FINISH_BLOCK_OPS,	"finish block_ops" },			\
+		{ CP_PHASE_FINISH_CHECKPOINT,	"finish checkpoint" })
+
 struct f2fs_sb_info;
 struct f2fs_io_info;
 struct extent_info;
@@ -1541,26 +1550,26 @@ TRACE_EVENT(f2fs_readpages,
 
 TRACE_EVENT(f2fs_write_checkpoint,
 
-	TP_PROTO(struct super_block *sb, int reason, const char *msg),
+	TP_PROTO(struct super_block *sb, int reason, u16 phase),
 
-	TP_ARGS(sb, reason, msg),
+	TP_ARGS(sb, reason, phase),
 
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
 		__field(int,	reason)
-		__string(dest_msg, msg)
+		__field(u16, phase)
 	),
 
 	TP_fast_assign(
 		__entry->dev		= sb->s_dev;
 		__entry->reason		= reason;
-		__assign_str(dest_msg);
+		__entry->phase		= phase;
 	),
 
 	TP_printk("dev = (%d,%d), checkpoint for %s, state = %s",
 		show_dev(__entry->dev),
 		show_cpreason(__entry->reason),
-		__get_str(dest_msg))
+		show_cp_phase(__entry->phase))
 );
 
 DECLARE_EVENT_CLASS(f2fs_discard,


