Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3892A4BEE5E;
	Sat, 12 Sep 2026 15:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227181; cv=none; b=l+O2S7JS2acDUN7TBDuCfn7D/9x99QWkLbiycbdesAJHxC9BBfTKop9KRfw9oZh28lPBkw5xzLK0LLohp0S6e0AuLcsEqxfSnVmyd+MvsrtNOfmDJhuV0T1LNaY69sG++9OB/U5WhvoiNQ7fQAwH+nxvV0MGXQvyLTeLGcusYrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227181; c=relaxed/simple;
	bh=M7FMgG3fLsfqCBDjrf1S0y5x0x/PXVzuyrm7UoT8EOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jU6SDpKKq5SV/WFlJGkpSQmJK7XmlCH6Tlbl+0+hGPESnI8qUoF+dTcJtZLV8FsJOuF2rUbB3MHvcDZEXgJV3j2UkFP0Lbfgih4RyrWCjH3IlgRDuIi2s5lSXg/nySsZHgg4yuyXYi1b6Ay8EltSyXIqt3hy8HXdI0eFnhz8Mmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdCxxui8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdCxxui8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB2A1F000FF;
	Sat, 12 Sep 2026 15:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227180;
	bh=tDBKbyR4vKIMm5PMZNE1DiYneILD/ePjAY8o+/KcYkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdCxxui806a+YeurU/ZcCoPc8LQxX2i1xaxtlpy5QnFkWh1rAxNksKlnF7DkbHx0f
	 oZGwg1VZjeuXe+/4iZL6fRIPHh8Va0iYVdQYzMHkUmUlpShEIP8qKLTP41l6Qm8cX3
	 1NUDjtshdDWIydJ5/xM5r2QdGL5ADXjX2XScbr6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 0128/1191] SUNRPC: always drain cache_cleaner before destroying a cache_detail
Date: Sat, 12 Sep 2026 08:47:36 +0200
Message-ID: <20260912065551.068328603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


