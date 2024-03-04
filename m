Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98751EB5A;
	Mon,  4 Mar 2024 21:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589002; cv=none; b=T61V9vKQmpge4SBxk4E5rTl1cwIobW3Xtc5ji2z/V1r3xu0ggG3dM6c4JYjVoRMRceP+YUyUZ51Sw55IY8DjNu6IwEo0hO9vNpUaW77KiL++kOdlCn4fRfYO+HQbctPzomx/fq/ZJ9OLqnCpH285bj85xQA/WOJjGxMj2QdnM10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589002; c=relaxed/simple;
	bh=Nnd06aFz8opDEo1Su6PN/n1ZEWQopPirJm7bMXrL4fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gN0rXEv7iGZdhzScTRuxmPOqYZX2ldoYTDz95yxjKqmjIV7WMrQUC1PE3erT+JKdg7iGdVDWtJKiiBs6gki/5i4FQw1JmvrcWcBQ0XkaWLEmHZY4YRP9EKAlZiY+zHc9g4+YDA42KsdJSDyoJWEYcMyU/+j/YMLVAm7dGTmBxn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIzk+4p9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIzk+4p9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A67FC433C7;
	Mon,  4 Mar 2024 21:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589001;
	bh=Nnd06aFz8opDEo1Su6PN/n1ZEWQopPirJm7bMXrL4fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIzk+4p9CYZq0iNZ+hkoRvdwlvKJ2we91PBX9bKyXGyK9gthfgjAjeFp0ANFlLgCX
	 cE44hqHRTvb0CbnOXDKSq9p04wOQECh/wyFQh2gtuD7n3vMSEs2J5p9GKCkPh5Ramn
	 fCFVlsEQdBv2SYXrGlK38eGepgbzeXuIf4V1w0Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 164/215] nfsd: fix up the filecache laundrette scheduling
Date: Mon,  4 Mar 2024 21:23:47 +0000
Message-ID: <20240304211602.173929675@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -211,12 +211,9 @@ static const struct rhashtable_params nf
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
@@ -614,7 +611,8 @@ static void
 nfsd_file_gc_worker(struct work_struct *work)
 {
 	nfsd_file_gc();
-	nfsd_file_schedule_laundrette();
+	if (list_lru_count(&nfsd_file_lru))
+		nfsd_file_schedule_laundrette();
 }
 
 static unsigned long


