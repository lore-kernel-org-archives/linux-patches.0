Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E4135C1A6;
	Thu, 20 Aug 2026 15:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238998; cv=none; b=uJ9T5jrH0xttTq3JBgi9DUYapBwH3uZqAMSS3y57n8dUlYns9OKYoYlt1PC9EqTPpvr5Lopo28fpdF2Q4a2OAF9xzCu05jS49Gx03zcaRLV1PzgTIGVcUXcmZP9xQL+p1zEanX0QdrSA5tIw8xAkxoUuQI/hFRBXQLERfMXXIGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238998; c=relaxed/simple;
	bh=eei+KwHKhO/A+MhF2R6MrA32P/MkF8/J/vh1NH5UMGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNDyM8LsV9gdF5SpWakBxhzwJqh8pyBSyx8C1wm307GxjobwAp0mht7hqUWWWl+APFwz+gR9sJAVVAaBGKiB5vczCW17u+ajpejsmdrumbgq6+8jGTD3QDxqiev9QQwEO4dOqNQbYGSd69d+oDDYQZ78ShJydGMKSt4CDNT3qK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxakhBqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxakhBqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038AA1F000E9;
	Thu, 20 Aug 2026 15:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238997;
	bh=9KtVTszGrgm5l2/MrnsSkKKWItBe8Gq22nEE6XHdq6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KxakhBqEnpdBl67LcR+4esTzL9GqEdwa3KFMf5fAwpPNx3z3c4DC/ECvXFutgl/aN
	 LUc3Qz5fe3O/4xfwokcBsdDZWJ7+1BurdDaRC/9PRglmrxi17/B4PzVHqx2xMeIP1B
	 DBWPWEN5/nyUrNTa+UEvjvk6+XWbBRh3IIRlbuzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 113/217] xfs: set the prev pointer when reinserting an inode on the unlinked list
Date: Thu, 20 Aug 2026 16:54:41 +0200
Message-ID: <20260820145241.142284220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit af146cb7ff8ff5c54162f35c238f3ff1d5ad110f upstream.

If we find a rogue free inode and decide to reinsert it into the
unlinked list, we need to set the prev pointer to NULLAGINO so that the
incore list gets updated.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1434,6 +1434,10 @@ xrep_iunlink_add_to_bucket(
 	if (error)
 		return error;
 
+	error = xrep_iunlink_store_prev(ragi, agino, NULLAGINO);
+	if (error)
+		return error;
+
 	/* Remember the head inode's previous pointer. */
 	if (current_head != NULLAGINO) {
 		error = xrep_iunlink_store_prev(ragi, current_head, agino);


