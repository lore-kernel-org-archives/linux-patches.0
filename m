Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9411E42D77B;
	Thu, 16 Jul 2026 14:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212137; cv=none; b=YZr6gpPu5OhaBViOYvaCjrv3VztdDtnoz1ca4UYsBxJLyZzi2LKth7938VwEUIqFtq7ikQcKHbJ25IazECpctDG21Y8o9wTfyGq4BO8V5qt+AtgHYDgPlaoyJNJMETuQrn+y+hUU0sQ7TYWoQ96fkuy0676T2N9DWa1AoFIGzRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212137; c=relaxed/simple;
	bh=4hK4PCuR/+egAgDGmwbsXTZF5izMoaJ7z1RDbHKdl98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klYkQgtdJs+tHcjkdZ8YbuAmq48KP6163kFOF1ywB34f4+d9+PLf5nDJnbhL0P2VUfgDGGEmdWZu1VaE6zCGALsdFSFgkUarSuQetLhd8/CmU/ygM+1p0DMoiwXpszPQAZwjmURKUoq4P4Bv8+HEccWq5iU3fKXYpKnZjjDy23s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGSknQt1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGSknQt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BB71F00A3A;
	Thu, 16 Jul 2026 14:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212136;
	bh=hr7ma4xMSVG4fs9nqHXuQFTTw53ALMEBWRWGm/yIkDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGSknQt1wt0EhdwkXXDfLb//piVo9xwFWdfOtZApcWKeUXtH1nop5Kb0dIQeYYBFn
	 8MK4N8qEWlpjx1cdSh0Iz9a3dQva8igqg8cwPid086Uno6EkPguDxCmSeF3sKWg+05
	 //sf6bEMVBNHfuGWO0xMgu/DC5JHBAuS4z1j5NAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 213/349] xfs: fix unreachable BIGTIME check in dquot flush validation
Date: Thu, 16 Jul 2026 15:32:27 +0200
Message-ID: <20260716133038.130709017@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Alexey Nepomnyashih <sdl@nppct.ru>

commit 03866d130ed33ab68cc7faaf4bf2c4abef96d42e upstream.

The dqp->q_id == 0 check inside the XFS_DQTYPE_BIGTIME block is
unreachable because root dquots return successfully earlier. Reject root
dquots with XFS_DQTYPE_BIGTIME before that early return, preserving the
intended validation and removing the unreachable condition.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 4ea1ff3b4968 ("xfs: widen ondisk quota expiration timestamps to handle y2038+")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Alexey Nepomnyashih <sdl@nppct.ru>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Allison Henderson <achender@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1247,6 +1247,14 @@ xfs_qm_dqflush_check(
 	    type != XFS_DQTYPE_PROJ)
 		return __this_address;
 
+	/* bigtime flag should never be set on root dquots */
+	if (dqp->q_type & XFS_DQTYPE_BIGTIME) {
+		if (!xfs_has_bigtime(dqp->q_mount))
+			return __this_address;
+		if (dqp->q_id == 0)
+			return __this_address;
+	}
+
 	if (dqp->q_id == 0)
 		return NULL;
 
@@ -1262,14 +1270,6 @@ xfs_qm_dqflush_check(
 	    !dqp->q_rtb.timer)
 		return __this_address;
 
-	/* bigtime flag should never be set on root dquots */
-	if (dqp->q_type & XFS_DQTYPE_BIGTIME) {
-		if (!xfs_has_bigtime(dqp->q_mount))
-			return __this_address;
-		if (dqp->q_id == 0)
-			return __this_address;
-	}
-
 	return NULL;
 }
 


