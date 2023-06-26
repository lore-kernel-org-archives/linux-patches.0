Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BC0C8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111EAC433C9;
	Mon, 26 Jun 2023 18:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804552;
	bh=v7pmnwCE80ZhgGzf3m+4GZLv86wicdfa/gHJOKXld+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwne/lCdyzprHzuR25v4CdqqOV1+pxLO+qidNEPa1swMiYJTEwBlPOOYnA1y0Ewwm
	 DelSeH4EdntByEqnDRHQaagSykzeQfKodqAyjz/1lNbDZuYlBcSeKOp/NF6yeIUeh3
	 8DDju6bgvQVTSPgpRU0Q4/jWTpvgCOKojZ6yK+os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Segall <bsegall@google.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/60] epoll: ep_autoremove_wake_function should use list_del_init_careful
Date: Mon, 26 Jun 2023 20:11:43 +0200
Message-ID: <20230626180739.725179251@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180739.558575012@linuxfoundation.org>
References: <20230626180739.558575012@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Segall <bsegall@google.com>

[ Upstream commit 2192bba03d80f829233bfa34506b428f71e531e7 ]

autoremove_wake_function uses list_del_init_careful, so should epoll's
more aggressive variant.  It only doesn't because it was copied from an
older wait.c rather than the most recent.

[bsegall@google.com: add comment]
  Link: https://lkml.kernel.org/r/xm26bki0ulsr.fsf_-_@google.com
Link: https://lkml.kernel.org/r/xm26pm6hvfer.fsf@google.com
Fixes: a16ceb139610 ("epoll: autoremove wakers even more aggressively")
Signed-off-by: Ben Segall <bsegall@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 877f9f61a4e8d..8c0e94183186f 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1814,7 +1814,11 @@ static int ep_autoremove_wake_function(struct wait_queue_entry *wq_entry,
 {
 	int ret = default_wake_function(wq_entry, mode, sync, key);
 
-	list_del_init(&wq_entry->entry);
+	/*
+	 * Pairs with list_empty_careful in ep_poll, and ensures future loop
+	 * iterations see the cause of this wakeup.
+	 */
+	list_del_init_careful(&wq_entry->entry);
 	return ret;
 }
 
-- 
2.39.2



