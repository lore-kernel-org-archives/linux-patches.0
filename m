Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7424409;
	Mon, 23 Jun 2025 21:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714463; cv=none; b=YL+fXovbsHzttXlp3XTNRU4MsK47Q9KN/jDip3jeQzyPnuwScvIdG4+6TRXpNhNGxClQkIZV7v8epcrq1qI3hHQt93N13ANZc4sqBh1aN5FKlqwpUMyOHjCrN2RxTVRWnm24M2ZM5acbK1Z6inOSONfdpqHr5i8wvNnb9KVZBag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714463; c=relaxed/simple;
	bh=ab86mJcEeloBx5zwdoBg4sAolgIVRgtqTZBZFzezc50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwRNMv2mPwjvlzXIOuZx2gVHreK5StRIvP6dI/4cSCKzskbN/MJHO4oaC6lStcsexX39LgKfqWT7A+E4Harb14RYq+uMM4ziF+3hQcuqmnUFfYLiIDJqm9mQoYIz5FPFywqsPZURD8HvilGGA96canUKfbQ7UI81djMkgwX0Fvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1J4+hLOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1J4+hLOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8A2C4CEEA;
	Mon, 23 Jun 2025 21:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714463;
	bh=ab86mJcEeloBx5zwdoBg4sAolgIVRgtqTZBZFzezc50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1J4+hLOZOIrFUAeA07E/U/6EeiARTvPBLyKkasn0XI3od7PU8HK6WAwtzA7KRl80J
	 QazEwKJLbQ7P/41QDd4D3SzXbOLoMEUZaBNhkFV50F5w0Sy+v4u1p2Oqd9rD2cOJNf
	 sY9iTImQxPSGRjvmI932YdJhI1JN228VM/SiXW+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/508] xfs: validate fsmap offsets specified in the query keys
Date: Mon, 23 Jun 2025 15:04:01 +0200
Message-ID: <20250623130650.092802829@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 3ee9351e74907fe3acb0721c315af25b05dc87da ]

Improve the validation of the fsmap offset fields in the query keys and
move the validation to the top of the function now that we have pushed
the low key adjustment code downwards.

Also fix some indenting issues that aren't worth a separate patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_fsmap.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index cdd806d80b7cf..d10f2c719220d 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -802,6 +802,19 @@ xfs_getfsmap_check_keys(
 	struct xfs_fsmap		*low_key,
 	struct xfs_fsmap		*high_key)
 {
+	if (low_key->fmr_flags & (FMR_OF_SPECIAL_OWNER | FMR_OF_EXTENT_MAP)) {
+		if (low_key->fmr_offset)
+			return false;
+	}
+	if (high_key->fmr_flags != -1U &&
+	    (high_key->fmr_flags & (FMR_OF_SPECIAL_OWNER |
+				    FMR_OF_EXTENT_MAP))) {
+		if (high_key->fmr_offset && high_key->fmr_offset != -1ULL)
+			return false;
+	}
+	if (high_key->fmr_length && high_key->fmr_length != -1ULL)
+		return false;
+
 	if (low_key->fmr_device > high_key->fmr_device)
 		return false;
 	if (low_key->fmr_device < high_key->fmr_device)
@@ -845,15 +858,15 @@ xfs_getfsmap_check_keys(
  * ----------------
  * There are multiple levels of keys and counters at work here:
  * xfs_fsmap_head.fmh_keys	-- low and high fsmap keys passed in;
- * 				   these reflect fs-wide sector addrs.
+ *				   these reflect fs-wide sector addrs.
  * dkeys			-- fmh_keys used to query each device;
- * 				   these are fmh_keys but w/ the low key
- * 				   bumped up by fmr_length.
+ *				   these are fmh_keys but w/ the low key
+ *				   bumped up by fmr_length.
  * xfs_getfsmap_info.next_daddr	-- next disk addr we expect to see; this
  *				   is how we detect gaps in the fsmap
 				   records and report them.
  * xfs_getfsmap_info.low/high	-- per-AG low/high keys computed from
- * 				   dkeys; used to query the metadata.
+ *				   dkeys; used to query the metadata.
  */
 int
 xfs_getfsmap(
@@ -874,6 +887,8 @@ xfs_getfsmap(
 	if (!xfs_getfsmap_is_valid_device(mp, &head->fmh_keys[0]) ||
 	    !xfs_getfsmap_is_valid_device(mp, &head->fmh_keys[1]))
 		return -EINVAL;
+	if (!xfs_getfsmap_check_keys(&head->fmh_keys[0], &head->fmh_keys[1]))
+		return -EINVAL;
 
 	use_rmap = xfs_has_rmapbt(mp) &&
 		   has_capability_noaudit(current, CAP_SYS_ADMIN);
@@ -919,15 +934,8 @@ xfs_getfsmap(
 	 * other mapping for the same physical block range.
 	 */
 	dkeys[0] = head->fmh_keys[0];
-	if (dkeys[0].fmr_flags & (FMR_OF_SPECIAL_OWNER | FMR_OF_EXTENT_MAP)) {
-		if (dkeys[0].fmr_offset)
-			return -EINVAL;
-	}
 	memset(&dkeys[1], 0xFF, sizeof(struct xfs_fsmap));
 
-	if (!xfs_getfsmap_check_keys(dkeys, &head->fmh_keys[1]))
-		return -EINVAL;
-
 	info.next_daddr = head->fmh_keys[0].fmr_physical +
 			  head->fmh_keys[0].fmr_length;
 	info.fsmap_recs = fsmap_recs;
-- 
2.39.5



