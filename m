Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7F025632;
	Mon, 14 Oct 2024 14:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916690; cv=none; b=r8la1kyJA/8xLr4+Mw8MfuhbLOF8iKCnpb+3IK3n5SN+sBRDV9yhKM02rVGkIUQqrz9y/Gw2LTkzCQjBEw8LTIOIe9WlLL2CU+Y7d7ULynWWgAnwEmfJV3cwTUUik7uUVQR/Kk/iG9egAgWh1Wxo4A26GBXsr92uYwGwPwQ+vOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916690; c=relaxed/simple;
	bh=ivwGnSnytXHHIDfuAAEiDKEycktn6BRORXTackE+0Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVpAiVxou9PSyQgjRNO+W46uxF9dSwjq0SYxndIfHDv2TLpkw63wuYKmheiwCzPzJ0YtoyJ6cjJN4Ik+OU2ZvF2vvJI1p4L10EJylzG5KdON6g+VFCUC/AfZqXWYva+dFLoajK+dUiq8XMB0QXslAKNcg0lAYTwO2eEfwSFdd78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJu7UTvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJu7UTvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15394C4CEC3;
	Mon, 14 Oct 2024 14:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916690;
	bh=ivwGnSnytXHHIDfuAAEiDKEycktn6BRORXTackE+0Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJu7UTvrwwZvrLgY8fK3QkVyxSdx1u9frS2YFQu9f9IKOWxeKoHxvXX+rQ/BsjJF4
	 wYUxJw+BlbMUHshgg/si9VjVbYynTS8QuiQmoyOdIWlFXHdLsJXsLPAtB2NI0LSV/q
	 BOeNHjv+/7cVdv5hr+pi6tqk0kPOUBIzNPbSjxHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/213] gfs2: Revert "introduce qd_bh_get_or_undo"
Date: Mon, 14 Oct 2024 16:18:33 +0200
Message-ID: <20241014141043.264794245@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 2aedfe847b4d91eabee11a44c27244055cef4eb3 ]

The qd_bh_get_or_undo() helper introduced by that commit doesn't improve
the code much, so revert it and clean things up in a more useful way in
the next commit.

This reverts commit 7dbc6ae60dd7089d8ed42892b6a66c138f0aa7a0.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 4b4b6374dc61 ("gfs2: Revert "ignore negated quota changes"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/quota.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 299b6d6aaa795..62522d4011106 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -475,20 +475,6 @@ static int qd_check_sync(struct gfs2_sbd *sdp, struct gfs2_quota_data *qd,
 	return 1;
 }
 
-static int qd_bh_get_or_undo(struct gfs2_sbd *sdp, struct gfs2_quota_data *qd)
-{
-	int error;
-
-	error = bh_get(qd);
-	if (!error)
-		return 0;
-
-	clear_bit(QDF_LOCKED, &qd->qd_flags);
-	slot_put(qd);
-	qd_put(qd);
-	return error;
-}
-
 static int qd_fish(struct gfs2_sbd *sdp, struct gfs2_quota_data **qdp)
 {
 	struct gfs2_quota_data *qd = NULL, *iter;
@@ -511,12 +497,17 @@ static int qd_fish(struct gfs2_sbd *sdp, struct gfs2_quota_data **qdp)
 	spin_unlock(&qd_lock);
 
 	if (qd) {
-		error = qd_bh_get_or_undo(sdp, qd);
-		if (error)
+		error = bh_get(qd);
+		if (error) {
+			clear_bit(QDF_LOCKED, &qd->qd_flags);
+			slot_put(qd);
+			qd_put(qd);
 			return error;
-		*qdp = qd;
+		}
 	}
 
+	*qdp = qd;
+
 	return 0;
 }
 
@@ -1171,8 +1162,15 @@ void gfs2_quota_unlock(struct gfs2_inode *ip)
 		if (!found)
 			continue;
 
-		if (!qd_bh_get_or_undo(sdp, qd))
-			qda[count++] = qd;
+		gfs2_assert_warn(sdp, qd->qd_change_sync);
+		if (bh_get(qd)) {
+			clear_bit(QDF_LOCKED, &qd->qd_flags);
+			slot_put(qd);
+			qd_put(qd);
+			continue;
+		}
+
+		qda[count++] = qd;
 	}
 
 	if (count) {
-- 
2.43.0



