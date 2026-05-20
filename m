Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B840B33D4E9;
	Wed, 20 May 2026 17:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297434; cv=none; b=srdEHorkT/QKMJj62bIS+1BRZbM/AuR3V0chaZU09+kGIkngxoiobRoQyEEeUCnmYejR7OeK0UGU7tmIV8JMF5iDoECslXYedbyv2b+vdnAEtSPTYQqZlw8fzJsBzHQQEGPRyLtFHWhSjJB07yNOBVaJYGKknDP2+FV7ifFZyVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297434; c=relaxed/simple;
	bh=9OwUhgg+3CUIgEiISb2XdPsq0KepqQ37VV2c+PSBENw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=squFRhKnQ1RYlEtAo4dRb1h5oiEnTlozbqFaWeS5HwBhLQ9+0SS7ZFIlC4GOiGgwt0xnNETAXW0T46Z5KzxrEN+VTf448M2oWgH4Jp5O5c8cSmmjZctwMiCnfTigPC5zR20eWMtcQhEAsD0pmiW5KcoDxxll2Zx2c+S1SCX1B1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4rCFKL6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4rCFKL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1331F000E9;
	Wed, 20 May 2026 17:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297433;
	bh=7IvGxWyNWsiu3tOBHIyhYDdCCX5hTcLeUOcnwF7xpJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4rCFKL6xKSYuqBwVlJ9AaSPSqgO4nQKGqPdb+UbTNXUcAW+n73K+fTwKmrWkDszp
	 dlSgeATnY0GA9e0Jj66HrnEL2cRQdVSYNMruAGUTStJPe0fWcLvD3pe8NOAYKWwkdE
	 sbJ+TpaDtCHZ6xZo+7sfYt/6c9SL4XQ+0miur2g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyungjung Joo <jhj140711@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/957] fs/mbcache: cancel shrink work before destroying the cache
Date: Wed, 20 May 2026 18:08:06 +0200
Message-ID: <20260520162134.633525500@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: HyungJung Joo <jhj140711@gmail.com>

[ Upstream commit d227786ab1119669df4dc333a61510c52047cce4 ]

mb_cache_destroy() calls shrinker_free() and then frees all cache
entries and the cache itself, but it does not cancel the pending
c_shrink_work work item first.

If mb_cache_entry_create() schedules c_shrink_work via schedule_work()
and the work item is still pending or running when mb_cache_destroy()
runs, mb_cache_shrink_worker() will access the cache after its memory
has been freed, causing a use-after-free.

This is only reachable by a privileged user (root or CAP_SYS_ADMIN)
who can trigger the last put of a mounted ext2/ext4/ocfs2 filesystem.

Cancel the work item with cancel_work_sync() before calling
shrinker_free(), ensuring the worker has finished and will not be
rescheduled before the cache is torn down.

Fixes: c2f3140fe2ec ("mbcache2: limit cache size")
Signed-off-by: Hyungjung Joo <jhj140711@gmail.com>
Link: https://patch.msgid.link/20260317054556.1821600-1-jhj140711@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/mbcache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index e60a840999aa9..90b0564c62d0b 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -408,6 +408,7 @@ void mb_cache_destroy(struct mb_cache *cache)
 {
 	struct mb_cache_entry *entry, *next;
 
+	cancel_work_sync(&cache->c_shrink_work);
 	shrinker_free(cache->c_shrink);
 
 	/*
-- 
2.53.0



