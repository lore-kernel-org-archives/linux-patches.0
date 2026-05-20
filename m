Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5D8340A57;
	Wed, 20 May 2026 18:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300149; cv=none; b=R1tNcN4+ki/YNvgJ0sszEIWBjZxNTzpnOjNYzDepDEHo6EQQ//OpmXaWpZFMMOVbVOjpeUqtnxIMW0Q8Zi30bkiBQCbL5q6UcD4iQifBX9Ai1hOjqUEjwbssfKLh6MBGv/JQWkSrUdXamhyJDwJR5FDiIcEpJ4MHmysKzsl97xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300149; c=relaxed/simple;
	bh=zxJHUd45uNOEh5oiVAdjnpWi0nPsjnkzbe7jRel7S7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sC67YN0AC2ZsyBX6wIcxGcvDfW2ZT5YaypWSIL3hMeSuhU4fSlnDU/X83ZerhRcDT+EhZmeHhpqGZG7r7lJNExi0gPRBJgQNQQPYIcYeiX88uQ5V62NZhZD//yA69/O5Ae9HcEasBjQDOYGuNGSIhvv3bct8MYNdD9Dgjbtl0QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtdEYbLm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtdEYbLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904671F000E9;
	Wed, 20 May 2026 18:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300148;
	bh=ejQ9x+pwZjgbwmZ9Amxgm2lMaMklxiuppqXqbXEFQXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtdEYbLm5lvzvf90LWkI/h65KhID3yhCwsuymQXxQHuLdfIr2Ub4VUKJvpSdBB182
	 tMxZWUUkb4c6M+A0oSb/09i0WZJj7WSY5syzd/tKOTHppIGe2OnvP7WXyYviu+Tr+k
	 0GHyIrlVZMgpRgM/GSbqbEbpvVAYJ1/Np37HE/AA=
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
Subject: [PATCH 6.12 064/666] bpf: fix end-of-list detection in cgroup_storage_get_next_key()
Date: Wed, 20 May 2026 18:14:35 +0200
Message-ID: <20260520162112.619393081@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index 3969eb0382afb..cfb4ff2610518 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -259,7 +259,7 @@ static int cgroup_storage_get_next_key(struct bpf_map *_map, void *key,
 			goto enoent;
 
 		storage = list_next_entry(storage, list_map);
-		if (!storage)
+		if (list_entry_is_head(storage, &map->list, list_map))
 			goto enoent;
 	} else {
 		storage = list_first_entry(&map->list,
-- 
2.53.0



