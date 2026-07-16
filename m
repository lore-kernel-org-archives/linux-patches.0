Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6366D4248B8;
	Thu, 16 Jul 2026 13:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209717; cv=none; b=VgBtjjqkMbO8NdnuOIkV9EyaKVheaIQzKFxW+1b3HP0oDEdR8BaErHSO4W2vYAmcAwyw8dJd8KmPDZDzxXODl8ZnRk6MpjYWTugpT2J513uGpV3e0Fe+OaRz4RiBzNHiwW3sEt/R9hwM4FH9oOPwoQokezPZAID+1GA9qbZNTL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209717; c=relaxed/simple;
	bh=YGSEnw1i7te/fOOEYA/913SQT4DxiAYjbWZrtAz5LuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyYFTxxiHszYNgUZAp+m6oQbNDujzkqDfg0KHPn9rD7YeB6lXLT6sjz20kROkYI4LaX1evfKmU4JvEw7apWpjtiaXHeRTLzYbnUjOLUU5Mza9EOjR0AS5U6EuTGyiZOjll5dclQrCu7jsHXfz14C5oZn3nfPKyWgr43FaUCLkeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLvjcl1k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLvjcl1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155B51F00A3F;
	Thu, 16 Jul 2026 13:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209707;
	bh=mEYQN8LEQ92QICpCtLMZz5Q7CJu24qarGsdxGaon5u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLvjcl1kgwGE2lEHGN/IE3DyfOcxmbGTweNSZfRtWxWVT7YRSh4eHUDqHPjkGwHYs
	 7bBgZU6AxLC0qYIvgO86PSmQ1UsQlCeijf2yxBpqimZppW0UgXBu8qn6b2e54ZbZ12
	 rud0bSSAS0r7bZPyTDUt6uqMYaV7aYNhbyFXo5YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 287/518] xfs: fix unreachable BIGTIME check in dquot flush validation
Date: Thu, 16 Jul 2026 15:29:15 +0200
Message-ID: <20260716133054.098467367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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
@@ -1216,6 +1216,14 @@ xfs_qm_dqflush_check(
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
 
@@ -1231,14 +1239,6 @@ xfs_qm_dqflush_check(
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
 


