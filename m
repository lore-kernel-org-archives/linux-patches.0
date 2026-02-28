Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BA937145B;
	Sat, 28 Feb 2026 17:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301457; cv=none; b=J42u+67QmsExoLFDIynYEX3NE1TWC8nuyqSfjdW1hw3oU7ej+c7+WuBDgLrTntoYj6pFrNtzELaOlcsJarp/dTZfnRaNLrJWw0wRvBhfNqsa5bERNzlXF6eBG5ZcQOdeRRRoXGtSF649CpQeQfjBR8PeLSe4zObg9aXfOxE+Ay8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301457; c=relaxed/simple;
	bh=p/4gPF3ZN/FRGXXtNkPOfBxIWUVxOFF+fANm7CRbjSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNaistWh4gLfQ9ZxMBbYpAA1uPDR1SUl0yMXkOIoqYl2vbmcTjCleIw9hA1IOb7Nh098CcI14MAaF5h3thLazMv8Esb3VKJrThRgc/OuO6oHCatW2aRVycKole8V6gs8/iBhNJAsRgV4/Zb2NeBovUqsnkKuI4sjk39ezM7CKSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dah1gQN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dah1gQN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50603C19425;
	Sat, 28 Feb 2026 17:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301457;
	bh=p/4gPF3ZN/FRGXXtNkPOfBxIWUVxOFF+fANm7CRbjSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dah1gQN0SuRRKXTZVvV3xIWnK/DYCoaQ+zrU/i5z8w37jQDkLq12f5xzSEHMe6fEG
	 utyCArOKTtdJw14Fh2WUealZEI+KUcFQJRFkO3KmmMVTeOQEJXD4RrYqtLcQrWou8/
	 bozBNFy+ljyNZ6+kvuyTt2G3nUWZOkHnp6cOyaZb02iN0NB5BFcUqcMZ/FX8QPUCL1
	 lxwNj7pHEvg5KaK7T6lUyxrUeWeLfABZ1ksHbhgze6OHNtO6zcP1x5KVPyC/i7dPZ7
	 38VqW5INM3RJ6WQMROHZpKOG+gbGNtsCumaC3VClQxdT8kiqtQmbC4JMO4DPWNkaMT
	 CAG15sO3d52+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Joseph Qi <jiangqi903@gmail.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 643/752] ocfs2: fix reflink preserve cleanup issue
Date: Sat, 28 Feb 2026 12:45:54 -0500
Message-ID: <20260228174750.1542406-643-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Heming Zhao <heming.zhao@suse.com>

[ Upstream commit 5138c936c2c82c9be8883921854bc6f7e1177d8c ]

commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by error")
doesn't handle all cases and the cleanup job for preserved xattr entries
still has bug:
- the 'last' pointer should be shifted by one unit after cleanup
  an array entry.
- current code logic doesn't cleanup the first entry when xh_count is 1.

Note, commit c06c303832ec is also a bug fix for 0fe9b66c65f3.

Link: https://lkml.kernel.org/r/20251210015725.8409-2-heming.zhao@suse.com
Fixes: 0fe9b66c65f3 ("ocfs2: Add preserve to reflink.")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d70a20d29e3e9..64ba3946f8408 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6364,6 +6364,10 @@ static int ocfs2_reflink_xattr_header(handle_t *handle,
 					(void *)last - (void *)xe);
 				memset(last, 0,
 				       sizeof(struct ocfs2_xattr_entry));
+				last = &new_xh->xh_entries[le16_to_cpu(new_xh->xh_count)] - 1;
+			} else {
+				memset(xe, 0, sizeof(struct ocfs2_xattr_entry));
+				last = NULL;
 			}
 
 			/*
-- 
2.51.0

