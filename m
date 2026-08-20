Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F1247ECFC;
	Thu, 20 Aug 2026 17:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787246943; cv=none; b=iSTrF5kl463jfMpnmtxHiLSf5JzMviHRaO3VErum0yRwIKxPJSjMhpEpUHGmMlfsR6JbcId2EE5sqK7kaXDOVFNCOnH6Ndf5ULIwheJxTfAi5tUF16n+tuklphHZWKEB4jn23zZYtn/TIGMHOwt3+P7jJPpFsjQFEe1ULVr7tiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787246943; c=relaxed/simple;
	bh=QaV6gVz3M5ZdhgdXZLZdOrlyxmVLndkQimWLxHdJ65k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMj7eZnzJCvyfXCRbS/WY7onWMlv54AU9viiNOz0wdj9TwWOMcHfcjtviJ5dKOhs7WQUhCKSdNm8aJGbhYo6TP54n04xLiIzrw/MCadgWX8oHIs89xiYkJrcE8VdHmb6zjIc5pA2QZd2jgJWxhyVbPW5x6TR6HWAnYpOTHXZaCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQGnjhCE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQGnjhCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038791F000E9;
	Thu, 20 Aug 2026 17:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787246941;
	bh=y15xia7w7kMJm8vqO0oQwPEVbimaOjnkKj/ciFsxrZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQGnjhCEY3fZlWum25DikduWXZ3h57DaA0dxglnlQbhVovRECyhaxO0NNmuos3Xa1
	 PjzUzo0jCbs00GStZFWWNvYNH+j7lCkhUQocbfLw8cg3VFDxiadhjjjRko/ozJL9rn
	 7cnoRbVOIRg2lYIz0bbl32Lv/qDYw4jtJhWfbJ8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Qiang Ma <maqianga@uniontech.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 092/220] xfs: clear zapped attr fork state when bmap repair finds no attr fork
Date: Thu, 20 Aug 2026 16:54:42 +0200
Message-ID: <20260820145226.244460138@linuxfoundation.org>
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

From: Qiang Ma <maqianga@uniontech.com>

commit 87b2a82e135ba81e49d82b59e3d72468cb66ea98 upstream.

xfstests xfs/377 can make xfs_scrub repeatedly check and repair the
attr block map after inode repair zaps an attr fork.

When inode repair zaps an attr fork, it records
XFS_SICK_INO_BMBTA_ZAPPED so that scrub/repair can revisit the attr fork
block map.  If the fork has been reset to an empty state and removed,
BMBTA repair has no attr fork mappings to rebuild and can return success.

The post-repair scrub then runs with XREP_ALREADY_FIXED set, which means
xchk_file_looks_zapped() deliberately ignores the stale zapped health bit
and asks xchk_bmap() to check the current attr fork.  For an absent attr
fork, xchk_bmap() returns -ENOENT.  Returning that error prevents
xchk_bmap_attr() from marking XFS_SICK_INO_BMBTA_ZAPPED healthy, leaving
the zapped health state behind even though there are no attr fork mappings
left to check.

Treat -ENOENT during post-repair BMBTA revalidation as a clean result for
the zapped attr fork: clear XFS_SICK_INO_BMBTA_ZAPPED and return success.
Keep the existing -ENOENT behavior for ordinary scrubs of absent attr
forks.

Fixes: d9041681dd2f ("xfs: set inode sick state flags when we zap either ondisk fork")
Cc: stable@vger.kernel.org # v6.8
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/bmap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -1062,6 +1062,11 @@ xchk_bmap_attr(
 	}
 
 	error = xchk_bmap(sc, XFS_ATTR_FORK);
+	/* A repaired, empty attr fork no longer has mappings to check. */
+	if (error == -ENOENT && (sc->flags & XREP_ALREADY_FIXED)) {
+		xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_BMBTA_ZAPPED);
+		return 0;
+	}
 	if (error)
 		return error;
 


