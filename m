Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E230C3081D4;
	Mon, 13 Oct 2025 15:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370197; cv=none; b=fYtxSAqakJYpxCi3SaTYCWn4BFSqBP9tvK65NP+4B5aiBQxUXjMBhQRgLLD2xTdGotJ8JPX5OelcF13pO3FObaFo0Ei86HBUF8yzktE7DEHcQMFc52OQrpESGWRxEgiWW5ZYVSUFA2QTWf7OBfIO3bB4R/nchvdMAHHAhJr35CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370197; c=relaxed/simple;
	bh=ufCY0hAMzbjhckhHVAVUvyBgE2ig6MhzGIV1FlY9IRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlyyCHbvt2uIhC4tFir/CiX4NQdf+iEmLeqVJcpE3+9fmqLb6dlyOh/xFX3ZXvspgp7n8zFUop3kokuk4Mh78gQo7ptNdS5uGdhfUF5dDgedh8+eTb9m+5Ppw4CxJmTWKluH/DbWTGstMsFpkHJKzg/SJZYL5UOehFNrxGE2DzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlSMHlYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlSMHlYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D51C116B1;
	Mon, 13 Oct 2025 15:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370196;
	bh=ufCY0hAMzbjhckhHVAVUvyBgE2ig6MhzGIV1FlY9IRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlSMHlYSjDuWdlPX67eydr6ZYeCtBdfsFsNcvoQCN0Grj0pd7JPCyG1O7SMmNUCc2
	 7Jh3mnazurnCjXC/p0jaIbJ67GMsM+q3PEB/jK0AlUkfmzAmoaZgdQbaUC/PuhyIDC
	 uiwSFxTQLaPyeEF/9riN2T03w0zv7cxjThHwRDGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.17 512/563] tracing: Fix lock imbalance in s_start() memory allocation failure path
Date: Mon, 13 Oct 2025 16:46:13 +0200
Message-ID: <20251013144429.856910300@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sashal@kernel.org>

commit 61e19cd2e5c5235326a13a68df1a2f8ec4eeed7b upstream.

When s_start() fails to allocate memory for set_event_iter, it returns NULL
before acquiring event_mutex. However, the corresponding s_stop() function
always tries to unlock the mutex, causing a lock imbalance warning:

  WARNING: bad unlock balance detected!
  6.17.0-rc7-00175-g2b2e0c04f78c #7 Not tainted
  -------------------------------------
  syz.0.85611/376514 is trying to release lock (event_mutex) at:
  [<ffffffff8dafc7a4>] traverse.part.0.constprop.0+0x2c4/0x650 fs/seq_file.c:131
  but there are no more locks to release!

The issue was introduced by commit b355247df104 ("tracing: Cache ':mod:'
events for modules not loaded yet") which added the kzalloc() allocation before
the mutex lock, creating a path where s_start() could return without locking
the mutex while s_stop() would still try to unlock it.

Fix this by unconditionally acquiring the mutex immediately after allocation,
regardless of whether the allocation succeeded.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250929113238.3722055-1-sashal@kernel.org
Fixes: b355247df104 ("tracing: Cache ":mod:" events for modules not loaded yet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 9f3e9537417d..e00da4182deb 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1629,11 +1629,10 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 	loff_t l;
 
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	mutex_lock(&event_mutex);
 	if (!iter)
 		return NULL;
 
-	mutex_lock(&event_mutex);
-
 	iter->type = SET_EVENT_FILE;
 	iter->file = list_entry(&tr->events, struct trace_event_file, list);
 
-- 
2.51.0



