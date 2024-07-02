Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A3B15B0FE;
	Tue,  2 Jul 2024 17:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940414; cv=none; b=D1LWPn/X99WIsC0m1T2trOQw81Z0hDNCsDsImoDXlHiGtbOrlrwxfRE+s2RIxYGFghi4gOwKg5p8fB++8+YwPsjwmTc96gvmg0HF4HPBFLa75IE5Ilt9VFwvGRrLUk0qpgeX4JfJ3YSUFqjQJ7B0TZomV9xAWUDt95W7qhqksBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940414; c=relaxed/simple;
	bh=T7tMtNui5h2GUi+m8ow6dVz+J3CyHXMrRqnSnQVy2pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEZ0w6YB+cLz5M6Hr5mTw7OY+sUgbZMu/MVzXgYyjWqcCVxNyxVXMg5hqqcqLeJMW+Rzb/jHteZXewhhANuqQ5umliyiehWt0wR5XIwLuZCuHVCwDqxErKdPoHOzjGJr9BXlemxUI+DPCphGOKRyAR/siopFyDJk2OkpotP4lu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7/L97S2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7/L97S2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E2EC116B1;
	Tue,  2 Jul 2024 17:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940414;
	bh=T7tMtNui5h2GUi+m8ow6dVz+J3CyHXMrRqnSnQVy2pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7/L97S2FwQftiOP2rGztr+mzrE6Vi2XRsCvYqrMMY4iiZsFmYpWpcRlF0mhaQ18V
	 LlnwWIMVNCp7GIad92N+9OljhS+8U/s9IBT/PKTB0OeWik/VYGlKzTqVq2Pr1fJBd/
	 6D/YeFq0VSkMWmjIvgibymaTTud71BApqCSV7Svg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Brad Spengler <spender@grsecurity.net>,
	Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 117/222] kasan: fix bad call to unpoison_slab_object
Date: Tue,  2 Jul 2024 19:02:35 +0200
Message-ID: <20240702170248.441679979@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Konovalov <andreyknvl@gmail.com>

commit 1c61990d3762a020817daa353da0a0af6794140b upstream.

Commit 29d7355a9d05 ("kasan: save alloc stack traces for mempool") messed
up one of the calls to unpoison_slab_object: the last two arguments are
supposed to be GFP flags and whether to init the object memory.

Fix the call.

Without this fix, __kasan_mempool_unpoison_object provides the object's
size as GFP flags to unpoison_slab_object, which can cause LOCKDEP reports
(and probably other issues).

Link: https://lkml.kernel.org/r/20240614143238.60323-1-andrey.konovalov@linux.dev
Fixes: 29d7355a9d05 ("kasan: save alloc stack traces for mempool")
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reported-by: Brad Spengler <spender@grsecurity.net>
Acked-by: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -532,7 +532,7 @@ void __kasan_mempool_unpoison_object(voi
 		return;
 
 	/* Unpoison the object and save alloc info for non-kmalloc() allocations. */
-	unpoison_slab_object(slab->slab_cache, ptr, size, flags);
+	unpoison_slab_object(slab->slab_cache, ptr, flags, false);
 
 	/* Poison the redzone and save alloc info for kmalloc() allocations. */
 	if (is_kmalloc_cache(slab->slab_cache))


