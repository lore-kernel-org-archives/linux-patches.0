Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDA3521886;
	Wed, 30 Sep 2026 18:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793674; cv=none; b=K55Ok896sb/f80CUOm88I7310HN5VVqXJq6kQyGjzKlqwIT/yHIo/V22g8WFByQfnKrrEvbVm/bi6sYSQr+siEyvUwVQh4mnwqFs5xcv5D27h9hsgSM6ToB4OMmagqe/nKdJaJvUg53jLc5q/oJPPJn+iqHM8tynMlRVupxFhu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793674; c=relaxed/simple;
	bh=HYedAQjJEQgzMaQuM0+Jq7EZvId21Ek1fUUXLvop3g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsPC+tV1FjRQ+dvpWItSYwHc7erH6L5toOtA2qTRCHSTtjd7l0rKuOaPeQhyadML3v3Avf9fnVUhEXuLuniVwJvZIltRbspAznJiPDdw8Hf0n1OTuhuaxFqb8OOKzhGQ3YC0yknYJZoL2K8OEikh0rXVrAGR0pkFh88BJKLQdK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZimZ20y0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZimZ20y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0618A1F000FF;
	Wed, 30 Sep 2026 18:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793673;
	bh=sZPD81S16cBjf+u4S2m9RYvw0ma36LSqr+O7wiFFjSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZimZ20y0a20JYYHWtipTu1XKNbh3JoEIuVOc7Qg+BTPL3wwj8sSWzzyS4/fOw39UV
	 096xx04lAHxcRObXkRYJPuRQgNg9/ldeK2cLSpSNGghnUW4OzHf7xT2PDBxOf/+Hkm
	 5VPXmvB927p4jwOSvfCOnTK5L0vk679Uf4qq4Zrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 338/395] xfs: dont call xfs_exchange_range_finish for a dry run
Date: Wed, 30 Sep 2026 17:30:00 +0200
Message-ID: <20260930152347.999235223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

commit 8fc18580ec17f90beac4c933fbe4c74dcd3b7f36 upstream.

LOLLM noticed that we strip file privileges and whatnot even for a dry
run.  We also shouldn't flush dirty data to disk or trim COW staging
events for a dry run.  Neither of those behaviors are allowed by the
manpage, so fix that by exiting early on DRY_RUN in various functions.

Cc: stable@vger.kernel.org # v6.10
Fixes: 42672471f938cd ("xfs: bind together the front and back ends of the file range exchange code")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_exchrange.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -633,6 +633,9 @@ xfs_exchrange_prep(
 	if (error)
 		return error;
 
+	if (fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)
+		return 0;
+
 	trace_xfs_exchrange_flush(fxr, ip1, ip2);
 
 	/* Flush the relevant ranges of both files. */
@@ -709,9 +712,11 @@ xfs_exchrange_contents(
 	 * other file write would do.  This may involve turning on support for
 	 * logged xattrs if either file has security capabilities.
 	 */
-	error = xfs_exchange_range_finish(fxr);
-	if (error)
-		goto out_unlock;
+	if (!(fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)) {
+		error = xfs_exchange_range_finish(fxr);
+		if (error)
+			goto out_unlock;
+	}
 
 out_unlock:
 	xfs_iunlock2_io_mmap(ip1, ip2);


