Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EA342046;
	Mon,  8 Apr 2024 13:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584510; cv=none; b=MS+k278RIoPKOXoaoc9cMvkYTvieQaMKr6qilvs1U1h+d6ky2j37eblgyWQNl+BICJTo/jXsFbfI6rSxdMXNe7ZpsDqXwXQIDbEMuUwsDvcIwVb5Oxw79sIm58fO6pDuXloMNXnwS3JhDj+GcOXd1waKFssXVl4VxZYdyB7kzWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584510; c=relaxed/simple;
	bh=cJhid1XSbKZl9H64s7L0phG7Qgj3GgJfbSP7h6bmQwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcKQzjzTCK7O9SiR05c6IhPqyvnLfcHyKzVZC8g5atVsfFAJmvmIaPPp7TeNghiXFyNyZ7/js/lwp7gpD1gJbAXWuKOsmcAmQbDCWR7slELWl9kTt9TLUJuh8PuXdn+F7TiMEn3IfgsptgrK01+kRlvE7CsAJXkYEw3W9VcoUow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eoCPuCz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoCPuCz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801D8C433C7;
	Mon,  8 Apr 2024 13:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584509;
	bh=cJhid1XSbKZl9H64s7L0phG7Qgj3GgJfbSP7h6bmQwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eoCPuCz9QfmE+sUTK17Yxs8HoEMgpYO/JuIONv7FyNTtO9P5a1PAAfSpQp+ZHthPx
	 IEtRm1yaQYfqlTWNsyC+1SZxZekMjv/1wrKhcBY+kgN8G2YmKvmz/L+JmZweoCpR/E
	 7C6RTmy+VvbIf1YV5UoVqlnrYJYsYVdFARrTUcDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 463/690] nfsd: fix net-namespace logic in __nfsd_file_cache_purge
Date: Mon,  8 Apr 2024 14:55:29 +0200
Message-ID: <20240408125416.405210374@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit d3aefd2b29ff5ffdeb5c06a7d3191a027a18cdb8 ]

If the namespace doesn't match the one in "net", then we'll continue,
but that doesn't cause another rhashtable_walk_next call, so it will
loop infinitely.

Fixes: ce502f81ba88 ("NFSD: Convert the filecache to use rhashtable")
Reported-by: Petr Vorel <pvorel@suse.cz>
Link: https://lore.kernel.org/ltp/Y1%2FP8gDAcWC%2F+VR3@pevik/
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 0b19eb015c6c8..024adcbe67e95 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -892,9 +892,8 @@ __nfsd_file_cache_purge(struct net *net)
 
 		nf = rhashtable_walk_next(&iter);
 		while (!IS_ERR_OR_NULL(nf)) {
-			if (net && nf->nf_net != net)
-				continue;
-			nfsd_file_unhash_and_dispose(nf, &dispose);
+			if (!net || nf->nf_net == net)
+				nfsd_file_unhash_and_dispose(nf, &dispose);
 			nf = rhashtable_walk_next(&iter);
 		}
 
-- 
2.43.0



