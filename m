Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE5C37FF42;
	Thu, 20 Aug 2026 15:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238981; cv=none; b=ltdxDIgwL2Yzf2yfRmv2VO4ZqoGGD7d7rBV//6IQVQOWNhx57/PMnXx23s+BkqwIgZenclV2eUVGD9Ckmj1Wcbef3QNxNBgFHBFda5tD2V1orsiCErcGCcAHTglh7r0YMBJUcuhCzVDktRnGGMe6fHMEFqVZWR2uD6JvcpUIR9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238981; c=relaxed/simple;
	bh=1aihZBQvLK211PlKH3mQHWcLR2sV8xv1Q9NRbKKaTpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/Iqc5n7pvlGAAdMQsU1Fks7OPUWJtExVz6FE7lmLB2Tsa+i3PGTBZNFsuZ1XDRgJPqICZh6fhE/xluZfYlRnzdgfRQlroruP143BZ1J+uRFZ0pzJkIdDuzR1RJfeh/uBytnzT9/87chK6opcMSxEhau1eNPohvOQTUZZNtCpes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTA9Fpm8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTA9Fpm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1141F000E9;
	Thu, 20 Aug 2026 15:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238980;
	bh=OP5+6kFNAWcdOGuL49CFFNss2EBSiPXsy0A3Poy1KGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTA9Fpm8RYq9koK5JWdxLsSy83xIng5SyVdiv09usW8lJAyX21OPxoPHQ6fJOtxLX
	 Gm0+GqOP0PFdCS491mgUUinQmp+TsLBss6Xda2L5A/nEGQWLBjz/YMILv47S3/+Zdj
	 609cIIhLX47ZGO+B6akTWIfPYRzXanlDay5uUJvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Qiang Ma <maqianga@uniontech.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 107/217] xfs: clear zapped attr fork state when bmap repair finds no attr fork
Date: Thu, 20 Aug 2026 16:54:35 +0200
Message-ID: <20260820145240.958877139@linuxfoundation.org>
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
@@ -1170,6 +1170,11 @@ xchk_bmap_attr(
 	}
 
 	error = xchk_bmap(sc, XFS_ATTR_FORK);
+	/* A repaired, empty attr fork no longer has mappings to check. */
+	if (error == -ENOENT && (sc->flags & XREP_ALREADY_FIXED)) {
+		xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_BMBTA_ZAPPED);
+		return 0;
+	}
 	if (error)
 		return error;
 


