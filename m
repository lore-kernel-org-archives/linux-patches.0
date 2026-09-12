Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1169347C11A;
	Sat, 12 Sep 2026 13:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220328; cv=none; b=fq/B5q0OQ7qshUw25dbK+drlMtYNyswnOSJ4Z5QQQF0JTa3gqX1GtQTouaYASCancaR9/y8GT5AbuO5gdykSsTf5+EmZGEiLOFmYZfMnhsNpSEanA/vJ/CcCohZGDC4AKm4nW0Nbvwznf9zjzf5dganaeT9IUUCXvDrWt7oKcUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220328; c=relaxed/simple;
	bh=NOKFpQne5Y/1V6N6iffXnY/qf0TQdwHBdAt3fgB9Pss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbTpjc8haH4+IsLZXuJvoKHZmmwfruG1dxHNw2lhherGuOy8kv3dW8raS6apbJllh4Gh7AIUfnGsu70B6QkGhaDLcvjMIpCN6mOYm8eSgvxELmCEQk3TgcSdVKQQs1Qmn6LU/raUgcNvq5yHbUMWlNH7sCsjNi/crhqfEXpkx8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+3pJiRI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+3pJiRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A0A1F000FF;
	Sat, 12 Sep 2026 13:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220326;
	bh=b/nMjhEn620XDggYS4JOb4g6o74MAOZ7vYrJ58CLybg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+3pJiRIBtQPWh7qGr/z6mjbeb0BZVJrakJsn8iabA7Uy/vZQpADvL0PrV77+0cCp
	 e9QQ0nW4H5Zxxv7Wnsp8oRat4M/TP/RP5DJgaV3rrwNC0+VVRSXw+gPBykWmwTlimf
	 wIO3HCQcDpHRheNsIZoqHjtcsVCLjvWXUWiIuSu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 0153/1424] SUNRPC: always drain cache_cleaner before destroying a cache_detail
Date: Sat, 12 Sep 2026 08:43:05 +0200
Message-ID: <20260912065610.723313221@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


