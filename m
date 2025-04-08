Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5E8268C5D;
	Tue,  8 Apr 2025 11:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111767; cv=none; b=H1DpCiB6YSmwXHsxkglsbhBso43nzjTd2I+oy9XfKF4OoShQsmNK0gEtEyhfhrDQ8zGXaBKgsBxbZpI1o78C+O4YlfNsXmaRLYB+TqFQXlnAYBaR23jqONYqBIuUc/6vWxb35YpdHsddoVZuuMl4BgRKbWWpBNchcVjX1M2dMOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111767; c=relaxed/simple;
	bh=/Fb8PK4IfEccC+wldkRQ6HQoZBnqHXfxq+t+5ujSLPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4EP2U00t3yttCxYLhJYEzKHwYvIZP37CIhvB1u4MxUUovh3cPVW2jWBpm+jG2HCfi5hzseh9oO5u3M7dK40lTRCnnKqmY0P5Fs5/jmTSSqyoG1u8tIT80c7UF07ssXKRKd2l0vwqHYmQw8gTmlIJjYpIcAZhxpbTgnikiPfTgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEhKaoC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEhKaoC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED926C4CEE5;
	Tue,  8 Apr 2025 11:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111767;
	bh=/Fb8PK4IfEccC+wldkRQ6HQoZBnqHXfxq+t+5ujSLPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEhKaoC8anX9Mgpmn3qRtWaUqgHU58LThxstwpP9aBLdhjqYBRTRUlz9cFPE6elre
	 bBuKhax79vaEcBpOGwNh0uhT5AdRjJ02QF5k9gc9u5cBCAjmOOwEX77JhElld6Zbt2
	 Lq92ZRTbnmqeaS4gcqqx+Bcdv5kdKIGQEPa/czzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tang Yizhou <yizhou.tang@shopee.com>,
	Tejun Heo <tj@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Matthew Wilcow (Oracle)" <willy@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 513/731] writeback: fix calculations in trace_balance_dirty_pages() for cgwb
Date: Tue,  8 Apr 2025 12:46:50 +0200
Message-ID: <20250408104926.207678232@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tang Yizhou <yizhou.tang@shopee.com>

[ Upstream commit 6cc4c3aa714bc58ec5d20f3054ca5f23534984d1 ]

In the commit dcc25ae76eb7 ("writeback: move global_dirty_limit into
wb_domain") of the cgroup writeback backpressure propagation patchset,
Tejun made some adaptations to trace_balance_dirty_pages() for cgroup
writeback.  However, this adaptation was incomplete and Tejun missed
further adaptation in the subsequent patches.

In the cgroup writeback scenario, if sdtc in balance_dirty_pages() is
assigned to mdtc, then upon entering trace_balance_dirty_pages(),
__entry->limit should be assigned based on the dirty_limit of the
corresponding memcg's wb_domain, rather than global_wb_domain.

To address this issue and simplify the implementation, introduce a 'limit'
field in struct dirty_throttle_control to store the hard_limit value
computed in wb_position_ratio() by calling hard_dirty_limit().  This field
will then be used in trace_balance_dirty_pages() to assign the value to
__entry->limit.

Link: https://lkml.kernel.org/r/20250304110318.159567-4-yizhou.tang@shopee.com
Fixes: dcc25ae76eb7 ("writeback: move global_dirty_limit into wb_domain")
Signed-off-by: Tang Yizhou <yizhou.tang@shopee.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/writeback.h        | 1 +
 include/trace/events/writeback.h | 5 ++---
 mm/page-writeback.c              | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 32095928365ce..58bda33479146 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -326,6 +326,7 @@ struct dirty_throttle_control {
 	unsigned long		dirty;		/* file_dirty + write + nfs */
 	unsigned long		thresh;		/* dirty threshold */
 	unsigned long		bg_thresh;	/* dirty background threshold */
+	unsigned long		limit;		/* hard dirty limit */
 
 	unsigned long		wb_dirty;	/* per-wb counterparts */
 	unsigned long		wb_thresh;
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 3213b90237944..5755c2a569e16 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -663,9 +663,8 @@ TRACE_EVENT(balance_dirty_pages,
 		unsigned long freerun = (dtc->thresh + dtc->bg_thresh) / 2;
 		strscpy_pad(__entry->bdi, bdi_dev_name(wb->bdi), 32);
 
-		__entry->limit		= global_wb_domain.dirty_limit;
-		__entry->setpoint	= (global_wb_domain.dirty_limit +
-						freerun) / 2;
+		__entry->limit		= dtc->limit;
+		__entry->setpoint	= (dtc->limit + freerun) / 2;
 		__entry->dirty		= dtc->dirty;
 		__entry->bdi_setpoint	= __entry->setpoint *
 						dtc->wb_thresh / (dtc->thresh + 1);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e980b2aec3529..3147119a9a042 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1072,7 +1072,7 @@ static void wb_position_ratio(struct dirty_throttle_control *dtc)
 	struct bdi_writeback *wb = dtc->wb;
 	unsigned long write_bw = READ_ONCE(wb->avg_write_bandwidth);
 	unsigned long freerun = dirty_freerun_ceiling(dtc->thresh, dtc->bg_thresh);
-	unsigned long limit = hard_dirty_limit(dtc_dom(dtc), dtc->thresh);
+	unsigned long limit = dtc->limit = hard_dirty_limit(dtc_dom(dtc), dtc->thresh);
 	unsigned long wb_thresh = dtc->wb_thresh;
 	unsigned long x_intercept;
 	unsigned long setpoint;		/* dirty pages' target balance point */
-- 
2.39.5



