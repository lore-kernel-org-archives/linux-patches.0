Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A069F158D96;
	Wed,  5 Feb 2025 15:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768653; cv=none; b=Lb4OtvtVVcfZNFGSCCVuYfawYxIrowlVOjS7uKGQN101nDc1JIdhrD6A5RHQIJ7PT+QBI+Q4PJI7KwKyVKjQF2m/OLa4KIS924I1k984x6PARIZbyqJLBghtlTQ1PVs4aWwYhZWHpJq8JO/YS0BhJyBTkHluKuSNoyEDzymTNCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768653; c=relaxed/simple;
	bh=ShDXIl9zFzh1C+8NbvJfh6JFgC9LIXl5NI2zawGCBx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBdAQD5r2LIQ8jeG39gTcqWVp1j6y8BZiUMB/m01W3RgTnY7KepHv+aADcaauI9Y0IBoO9Wv4q3Zz5DWB+F2G51vFaX4G+/juoyVQcXSM572paBE+bnvFFJG5mW5naLoCbDQYXVpoqVhkov/mwVyWA1dazQ68qXFhXswBncrciI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFEJFul0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFEJFul0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3E5C4CED1;
	Wed,  5 Feb 2025 15:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768653;
	bh=ShDXIl9zFzh1C+8NbvJfh6JFgC9LIXl5NI2zawGCBx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFEJFul0MQi7vsMEDfj1leSV3S/rU7tBT7f+0Dgx8Iz1zEn9qDAc5fuS0TGLZGemf
	 JL9ibDTRM39BoolbzHUXo9WfiEctfBX4GWQj5aDl9PxGgR4z31T+yWjq5pP/+JYnoN
	 sZW8y6tWXDqLFbGyylHYUu/d8d+djFbXp3gLBE1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.13 587/623] xfs: dont shut down the filesystem for media failures beyond end of log
Date: Wed,  5 Feb 2025 14:45:29 +0100
Message-ID: <20250205134518.682383829@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit f4ed93037966aea07ae6b10ab208976783d24e2e upstream.

If the filesystem has an external log device on pmem and the pmem
reports a media error beyond the end of the log area, don't shut down
the filesystem because we don't use that space.

Cc: <stable@vger.kernel.org> # v6.0
Fixes: 6f643c57d57c56 ("xfs: implement ->notify_failure() for XFS")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_notify_failure.c |  121 +++++++++++++++++++++++++++++---------------
 1 file changed, 82 insertions(+), 39 deletions(-)

--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -154,6 +154,79 @@ xfs_dax_notify_failure_thaw(
 }
 
 static int
