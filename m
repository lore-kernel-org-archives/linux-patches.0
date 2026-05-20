Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD5B333441;
	Wed, 20 May 2026 18:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301857; cv=none; b=I2tfftz0cA3EhRwDrcTmc7midKLnnEzbGvhYQ0e86TqZ9FjKa+IMtpHsIZZkVkOIgAs3OVH2t5q5LNFSsDIkArUfXgqrmlwBFkJD390RVAWF+vTshrFgOI7Phoz1/NK1vndurcBePaEuI/sPgiplQrZekigJ8JYABJLpM+PpTo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301857; c=relaxed/simple;
	bh=X7n71KhfY5pb1r9XgZStxC8oCA2Y5rWJFqFCf5vidcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJeR3voTAbKoLfHESuzbAiLwpl9jVF/EhMR9ccUgkHlGjlZlfLxsNYB0mWOjN35ugl9AUnereNhW0CqHpQXmuAQXui+wnBgTsZHN95gUlhqxClwSMf8TtBauvhEduTyq3nY15Fm2eo3vuqxjM7ePCS/AkjsxWq9u4X/qWDcURCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dr6zU/De; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dr6zU/De"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C1F1F000E9;
	Wed, 20 May 2026 18:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301856;
	bh=4Wquuh3oS9EldlWhZbir0n8Xr6SwNP3Go9lmfN4LCHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dr6zU/DenTzkDbId2W6gb35A/yfXCcYoRfiTjlGmiUdOljNdylKC/WB2WjUaaMN13
	 +Raccz/iEQp+/WkpCjGoVMQe7GbaqJbUsgMzdxJaKcOK4oecJ1KDuKuFDl6IUAgwQk
	 mfsLc3bLkuPPDxcbRPrLVa8e343EmH3mao4XRNRY=
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
Subject: [PATCH 6.6 047/508] bpf: fix end-of-list detection in cgroup_storage_get_next_key()
Date: Wed, 20 May 2026 18:17:50 +0200
Message-ID: <20260520162059.614361255@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index a04f505aefe9b..c8b8dcc37ed4a 100644
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



