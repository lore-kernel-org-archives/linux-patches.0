Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C62623C368;
	Tue, 21 Jul 2026 20:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665225; cv=none; b=r4EGlA0U6JwKtgakRmA9ZZuDef3rWgHazDB6t4heZk0VBxj/AFZk2SoM2ZRAkIcdTKeShWTwcD1DGKBzYDaMmWtCP8TmflxYJEiI/Xd9rXqTXDj7xO7xbTmKT7U8hDTq4avVAzXfm9VtRS6sgb+UrtvJa4GEykzR9eFpt7JhbmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665225; c=relaxed/simple;
	bh=4StuF3w0A+pxug/HQOuK0J1q0ZhDKV3m/FBQR1xlGTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAq6GSzgI3T+kPkp5qbIfu67kNIgZgTkdek7FrVrZ3qXOewdhqxrToYJyST8szcpf6Lt5z7bazVmYpuOO8DyAwnzyMWFlTR2d/WvTEppvs3xnNmkS+6bXH4jdQ+2OzxFA92kqQ6zrP0J86+/65S8QyBP+m958IzXTbNlmxS3t1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joIr2GXf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joIr2GXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9174D1F000E9;
	Tue, 21 Jul 2026 20:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665223;
	bh=wJClhmYr4eTnRSoiyFLP8IpIvEBcML1YRjlErAg5bok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=joIr2GXfU1mcz9Hp6P6d7q7cIMUtx5YfDTPb6q3/7OvFpuJN+w5SGZlk6wPBZqI2x
	 rCUDA6jsV7cF09JusgELoM3pSIbEobWI1rR6O5swlNvhhXrcS9t9aaPuLOrvwpJ2CY
	 aB3zw1pPgwuOplAG9pL5tHNeUiK5Bizr6a6KWzZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0221/1266] xfs: fix unreachable BIGTIME check in dquot flush validation
Date: Tue, 21 Jul 2026 17:10:58 +0200
Message-ID: <20260721152446.762925325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1174,6 +1174,14 @@ xfs_qm_dqflush_check(
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
 
@@ -1189,14 +1197,6 @@ xfs_qm_dqflush_check(
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
 


