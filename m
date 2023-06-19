Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29851095B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491D9C433C8;
	Mon, 19 Jun 2023 10:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170818;
	bh=ZOz9DKPiQ/1vuz5mEALs5ZmPscV62uX3Ch3lWDK52K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ti5aqdMaWCpE0qAfP7Ka6A84BKz4fsf8+eF//t4jI3HPOIPy+ePJb1fon+w71JRVc
	 dur9JBqFCa1i+zM9horzmkwEH8mbRHP9Psk/xgt0stAxa+WYcL1k6XCckPBgQfo+v+
	 0nxV/IKiG2fn4UKB33QwLfbIxWSj6Kxo5IrveBdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Segall <bsegall@google.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.3 047/187] epoll: ep_autoremove_wake_function should use list_del_init_careful
Date: Mon, 19 Jun 2023 12:27:45 +0200
Message-ID: <20230619102159.886339553@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
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

commit 2192bba03d80f829233bfa34506b428f71e531e7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1760,7 +1760,11 @@ static int ep_autoremove_wake_function(s
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
 


