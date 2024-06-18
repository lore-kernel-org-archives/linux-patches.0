Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D843813CF82;
	Tue, 18 Jun 2024 13:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716578; cv=none; b=Ifh9wAG3O8IhYRCJs0lROy8ic6De/peaowelIvpiUgCD8OdR2VN2ToMZOGjJQa5grtBn41/lNt+dP8gMQEYcuri7j2ro3epMOqq0UmbkynJW6+JUtX0IvyFEmYCBjhTYlHulMvNf+wKFO5f8amf8w9j4JUO+baruHSVvQjC4mcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716578; c=relaxed/simple;
	bh=M1omBZ9nh0IJoreDG8+13g4hDH+wlSdiXrjwAYV0xsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvMD52ByXmvvUFpRb6eXvjbcs4qSgfvoh6I/7bDaAJN10ig4iryPrC5BXu0IvZtZG/dZKQYMO0CmM1qcJ70ZuPUyOd4TbC53wZ07E5vmWZSbSm8yV58ND2NnTVSyqC+AbseRH2v6Ob+l7nByzNgKeIMPnkd3zmL0Vik9ctHLHtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWU9RPX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWU9RPX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8DAC4AF51;
	Tue, 18 Jun 2024 13:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716578;
	bh=M1omBZ9nh0IJoreDG8+13g4hDH+wlSdiXrjwAYV0xsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWU9RPX3nj9RdIoHTXnDJNFBXvv5dHgyKuKvN+E0EQXie6GCtGMC1HxJ+2ulbiKM1
	 9T8Bn940Y7kvlwSmUfeZ1oMxSGNrMeJTEmyYGR4YBiR//J6Lsycpj4J8bp74ZHzkp+
	 /VwB2b6FMjV/KZKjzZr9Q9xeFyKpNdZVH0E/uRL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 693/770] NFSD: Flesh out a documenting comment for filecache.c
Date: Tue, 18 Jun 2024 14:39:06 +0200
Message-ID: <20240618123434.026672549@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit b3276c1f5b268ff56622e9e125b792b4c3dc03ac ]

Record what we've learned recently about the NFSD filecache in a
documenting comment so our future selves don't forget what all this
is for.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 13a25503b80e1..d681faf48cf85 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -2,6 +2,30 @@
  * Open file cache.
  *
  * (c) 2015 - Jeff Layton <jeff.layton@primarydata.com>
+ *
+ * An nfsd_file object is a per-file collection of open state that binds
+ * together:
+ *   - a struct file *
+ *   - a user credential
+ *   - a network namespace
+ *   - a read-ahead context
+ *   - monitoring for writeback errors
+ *
+ * nfsd_file objects are reference-counted. Consumers acquire a new
+ * object via the nfsd_file_acquire API. They manage their interest in
+ * the acquired object, and hence the object's reference count, via
+ * nfsd_file_get and nfsd_file_put. There are two varieties of nfsd_file
+ * object:
+ *
+ *  * non-garbage-collected: When a consumer wants to precisely control
+ *    the lifetime of a file's open state, it acquires a non-garbage-
+ *    collected nfsd_file. The final nfsd_file_put releases the open
+ *    state immediately.
+ *
+ *  * garbage-collected: When a consumer does not control the lifetime
+ *    of open state, it acquires a garbage-collected nfsd_file. The
+ *    final nfsd_file_put allows the open state to linger for a period
+ *    during which it may be re-used.
  */
 
 #include <linux/hash.h>
-- 
2.43.0



