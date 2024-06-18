Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700621A0714;
	Tue, 18 Jun 2024 13:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716192; cv=none; b=QKN8v6umpF9pzBMWmqZbD0RDQzloHiyLCMaBm5Nq66ha/U0T4dHoRnLUFKGhC8RIaBzJF7A59ium72F/VFgEJ6Jm3nVk5RbCqP3u9c1Lok7QnK0vx6bFDCBW3wueI3fnnQzjuQ9kfkZRDnKqmcjwmn99sBs1/IIMi11lFWdKhsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716192; c=relaxed/simple;
	bh=Huj1upEztybetXDYXpQ0DybBaj2We4l0oNZEVPcADBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDu04VBmBWOmtEWqneKpl9WzHPSW3cSn0rhXiWFWSE8G5ygUoIqnQgHtDi0iqgoItXLPtCcClDYZmp4wdQA3wePNnHM24vH9Kp/7FexMH3OmtjqNDwiDfBVM8m1HdRYf88489QwGap2Isl3fAXzJbiitL5y2dj60QloqBXHKkqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQcQy1b3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQcQy1b3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E632CC3277B;
	Tue, 18 Jun 2024 13:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716192;
	bh=Huj1upEztybetXDYXpQ0DybBaj2We4l0oNZEVPcADBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQcQy1b3WT/c1OG96ndvR3gdTjxUM6yqsln+asWTTf5EzLoMHSsuuQiaHbB0eHAZg
	 Vhd9tmN6wnRRbAujq+w673DgQO5o71cbdNk8dmcue8En21lAZqN8RrvmFRIqbcx5VS
	 Tu7pC52DV0sUA6L02U4OFm1ChQ3mX/aGuWaYTG5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 564/770] NFSD: Zero counters when the filecache is re-initialized
Date: Tue, 18 Jun 2024 14:36:57 +0200
Message-ID: <20240618123429.070432497@linuxfoundation.org>
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

[ Upstream commit 8b330f78040cbe16cf8029df70391b2a491f17e2 ]

If nfsd_file_cache_init() is called after a shutdown, be sure the
stat counters are reset.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index b9941d4ef20d6..60c51a4d8e0d7 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -823,6 +823,8 @@ nfsd_file_cache_shutdown_net(struct net *net)
 void
 nfsd_file_cache_shutdown(void)
 {
+	int i;
+
 	set_bit(NFSD_FILE_SHUTDOWN, &nfsd_file_lru_flags);
 
 	lease_unregister_notifier(&nfsd_file_lease_notifier);
@@ -846,6 +848,15 @@ nfsd_file_cache_shutdown(void)
 	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
+
+	for_each_possible_cpu(i) {
+		per_cpu(nfsd_file_cache_hits, i) = 0;
+		per_cpu(nfsd_file_acquisitions, i) = 0;
+		per_cpu(nfsd_file_releases, i) = 0;
+		per_cpu(nfsd_file_total_age, i) = 0;
+		per_cpu(nfsd_file_pages_flushed, i) = 0;
+		per_cpu(nfsd_file_evictions, i) = 0;
+	}
 }
 
 static bool
-- 
2.43.0



