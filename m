Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93B415957D;
	Tue, 18 Jun 2024 13:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716622; cv=none; b=Mwj0Vlkq1xjOp1lMUBVs157bO41Emu7gfYBy8gkRV39fURzBfXw2r6rg2bjFjdfG67XsUrHeMLoDi+t/X8BdzpPFF2ETjtIHUSRvx7B+OIeRrtQnOdquviHQmGLb90MP4yUMKTRXohk9KNXJcAtOd8iskEV+qvDMSfWR+xLN+go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716622; c=relaxed/simple;
	bh=IVXUvbVR+MqQcqqTZZZbuomsNUiF8a8+l3yS7KguHo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMXdEhzYDSOIo1LorYRv58CrSMspXH8xggW5dIuk6ugPaKal5ND6Jr1oH5DKAG02Nxa5dWuwrmf3xWVLU5WjfwcuHJ2ZNSQBUqFx3Inj2+fIcgCUtOcLcN4QqCqmtVpGFqXibUNCrkwn2fL4hBF88M+gaoZOwkn3v/ihM59Iy+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AA8qoJq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AA8qoJq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C747C4AF54;
	Tue, 18 Jun 2024 13:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716622;
	bh=IVXUvbVR+MqQcqqTZZZbuomsNUiF8a8+l3yS7KguHo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AA8qoJq/p07lHJhCV7T7UNHFGtgbaanBODU43HpJ9RJtrSjNdPVEq0L+b53MYZ9fh
	 ulrOj3YfkX7okEToFQNc6OWOc8SQigHv6Ezoa+9qovCKC9q4Fi29Cnhs3glfImA1j6
	 O0tsNFDYULJL97vr5ytrHy66sfoudw18VyqVszuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 707/770] nfsd: fix up the filecache laundrette scheduling
Date: Tue, 18 Jun 2024 14:39:20 +0200
Message-ID: <20240618123434.560933888@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