+xfs_dax_translate_range(
+	struct xfs_buftarg	*btp,
+	u64			offset,
+	u64			len,
+	xfs_daddr_t		*daddr,
+	uint64_t		*bblen)
+{
+	u64			dev_start = btp->bt_dax_part_off;
+	u64			dev_len = bdev_nr_bytes(btp->bt_bdev);
+	u64			dev_end = dev_start + dev_len - 1;
+
+	/* Notify failure on the whole device. */
+	if (offset == 0 && len == U64_MAX) {
+		offset = dev_start;
+		len = dev_len;
+	}
+
+	/* Ignore the range out of filesystem area */
+	if (offset + len - 1 < dev_start)
+		return -ENXIO;
+	if (offset > dev_end)
+		return -ENXIO;
+
+	/* Calculate the real range when it touches the boundary */
+	if (offset > dev_start)
+		offset -= dev_start;
+	else {
+		len -= dev_start - offset;
+		offset = 0;
+	}
+	if (offset + len - 1 > dev_end)
+		len = dev_end - offset + 1;
+
+	*daddr = BTOBB(offset);
+	*bblen = BTOBB(len);
+	return 0;
+}
+
+static int
+xfs_dax_notify_logdev_failure(
+	struct xfs_mount	*mp,
+	u64			offset,
+	u64			len,
+	int			mf_flags)
+{
+	xfs_daddr_t		daddr;
+	uint64_t		bblen;
+	int			error;
+
+	/*
+	 * Return ENXIO instead of shutting down the filesystem if the failed
+	 * region is beyond the end of the log.
+	 */
+	error = xfs_dax_translate_range(mp->m_logdev_targp,
+			offset, len, &daddr, &bblen);
+	if (error)
+		return error;
+
+	/*
+	 * In the pre-remove case the failure notification is attempting to
+	 * trigger a force unmount.  The expectation is that the device is
+	 * still present, but its removal is in progress and can not be
+	 * cancelled, proceed with accessing the log device.
+	 */
+	if (mf_flags & MF_MEM_PRE_REMOVE)
+		return 0;
+
+	xfs_err(mp, "ondisk log corrupt, shutting down fs!");
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_ONDISK);
+	return -EFSCORRUPTED;
+}
+
+static int
 xfs_dax_notify_ddev_failure(
 	struct xfs_mount	*mp,
 	xfs_daddr_t		daddr,
@@ -263,8 +336,9 @@ xfs_dax_notify_failure(
 	int			mf_flags)
 {
 	struct xfs_mount	*mp = dax_holder(dax_dev);
-	u64			ddev_start;
-	u64			ddev_end;
+	xfs_daddr_t		daddr;
+	uint64_t		bblen;
+	int			error;
 
 	if (!(mp->m_super->s_flags & SB_BORN)) {
 		xfs_warn(mp, "filesystem is not ready for notify_failure()!");
@@ -279,17 +353,7 @@ xfs_dax_notify_failure(
 
 	if (mp->m_logdev_targp && mp->m_logdev_targp->bt_daxdev == dax_dev &&
 	    mp->m_logdev_targp != mp->m_ddev_targp) {
-		/*
-		 * In the pre-remove case the failure notification is attempting
-		 * to trigger a force unmount.  The expectation is that the
-		 * device is still present, but its removal is in progress and
-		 * can not be cancelled, proceed with accessing the log device.
-		 */
-		if (mf_flags & MF_MEM_PRE_REMOVE)
-			return 0;
-		xfs_err(mp, "ondisk log corrupt, shutting down fs!");
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_ONDISK);
-		return -EFSCORRUPTED;
+		return xfs_dax_notify_logdev_failure(mp, offset, len, mf_flags);
 	}
 
 	if (!xfs_has_rmapbt(mp)) {
@@ -297,33 +361,12 @@ xfs_dax_notify_failure(
 		return -EOPNOTSUPP;
 	}
 
-	ddev_start = mp->m_ddev_targp->bt_dax_part_off;
-	ddev_end = ddev_start + bdev_nr_bytes(mp->m_ddev_targp->bt_bdev) - 1;
-
-	/* Notify failure on the whole device. */
-	if (offset == 0 && len == U64_MAX) {
-		offset = ddev_start;
-		len = bdev_nr_bytes(mp->m_ddev_targp->bt_bdev);
-	}
-
-	/* Ignore the range out of filesystem area */
-	if (offset + len - 1 < ddev_start)
-		return -ENXIO;
-	if (offset > ddev_end)
-		return -ENXIO;
-
-	/* Calculate the real range when it touches the boundary */
-	if (offset > ddev_start)
-		offset -= ddev_start;
-	else {
-		len -= ddev_start - offset;
-		offset = 0;
-	}
-	if (offset + len - 1 > ddev_end)
-		len = ddev_end - offset + 1;
+	error = xfs_dax_translate_range(mp->m_ddev_targp, offset, len, &daddr,
+			&bblen);
+	if (error)
+		return error;
 
-	return xfs_dax_notify_ddev_failure(mp, BTOBB(offset), BTOBB(len),
-			mf_flags);
+	return xfs_dax_notify_ddev_failure(mp, daddr, bblen, mf_flags);
 }
 
 const struct dax_holder_operations xfs_dax_holder_operations = {


