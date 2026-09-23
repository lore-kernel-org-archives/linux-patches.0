Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F2853A390;
	Wed, 23 Sep 2026 14:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175312; cv=none; b=YKFpASPEqJWocmGDgdLgpme+YbF6pV/XML2b/1WZ2Si8CCmUoEDuvKpMhR9D1zEbC73fGJC6cheFNsVZZ8Z8N3L64w0vcsN5Yl03ymrjW8T0Su7vu+BSU81lWX1C/tKbgZrVw0Kt3EM3H/7aC5g2Hg86uyDsmP4GnhWcmxoiUQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175312; c=relaxed/simple;
	bh=5MS9CQQd0SfanUjiOS8JbF9CUO0xdNlY+ufBa9K7Cr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frIR+33keu7MAP9w/9F6qarVaG9YbHOC3xZ2aVB2tx2sbC+5qILmNw87WaCfvpBV73T5svElVCufM9xvtMwXzd2BQ23XzPR1P+0oKt7sVUqUOw3ba5ySE50Fn4l3B/STz658Z7CvUqO0YDa5/GmSg82vHlodTUG67c+Qd8AY5T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osvQLdyf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osvQLdyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3491F0089A;
	Wed, 23 Sep 2026 14:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175310;
	bh=YFr+uLmSJ9XfRPZ8xXzEsFaTRVShVkFLpALg53Q/CFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osvQLdyfdcIabGS2Gv5btRdsP8JGMVkOPCazloGFciwo5ic6dMaMNRCmgSbc9dt7I
	 vpY6EQtQ1ESxi81G2/y8ArRlfgSkZPUixDwWBYsxELab53aj/z78o+tZrgeTtEgpG2
	 i+FHygkTvTb5F4PZYozwfZwHgKos9oepI5AQoYZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Elizabeth Figura <zfigura@codeweavers.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.18 358/398] ntsync: Honour callers time namespace for absolute MONOTONIC timeouts
Date: Wed, 23 Sep 2026 16:07:12 +0200
Message-ID: <20260923140652.707368856@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 180a232ea78003d1dc869b217b4e49106fd58e8f upstream.

ntsync_schedule() takes the absolute timeout from userspace and hands it to
schedule_hrtimeout_range_clock() with HRTIMER_MODE_ABS. For the default
CLOCK_MONOTONIC path, it does not call timens_ktime_to_host() first.

A process inside a CLOCK_MONOTONIC time namespace computes the absolute
timeout in its own clock view. The kernel reads the same value against the
host clock. The two differ by the namespace offset.  The timeout then fires
too early or too late.

Other users of absolute timeouts run the ktime through
timens_ktime_to_host() before starting the hrtimer. ntsync was added later
and missed that step.

/dev/ntsync is mode 0666. Any user inside a time namespace that can
open it is affected. The visible effect is wrong timeout behaviour
for Wine in a container that sets a CLOCK_MONOTONIC offset.

Reproducer: unshare --user --time, set the monotonic offset to -10s,
issue NTSYNC_IOC_WAIT_ANY with a 100 ms absolute MONOTONIC timeout.
The baseline run elapses about 100 ms. The run inside the namespace
elapses about 0 ms.

Apply timens_ktime_to_host() to the parsed timeout when the caller
did not set NTSYNC_WAIT_REALTIME. The helper does nothing in the
initial time namespace, so the fast path is unchanged.

Fixes: b4a7b5fe3f51 ("ntsync: Introduce NTSYNC_IOC_WAIT_ANY.")
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Elizabeth Figura <zfigura@codeweavers.com>
Link: https://patch.msgid.link/20260528063311.3300393-3-maoyixie.tju@gmail.com
Cc: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/ntsync.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/misc/ntsync.c
+++ b/drivers/misc/ntsync.c
@@ -19,6 +19,7 @@
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/time_namespace.h>
 #include <uapi/linux/ntsync.h>
 
 #define NTSYNC_NAME	"ntsync"
@@ -845,6 +846,8 @@ static int ntsync_schedule(const struct
 
 	if (args->flags & NTSYNC_WAIT_REALTIME)
 		clock = CLOCK_REALTIME;
+	else
+		timeout = timens_ktime_to_host(clock, timeout);
 
 	do {
 		if (signal_pending(current)) {


