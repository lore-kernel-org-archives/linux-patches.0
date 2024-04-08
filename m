Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBCB7F470;
	Mon,  8 Apr 2024 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584603; cv=none; b=HxH8Uui2P/vADcW3xNUuxKCIgkVu20R+UIeU/7vfAnw7bpBAgv5UwrCnSwn0D34vc+nGqDmfo4RkN+ylik1kp3lurZ7FWFx5yLW4AydvIGMGF/PMryTpqN9t/FgY43fsijxI6GktAqXUlpCx/+Tbq4r05X5AK4yEMY93MvbWjYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584603; c=relaxed/simple;
	bh=IqrIh/TBJupQnGHF8kXKa7ev1uleuLe7R5UORg3CZLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSYHu5MqJ7owNyYVz5gjEHBeyAEplKqsg0Nvhal1bTHeA9WyI+7q8DKRI1UyeVRvHOpy1qaBUSBqgDdhQyjYFiCL85Xg6QotSQ74TUsBcMYsu4xmRl8VxBFfXNRC0HWmNFXhkCd6KUXh2JndFUSpJ6WnQ88npJOEIbh6FNah+aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6rPRXYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6rPRXYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B438FC433C7;
	Mon,  8 Apr 2024 13:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584603;
	bh=IqrIh/TBJupQnGHF8kXKa7ev1uleuLe7R5UORg3CZLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6rPRXYYJJWargPEH8dLqqa8NAQNIU2JQNiqrS7yP2QI/XpJ5l3x417WF2RciUkeV
	 vN3nmmpFUqnQKgbnYAg+TCyGdTn6pGHCDbBOWmw6817z2rzLJprpirwCGQLvkqOZ85
	 p+r1LSYg6CDmrbX1b5AObBH5L5WsIFuxK5Qqf90k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 495/690] nfsd: fix up the filecache laundrette scheduling
Date: Mon,  8 Apr 2024 14:56:01 +0200
Message-ID: <20240408125417.575429430@linuxfoundation.org>
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

[ Upstream commit 22ae4c114f77b55a4c5036e8f70409a0799a08f8 ]

We don't really care whether there are hashed entries when it comes to
scheduling the laundrette. They might all be non-gc entries, after all.
We only want to schedule it if there are entries on the LRU.

Switch to using list_lru_count, and move the check into
nfsd_file_gc_worker. The other callsite in nfsd_file_put doesn't need to
count entries, since it only schedules the laundrette after adding an
entry to the LRU.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index fb7ada3f7410e..522e900a88605 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -210,12 +210,9 @@ static const struct rhashtable_params nfsd_file_rhash_params = {
 static void
 nfsd_file_schedule_laundrette(void)
 {
-	if ((atomic_read(&nfsd_file_rhash_tbl.nelems) == 0) ||
-	    test_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags) == 0)
-		return;
-
-	queue_delayed_work(system_wq, &nfsd_filecache_laundrette,
-			NFSD_LAUNDRETTE_DELAY);
+	if (test_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags))
+		queue_delayed_work(system_wq, &nfsd_filecache_laundrette,
+				   NFSD_LAUNDRETTE_DELAY);
 }
 
 static void
@@ -665,7 +662,8 @@ static void
 nfsd_file_gc_worker(struct work_struct *work)
 {
 	nfsd_file_gc();
-	nfsd_file_schedule_laundrette();
+	if (list_lru_count(&nfsd_file_lru))
+		nfsd_file_schedule_laundrette();
 }
 
 static unsigned long
-- 
2.43.0



