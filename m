Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95611417BF8;
	Fri,  4 Sep 2026 06:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502432; cv=none; b=Tf3LLcH3xlPqTo7aHGhIIQQc/RZ/STa5g7cMvAuG8Lt6mhmI0fLM/IttJH6bc9vkvelLaZRqDnFO2uIgJYbL26AKDnU0szIbdpbv4E4Y16isaehgU5jWinA4er83aKKER1omIdcB0n7z74sbX4od77iiTwlZviI2eSSXbZCAXtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502432; c=relaxed/simple;
	bh=seMJaQEWW4eFJ1w147WzR18nzsQgzEJdMgyVUGzkG10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUGxdU8cRqcim7jiJqwQPVXtqBhw3A9aujbBvctt5E5D59qlo/6SuEdQ+uAH4NrUabHMY5nWubaTrYsFHM4SUfRKFgZ/EEXb6Igow5fd23FXp2ZWyGN1PeejrxEanwcZLP3Zdl/49dHuwWRLeJFLC3RshqhkHtxiKXg/kXqpAVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7ZhYFHr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7ZhYFHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3141F00A3D;
	Fri,  4 Sep 2026 06:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502431;
	bh=kBVH+gZqjGbgWTRa/TPgKk/tk/WbramVPKaSQMqjKEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7ZhYFHro6IyYN6FXAizHv7OPwkE00vQek+xtWWFqZO5ktR2d8hYC+dfxe9QxR0cI
	 TLXeOSouue1Q18gStdmYtFAQTVzGEGk51fSD0MiDzylQH/g4uIvGiUTbuFl3QiIO1N
	 FVZn+NUn4PtXZnVZ35yKxBMiWaioN6MjpnIaMJoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 205/403] SUNRPC: always drain cache_cleaner before destroying a cache_detail
Date: Fri,  4 Sep 2026 07:00:08 +0200
Message-ID: <20260904045739.516638827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit f42d0fda0c67695db6bc704b04b7c10240805377 upstream.

sunrpc_destroy_cache_detail() only cancels the global cache_cleaner
delayed_work when cache_list is empty.  During per-netns teardown
cache_list is never empty because init_net's caches remain registered,
so the cancel never fires.  After unlink, the caller proceeds to
cache_destroy_net() which kfrees the cache_detail while cache_clean()
may still hold a dangling pointer to it.  The result is a
use-after-free: cache_dequeue() takes cd->queue_lock on freed memory,
and cache_put() dereferences cd->cache_put as a function pointer from
freed slab.

Drop the list_empty guard so that cancel_delayed_work_sync() always
runs, ensuring any in-flight cache_clean() completes before the
cache_detail is freed.  Re-arm the cleaner afterwards if other caches
are still registered.

Fixes: 820f9442e711 ("SUNRPC: split cache creation and PipeFS registration")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260526-cache_cleaner_vs_destroy_no_sync-v1-1-a707a6fcfd32@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/cache.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -410,10 +410,9 @@ void sunrpc_destroy_cache_detail(struct
 	list_del_init(&cd->others);
 	spin_unlock(&cd->hash_lock);
 	spin_unlock(&cache_list_lock);
-	if (list_empty(&cache_list)) {
-		/* module must be being unloaded so its safe to kill the worker */
-		cancel_delayed_work_sync(&cache_cleaner);
-	}
+	cancel_delayed_work_sync(&cache_cleaner);
+	if (!list_empty(&cache_list))
+		queue_delayed_work(system_power_efficient_wq, &cache_cleaner, 0);
 }
 EXPORT_SYMBOL_GPL(sunrpc_destroy_cache_detail);
 


