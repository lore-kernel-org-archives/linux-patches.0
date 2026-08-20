Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C3C377016;
	Thu, 20 Aug 2026 15:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238388; cv=none; b=Wkw33WoTW7z8B4e8FELbV1RGeLd6v2KdrmyLN4bVil/eXpSsz/WHInrkOUv/RN6q8skn1iKZDt2JSyCp7NX7QNXl6GRG9jMa3AEePSO4niD+SxW1GYK9mupS3F1eNglTB4k/bWyJ3QI/5KbkG9GA9qobjkDN5jlgpAhdBkVVYv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238388; c=relaxed/simple;
	bh=L6pw8fVUieBhT33dvTQzBIrSuhrSIsvDjIi1aUxqk+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6GW6sPwmb8x0VKG6EFYkt/Fh3eLf8iH2OHvcuL4uxzoYzoCytQ3F0T/ZctWPxG8BYndpYROQht0In9Mio9GEItvSK98my27JXDMGomm4GixOc9u1T6IcpM7CfNgPLd7/udK7XhQrryYAK1nGaSMA3AIxCfxKBEhBhbPRwAWivc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KePaJltL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KePaJltL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B391F000E9;
	Thu, 20 Aug 2026 15:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238387;
	bh=acO2llyQ30lYEo78v2W47ATkRWQP4o+EnJ4fwITBoZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KePaJltLR8xd3TeFghQy+AU42OVjkBpWmYwnt1S+HgWjzvys2xib5gseBr+EBR8Bv
	 bpcN4W0YCxNhDVeofE3ANX3aO2MX69qBLSWwtzQMPZuLm+PD6SeRlxVociK6ZyX9GK
	 HuS+22stv69gstxNoFrSQnMElDX4cIH+RWj198BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Qiang Ma <maqianga@uniontech.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 129/228] xfs: clear zapped attr fork state when bmap repair finds no attr fork
Date: Thu, 20 Aug 2026 16:54:31 +0200
Message-ID: <20260820145248.534447134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


