Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E09443A8A;
	Tue, 21 Jul 2026 21:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668401; cv=none; b=ixSY+UmL6M4muLUw8hESzzm19IR3q6NQTgEmodexz6uOwhONq2fKt1yRDjWPoOGeYedykPRl1N3Ia3GMhpzWRt5hXzjLAOf36SgJBBudLQtTjJEB8BY8I9cr5LnGD3H9vNUIDeDDaevHH0pVjb+LdO/10YvDvcf8ari2jTDhXlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668401; c=relaxed/simple;
	bh=Yql/wuisJOcxlUL9yOH5MO+r3rogNC+BGLFRRh0n6dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHmIc2KgjHALiiy4tmUhRj1Im3LZncjGqwQOGT9zw0K/mKkxG9TLGLYjnwsw/L/cVT2FMJzby5xJLv9jwaX7eu8HyaE+Kw8XzqweThtWKOaevdGRyhm7dNxQ8RyofLhASCfT4eHPIq0yZyBMwv1a9NpCycIlR4OhwcOX2MRdtIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwE+Ac0F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwE+Ac0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C4C1F000E9;
	Tue, 21 Jul 2026 21:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668399;
	bh=QpDS3gJFnGkrZjSQzJz/wTOYkS9mCTrXm0QgpwN0TLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qwE+Ac0F/P3B1ewzmPGnu5ws8seHtU62FokyfVaJraBX6/G8gz0UXbn6RBRa0uxgk
	 PvQcJBdufrI3MEBYpPHGivqGK3Ad6cxmfbua1pOlb3xi8Zf2W6mvVgfbnhbqgySmXo
	 o6CSozWTBPad9KZ9H2kTPk2Zl6qF0IyUZ8yKw7Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 0162/1067] xfs: fix unreachable BIGTIME check in dquot flush validation
Date: Tue, 21 Jul 2026 17:12:43 +0200
Message-ID: <20260721152428.212636225@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


