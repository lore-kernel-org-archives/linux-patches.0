Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B419C41A8F;
	Sat, 30 May 2026 18:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166201; cv=none; b=LTYeSm45kQ8Hl1eS9kwpH69ZOKD5KC2JkhXG3EQzjh7iqxUzdB19Kkjfmy0mpUkAz9UgYKoLIBjXq4m6vZilaBnBnJ0YrTjdjTctPET0Tq9LADzCwsc2aPVzu6jKnet0qvrntyl5IPUEZMClXRjXoLg+kCg3/IFjm1/qha2y6k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166201; c=relaxed/simple;
	bh=BVqQE/gKWn+oICAaQgi5AyoGjxh8hTvqTTuJDT91+4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOSp+V7vE4BOvJcVL3B9BIG5aAEV+pW9wdezMKl4cr0aQ7LvyN7ktj3/6ho5Ktjoqxh71Evwg1bHUxtHwIIZS8GXwYxa99w+b4QW3DYL1WF2oyplRZV8REAa5Gsor4pOjXke4zkLUCjT+EtGnLQ+H8ZVHOFBo1PIDdF5Ugjw0YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pm+Chql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pm+Chql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1DE1F00893;
	Sat, 30 May 2026 18:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166200;
	bh=bYTFa1sinQI8nae5Ge5lGimZ1o1W8ivUVvYHovTBX60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pm+ChqlF5q17H6IVZFx40RFWA+xfki7sihbY3louYvbVahREm12wGMtkATmaJ2kd
	 5U8MmbNckI7a4yV7rDIrXFEwQcEg6tR0qVDEa0oLlJxxxY29EXSyaqM1qN6zTk6PAu
	 JPpTDmnkMJkabDY+xoxVBlA3+ESZg3Gwx9SHTWvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 303/589] bpf: fix end-of-list detection in cgroup_storage_get_next_key()
Date: Sat, 30 May 2026 18:03:04 +0200
Message-ID: <20260530160232.923293684@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 5828b9e5b272ecff7cf5d345128d3de7324117f7 ]

list_next_entry() never returns NULL -- when the current element is the
last entry it wraps to the list head via container_of(). The subsequent
NULL check is therefore dead code and get_next_key() never returns
-ENOENT for the last element, instead reading storage->key from a bogus
pointer that aliases internal map fields and copying the result to
userspace.

Replace it with list_entry_is_head() so the function correctly returns
-ENOENT when there are no more entries.

Fixes: de9cbbaadba5 ("bpf: introduce cgroup storage maps")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>
Acked-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/20260403132951.43533-2-bestswngs@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/local_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index b139247d2dd33..5c12b4d130333 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -261,7 +261,7 @@ static int cgroup_storage_get_next_key(struct bpf_map *_map, void *key,
 			goto enoent;
 
 		storage = list_next_entry(storage, list_map);
-		if (!storage)
+		if (list_entry_is_head(storage, &map->list, list_map))
 			goto enoent;
 	} else {
 		storage = list_first_entry(&map->list,
-- 
2.53.0



