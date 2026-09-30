Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D084B5172E0;
	Wed, 30 Sep 2026 17:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787979; cv=none; b=uvv+4aXF/g6vwX2nJLETL5V65i6laGZLx6KHJ/RrqeUUN+dN8OFhD0l7/5DDt/ChzWSOC0ouR6iXkr1Zs7EheQaINXL2kuy4rR/ZbeTjQ4MJf3R0rXd52ILDHIIUBWtaCNF5JSeQTN+gDWOYiqP+DoBMoNRwGcVv9UCpln8L40I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787979; c=relaxed/simple;
	bh=ZzViYToFES0NgZ42awMXeyNSn8uk6hCjjOokJvik7DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsNSasICTrO6/wXFiA4Xro1+8qoZurilTswMdzqcPTdXlvm6lTzrSoZk1clzb4cq3iLDhiNBDmR/PoO4Lu74+G05BOYL6kTZfXULXkWJn4Z7BTvwnFo2XTQ54kPH7TTyyc8iEdjF+uWM/pNEvgZDCjVBMRV8Q4921K8KGmv32jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WHzGVTf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WHzGVTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D091F000FF;
	Wed, 30 Sep 2026 17:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787978;
	bh=R8Vv7C3aGkSd52ma3v7JSlSgj6diVASwFEKTtsnARLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1WHzGVTfcPpRgOg8YZk6AKmaZbP8mTK4qLh0w3sl2Sw5eufglio4SNFs3WOijIiyM
	 BRWOdzoUkXumnCpIaDsREM1AoTnQyXH1bcTgNmtQtv0scpzOunYrG6NHPbx7uKeqoc
	 4nhsfWpuJJ8VG1Z2BfaJkmuAAKy8fGuvCt1ouVOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 421/457] xfs: dont call xfs_exchange_range_finish for a dry run
Date: Wed, 30 Sep 2026 17:28:46 +0200
Message-ID: <20260930152355.072011001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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


