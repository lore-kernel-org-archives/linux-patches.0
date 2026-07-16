Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FF230C361;
	Thu, 16 Jul 2026 14:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211182; cv=none; b=AuEOKpDmuK55kRvzJnOJcNziEGeZ7BlwvITvGLiGGS/i7uoJBxjPQQmDLHiBuwpjAHUdr9K/3Mto4L4mRN452FdhQlcnxn3Ecpq1v94PHxoRsP4Vd0lj9Oek+O3O8UqOp+NVCZCxrTvJp6B0/dNnxMTT8ukLwqKpwngBaH+/WjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211182; c=relaxed/simple;
	bh=1zpm30A9AHzkRlb12XNdqk3gLcZM2KSK3Tywo7Jmt2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wxr8yz8jQUKyNobVxBfxGqnB6xEzCBJqvoK+Ryi4XfoDhiAEjUAHmtyfSuvzJbjVAzSCXgQ/OAy3v4n2PAnaAWzy4EhOMfhR4xY4akgDcreXmL9ZrISQ9QA6AX9n26UprxB5iegB3CJ5RrGmQRtprkRU1a+6VS73M/frxQcjB70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsaaOqJn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsaaOqJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30D61F000E9;
	Thu, 16 Jul 2026 14:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211180;
	bh=uDfJHOq+UbbqHLTeVlAMIBEtBWHgp/s+F6A+NNuFOj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GsaaOqJnD7PVzdmJ1PSiqd1nxQ0WlGZ6bCvEZKlrEUWEp0Yrn2uXS4pW0sZ/LdH6p
	 E7iDoIPqiGcyHZzmaVJO+aQEo9NcwKYmkCor2uBbwkIZ38aRJz940I0qNS6up97dgq
	 StRv91S+quwBNHz6R0yRblNhunN2xzg3ZxFHbuuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 276/480] xfs: fix unreachable BIGTIME check in dquot flush validation
Date: Thu, 16 Jul 2026 15:30:23 +0200
Message-ID: <20260716133050.795675474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -1241,6 +1241,14 @@ xfs_qm_dqflush_check(
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
 
@@ -1256,14 +1264,6 @@ xfs_qm_dqflush_check(
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
 


