Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5B61D0DC4;
	Wed,  2 Oct 2024 14:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878282; cv=none; b=X47DYvS8ryB/gkWShP6A2TuWXqTrV3X8raSwNHB8ktyjydo7yTFnmG7t2Q/43PuhaCQptpf9nyaG8Q7Od49eg/nLBmhbqlwj742SZgkc3WkiQfwAbm62KMBjzqttzlBKqAqo5BtlbBwmQNlppjU2++bq/Fare59357Ut6ATbuy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878282; c=relaxed/simple;
	bh=H9B6YLuuyJLcDUo2sWe3xmHXrzG06B/Nu3jORomd4Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yz0Oj0qho040RbpEwAesOS4oZFVrwgrMoIFS00Iz5P7F9ADr01VG/rEmb9WRJHtmUR9d/ucT/ExavzG6+yFfbaFMmg100eRCtAUwoyuIUhDuDh8P2ltPdyxnSfcjrOZuy/M+KQJRHTN38n4LC+ngMlFQ3ytyhVpPQJLx/5heUOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnjMShNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnjMShNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD528C4CEC2;
	Wed,  2 Oct 2024 14:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878282;
	bh=H9B6YLuuyJLcDUo2sWe3xmHXrzG06B/Nu3jORomd4Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnjMShNVOETYxO1jiDJzKMy8VAQiSEQwScNITbHBIfkZ0Qge7bH0u+PBmWYWknrSi
	 GKYFRIr+9Uq07FKEqlGgmLW0obCvOW8EISBs8q1HqrGu2P/01kCWeFg+VkuJDhc3NF
	 wg9E9+umuM51J7A3UD6PXrJjVjAalXTE1WG/FsCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Youzhong Yang <youzhong@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 360/634] nfsd: remove unneeded EEXIST error check in nfsd_do_file_acquire
Date: Wed,  2 Oct 2024 14:57:40 +0200
Message-ID: <20241002125825.305461479@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 81a95c2b1d605743220f28db04b8da13a65c4059 ]

Given that we do the search and insertion while holding the i_lock, I
don't think it's possible for us to get EEXIST here. Remove this case.

Fixes: c6593366c0bf ("nfsd: don't kill nfsd_files because of lease break error")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Youzhong Yang <youzhong@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index f4704f5d40867..f09d96ff20652 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1035,8 +1035,6 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (likely(ret == 0))
 		goto open_file;
 
-	if (ret == -EEXIST)
-		goto retry;
 	trace_nfsd_file_insert_err(rqstp, inode, may_flags, ret);
 	status = nfserr_jukebox;
 	goto construction_err;
-- 
2.43.0



