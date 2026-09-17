Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A244D486F;
	Thu, 17 Sep 2026 15:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660678; cv=none; b=P6M5JV4LegDaqdaBzGUwa48F2n1rFqLz/DIa8Gl9kBx6pAKZkR+5OhQp5QmcWDTKvwxVHG2rz8agNifNj07V8DHI2ZYow0xPYjDTx7hWq1hWNvG5XXpdqag+rODFJkshHTKOUywxj3sHwvLYMnfXao7TggOy+RkFBl+imeQ2OLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660678; c=relaxed/simple;
	bh=idQ66L5tpDNtTiknsJ+AxHmpMN8rko28SBghf8n4vdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCFtfh3g81mLTUQiMXw8lcORjQNzMQ+M0ZqXbezqTc/utEPgBNaM0yyqprOUVJVUxx2VN/KJnwc1h4chcbPv6st91HYsf7e4sLnztzygpJnMkHqCYrogfOzMC+goyV/wWzCesWOI95ttwZlyXu04gnlMteho2xjt/CXWpuCGpEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b73v9S/2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b73v9S/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63F91F000FF;
	Thu, 17 Sep 2026 15:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660677;
	bh=5rpxsRfdgkp2QIXtRUkqNYOM45+dmLxW51pQ3gVq9JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b73v9S/2QyzklEOaob7v1YEBhY7wOZoYkITRyE7PFRPlg8P71AGhR77i1HW3t2m87
	 a/BQE/NnMEWBmw8Fu1+7LSd8GoP4u+uaJsH+7WSahUdyG24nUuGo4wYRxv7n+cqkfi
	 a+rw3gBQYfIdEyMZ1jEN3SzNhJvSorpFdgnAtprk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 673/733] xfs: dont stash removename operations with unknown ftype
Date: Thu, 17 Sep 2026 16:16:21 +0100
Message-ID: <20260917151409.503629640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 865b751e75039fc07838b3200f9740256653da9a upstream.

LOLLM notices that the behavior of xrep_dir_replay_update changes based
on the ftype recorded in the stashed removename information.  It also
notices that the unlink iops sometimes set that ftype to FT_UNKNOWN
because the regular directory tree update code paths don't need to know
the ftype of the child.

Unfortunately, this results in incorrect link counts, which eventually
trips link count errors in later phases of xfs_scrub, or in xfs_repair.
Fix this by creating a second xfs_name with the type set correctly.

Cc: stable@vger.kernel.org # v6.10
Fixes: 8559b21a64d983 ("xfs: implement live updates for directory repairs")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dir_repair.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1375,9 +1375,24 @@ xrep_dir_live_update(
 		if (p->delta > 0)
 			error = xrep_dir_stash_createname(rd, p->name,
 					I_INO(p->ip));
-		else
-			error = xrep_dir_stash_removename(rd, p->name,
+		else {
+			/*
+			 * xfs_dentry_to_name in unlink or rename-exchange can
+			 * pass us names with ftype FT_UNKNOWN, but we really
+			 * must know the ftype of the child that is being
+			 * removed so that we can do nlink updates correctly
+			 * without holding inode references.
+			 */
+			struct xfs_name	name = {
+				.name	= p->name->name,
+				.len	= p->name->len,
+				.type	= xfs_mode_to_ftype(
+						VFS_IC(p->ip)->i_mode),
+			};
+
+			error = xrep_dir_stash_removename(rd, &name,
 					I_INO(p->ip));
+		}
 		mutex_unlock(&rd->pscan.lock);
 		if (error)
 			goto out_abort;


