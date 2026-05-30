Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5920481DD;
	Sat, 30 May 2026 17:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160884; cv=none; b=C2FWqvzrgWQeAWhG2RGl7fbh/tO43ZVkwzf1wH15sb5GxwT1QGfZ0pKoyi63tdf2bJDg/Utny7iH7bCPLp7Q/8SV5omj9s/g5lPZCYYyUtWURc+qBzSgISGoTTFk4591RJ4WIESR0/BYqIohSepJ04mw0RSqas7AGMAneHiPsKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160884; c=relaxed/simple;
	bh=tn3h1sJUhCn7lDMqlgaWJ5td8FuazFl2hqbX2oTRAgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpnrSYXsBUb4FWOcW6bwHgX+CUULIFBEjn4onX1+LjXDRbqRWx2OVvJvztwPXnm5JCZwm95fHFKoclQemdFPEQsVEM/xhcep+ydA8Z01OypP6B6AUZpgUh3wLbfrbEdPaXBdSwwi0TfVeb1PcEmYTAbOJR/wvMAtdrUb2Np4VzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jcc9L5tp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jcc9L5tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220DE1F00893;
	Sat, 30 May 2026 17:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160883;
	bh=9/NH03LN3qD1Q/plWT1DI1ClQPezutmdXbg52LjRI4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jcc9L5tps56yKbOw94EZysluNJ6CzboXKw813mRoAVdrSxyFHVf2e8LWgYVI4mZGa
	 wy0474Ofvm+Wri/hRSM6HdX9JPOz0oLFZYKLGxx3InpcEuE99SvXbB6U7Q8r9zLsfx
	 I0lfnq3006jkA9emfGm8SWz6Frb5Usdv5TU5H/cE=
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
Subject: [PATCH 6.1 462/969] bpf: fix end-of-list detection in cgroup_storage_get_next_key()
Date: Sat, 30 May 2026 17:59:46 +0200
Message-ID: <20260530160313.041440988@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index f01ca6f1ee031..acf4649f7e472 100644
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



