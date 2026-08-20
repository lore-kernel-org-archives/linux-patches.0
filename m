Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CD419E992;
	Thu, 20 Aug 2026 17:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787246982; cv=none; b=Oqo5BuJsxQqCFziIDWQ4qCXJ8aWWACIFiKccP2QTf1y3hOktqlE0QsijwUc4nWSD6yj6iZc820Hl9LntStOs7em/ALjE4M05maR86SWGK9ioqYEPwguh5HLOrciF0GftVc5NhT1YCh+ZVifaIS1hR4DofNcPyWhc8wZpB6ookkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787246982; c=relaxed/simple;
	bh=gfZtqRUuE8a1VSNJQATkdY3N+6QYpQYjFwS5IkaWEcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g94yFz3904kTjhjQj7o8e0md0EAsTnMGzv6vczh7QG2GPubXwA+gAlQ0kqVAko/BEMt7gYvnoTzSdaJ0kpc4uBhYk7BZmgOXRESt6IKfHvFZ68qFtdtQ0lhF+eDbEIqtlYmYzewAIG9GiN4gXN31BnUVpa5RlbtfXBeRTOEuC+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tv65b6Lh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tv65b6Lh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB45E1F000E9;
	Thu, 20 Aug 2026 17:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787246981;
	bh=5TCFe3kPEJT1WJOuL9qUw+vKR2/5TfxBTvA6euE1RKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tv65b6Lh5JC0MaNXzCEu+thEJ6mIvGYYJLz3FwkV4N5RG0MbnNKFNFfgokZVE7UtQ
	 +wc6arzCi8vwcpsPkj30JDbDk9GOPYSVjzeA8uk8rGcEC8+vP7luvbx8PjlJeYwaCr
	 L2kKpcGA7gzCfHzmuxYpfzOqTQfxXu2Uol1J+078=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 109/220] xfs: check xfarray iteration errors when committing unlinked inode lists
Date: Thu, 20 Aug 2026 16:54:59 +0200
Message-ID: <20260820145226.753796507@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 2daf3ed5d059dec79c123aec42eb8d28e0c016d4 upstream.

LOLLM noticed that we neglect to check for xfarray_iter itself returning
errors when writing a new AGI.  Fix that.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1748,6 +1748,8 @@ xrep_iunlink_commit(
 		if (error)
 			return error;
 	}
+	if (error < 0)
+		return error;
 
 	/* Fix all the back links */
 	idx = XFARRAY_CURSOR_INIT;
@@ -1756,6 +1758,8 @@ xrep_iunlink_commit(
 		if (error)
 			return error;
 	}
+	if (error < 0)
+		return error;
 
 	/* Copy the staged iunlink buckets to the new AGI. */
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {


