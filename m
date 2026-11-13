Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585675;
	b=oufd+IpGQDz/HeeX/lwi3Glq/9Xe2Goq9i00Yw915l56IBZLSUnplNQ4mCicPJtcdojl
	 +ookZfVTz3BgWN9KVfUe/2buBQBWpvNUgFK/2BLmElWfLp65PQqN8QzOeAZrF90jQZdmY
	 s38oWrsiutuyv1wyblv63GiBwc/BaYVQQtv5qK4rwcO8rRkzJExu7vJEc8gD0sONRUOI0
	 tFPge16irnYaIYL3r6mZQrUObBvApMOdNFDFfeIL6JNrZb7wCW2mmWTfkk/sHvYONaap2
	 9SDSINNiQtm4GQ+A5KFtnCj2iT+jNQYVWa+wCr9FGCN69+41NIVV5q1wjM+VWAQf9Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LWHZgKVm7hxCwSQabBhvzV1VApK+3FKX+vCqq7I1sYw=;
	b=ZmXgBPFKBM0j1DJ2QPqslrsfTnZvR1OL5koZcKdQBRZQX60OyumOHECsKNAMyA5dvdOC
	 1cv8EfMPa/R2WYkJIyNQFUT2uhyzMNelGbcS6316vJc6BVq8ynIyYwKrD9mqBmB0dOyIH
	 cg/IaeFpAHvY3dJcADIP7ZawkAa8w8jsTQy/170xvTPHitW0FD7AZuOV72dzGrdUJpoJI
	 OfAVXJoBHfWdEDZPJ8NSqS/S3CGLxAl9nCGeSFWVYTk57K9IdnHJQH8H2qGxIpPqfoq53
	 5Nkywa5/cvBCdG1PInqkIdrUO+hUVEcv+lyAF0Y2jeoWXQvbqz1wfcVK8cRCAifKuMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="x/n6EUZB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCF4606A8A0;
	Fri, 13 Nov 2026 16:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x/n6EUZB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2641F000C4;
	Fri, 13 Nov 2026 16:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585675;
	bh=LWHZgKVm7hxCwSQabBhvzV1VApK+3FKX+vCqq7I1sYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/n6EUZBR0313iuvBxsP7NsSrEl5tCTwiRCm4Uf/Sow3PeS/T7uVAgiqoRCtGB67z
	 HfTS+e8NCYrvnixI/WDlntAPvaNIs1oyHmmha4DSMAc4VOxl2OptZD/vmhKQS5foky
	 u+rH1Vth86TFQz67bcXqHxrRqWDtEZRC3KRrK6tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 288/507] xfs: fix recovery of partial attr removals
Date: Fri, 13 Nov 2026 10:49:52 -0500
Message-ID: <20261113153805.028385900@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 30bb61651d2da5a502cf504bcdad16c093c1bb08 ]

When running xfs/753 on parent pointer-enabled file systems with DEBUG
enabled, log recovery will eventually crash after a few dozen iterations
due to an ASSERT that XFS_ATTR_INCOMPLETE is not already set when
xfs_attr3_leaf_setflag is called:

XFS: Assertion failed: (entry->flags & XFS_ATTR_INCOMPLETE) == 0, file: fs/xfs/libxfs/xfs_attr_leaf.c, line: 3045

This is because parent pointer use logged attributes, and the attribute
intents do not track the work that has been done as the transaction
rolls, and the recovery mechanism is to run the operation from scratch.
Because of this various places check for XFS_DA_OP_RECOVERY skip work
already done.  But while recovery tolerates an attribute already fully
removed, it currently trips the above assert for an attribute that
already has the INCOMPLETE bit set, but still exists.  Fix this by
handling the case like all the others.

Fixes: 1d08e11d04d2 ("xfs: Implement attr logging and replay")
Cc: stable@vger.kernel.org # v5.19
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 02ca50442b466..5b1fd62714205 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -3042,7 +3042,14 @@ xfs_attr3_leaf_setflag(
 #endif
 	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
 
-	ASSERT((entry->flags & XFS_ATTR_INCOMPLETE) == 0);
+	if (entry->flags & XFS_ATTR_INCOMPLETE) {
+		if (!(args->op_flags & XFS_DA_OP_RECOVERY)) {
+			ASSERT(args->op_flags & XFS_DA_OP_RECOVERY);
+			return -EFSCORRUPTED;
+		}
+		return 0;
+	}
+
 	entry->flags |= XFS_ATTR_INCOMPLETE;
 	xfs_trans_log_buf(args->trans, bp,
 			XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
-- 
2.53.0



