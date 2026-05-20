Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A48369D4C;
	Wed, 20 May 2026 16:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294430; cv=none; b=jKibM+hLo1vO9yx9yTSkypffg8KQ8qIt97Ahm+zQR8c2q6GofirzEvz9BQCJjbVhSqGYVCT5Gtl/Ks3/9TZnjKLsuA15Wxr4WDwNP12i/VESpX2fP1WomdIb+tImwYahoWX+LLlIYEkQofXnMLnsj1URqT5lZFG76CF3Aa5BQi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294430; c=relaxed/simple;
	bh=Shqu5VMggLBhWDDAtx9pvwGE14QZC6K96gz8/dGuJ5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sdr+cHi6LP7SDTE2fI7+Qr5Vyn6xYz9VKTzLOauT8NG60GfniP3tMMr5CAZVTQ9l6tGjjPWXAZijFM4gHgbehK+n4bD4zKYZzuU79aQ9GL6tqcPFEFTE8ZkfXtej9rGnlDLTOexMFXpSxsLq7YCKIypETTxJV0UKHtXFksRQp94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmsHTPzb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmsHTPzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966011F000E9;
	Wed, 20 May 2026 16:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294429;
	bh=qIDtpWfT6hIWzn/7+hbS12ME9rNCvHCVj6APUpT1GR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KmsHTPzbI7PuYUawqOMiINYAu6/jMuR4blHgiAlYav/gRLAZKbm2gaYH95udRfg/8
	 bt+e+ZsgozyF8GSFhsHs6K/Mz8sNXBoZ5ksdj5jLwpK8x79lSdMfArwjb4QgUdrWXo
	 Au5MdCIk/cT1oDhL6yPPwVE9al1K9knBLOmg5N/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyungjung Joo <jhj140711@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0004/1146] fs/mbcache: cancel shrink work before destroying the cache
Date: Wed, 20 May 2026 18:04:14 +0200
Message-ID: <20260520162148.494689437@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 480d02d6ebf03..2a6319b4072cc 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -406,6 +406,7 @@ void mb_cache_destroy(struct mb_cache *cache)
 {
 	struct mb_cache_entry *entry, *next;
 
+	cancel_work_sync(&cache->c_shrink_work);
 	shrinker_free(cache->c_shrink);
 
 	/*
-- 
2.53.0



