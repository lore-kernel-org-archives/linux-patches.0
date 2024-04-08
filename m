Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF37524AF;
	Mon,  8 Apr 2024 13:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584288; cv=none; b=N1Rz/fPZhHHh0cVECIH6BwLpUvnrIRCaBn+tWGq7HMlVCA1QqwIo4wunL6Jgw2xlzkwuTFh+HvFrA5Oh7Wp/zxYDD3mDpg2gtSceggbdK8vKDKdsvweD+QVH2PGhGNiOyqDpnPTw1+cbFUY5dS/Yk/3FwiG+Ht4c1OW+hQA0K4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584288; c=relaxed/simple;
	bh=tnm31SMusgk/HoWiyZl4cDNyy6ZZ2VjKntHdQHHFz70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIyYHaa98MxQNEOf3pQwhQb0zbbEclLNXwMt9ctlGSLGI7Hb1Yh/g0AGB2yin+c7QwEbo84YKbpQQFxhyLVF3JaIqQPcVfFki4qkzTx7eRW9zEBmLx0oRNRthFyq0rVcRbaNlG8U51vpUDif6LUzS15CjXfp0jkVl4mqmSuD5xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pj7LJan9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pj7LJan9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3651DC433C7;
	Mon,  8 Apr 2024 13:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584288;
	bh=tnm31SMusgk/HoWiyZl4cDNyy6ZZ2VjKntHdQHHFz70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pj7LJan9fMQ/9Es+VpLVRTzivwVB2W3eqJHxE1JmtMMe8y9xeDM5Fj10cpjoJDRZQ
	 2M8bUI+wn15NjLHFNWJo24Ia7EDcxSa6xGd+ugRvR7eGKEo7XwXMZsKV8299NVeCsI
	 Vf/+PO4oRcR6aUMnTDYcm2oVB0LXUk/UomfRaMng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 352/690] NFSD: Refactor nfsd_file_lru_scan()
Date: Mon,  8 Apr 2024 14:53:38 +0200
Message-ID: <20240408125412.363984065@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 39f1d1ff8148902c5692ffb0e1c4479416ab44a7 ]

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 656c94c779417..1d94491e5ddad 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -471,23 +471,6 @@ static void nfsd_file_gc_dispose_list(struct list_head *dispose)
 	nfsd_file_dispose_list_delayed(dispose);
 }
 
-static unsigned long
-nfsd_file_lru_walk_list(struct shrink_control *sc)
-{
-	LIST_HEAD(head);
-	unsigned long ret;
-
-	if (sc)
-		ret = list_lru_shrink_walk(&nfsd_file_lru, sc,
-				nfsd_file_lru_cb, &head);
-	else
-		ret = list_lru_walk(&nfsd_file_lru,
-				nfsd_file_lru_cb,
-				&head, LONG_MAX);
-	nfsd_file_gc_dispose_list(&head);
-	return ret;
-}
-
 static void
 nfsd_file_gc(void)
 {
@@ -514,7 +497,13 @@ nfsd_file_lru_count(struct shrinker *s, struct shrink_control *sc)
 static unsigned long
 nfsd_file_lru_scan(struct shrinker *s, struct shrink_control *sc)
 {
-	return nfsd_file_lru_walk_list(sc);
+	LIST_HEAD(dispose);
+	unsigned long ret;
+
+	ret = list_lru_shrink_walk(&nfsd_file_lru, sc,
+				   nfsd_file_lru_cb, &dispose);
+	nfsd_file_gc_dispose_list(&dispose);
+	return ret;
 }
 
 static struct shrinker	nfsd_file_shrinker = {
-- 
2.43.0



