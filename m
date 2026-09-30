Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468335187E2;
	Wed, 30 Sep 2026 18:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793700; cv=none; b=VIUgcWiFY1zNP7lqww+f1ujZ2VtaIdppzUR98sR33Hjz9w9aELPNV1f/t0F/+yay8OJwv7xmNiAWFoj3wLnvGNj7b53pqeBquEu5+w0GDXUa7e06+ASzWu/Xy5CzcoeUYavAPyGq2XzLvC/mBm7uSE81f4by2ecNiTZPpqXBZb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793700; c=relaxed/simple;
	bh=fYHuTOheHiJ2Qw5tq9kH4uwtMNlpxX7HJXMSO5QaGvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+egEiwLuLEY4sk/Ep+8yu48jFDbCjaixG6iyQHaS7tpg0yC7lu7I7fwSsjnpe1JEKQb2W/X/Mi301/+szHyD1+sVPalyIh6tMyQfDQG1WknEFne4rX/Jvt0MM9QrXtBgxyfjwQ9BR2AHeOpPQxiYILQijKplDjXvI09pwmp0nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSzRYJ2f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSzRYJ2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33831F000FF;
	Wed, 30 Sep 2026 18:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793699;
	bh=auHMzKTfX5PWzOwVniyLShm0MP35/hCjfwu5P5r/G78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSzRYJ2f8L88qnGlTpU/TGCFJ9B1twH+YeS2ofFitZ/HRlEL5TVCdEYSXLexZJDGI
	 vYQMX2VctZ3bz2jgP4+nINi9AlQQammsYPYdIQlJ7XaElEHcfx1IXAeL0WR/lZhT3D
	 wWU0uIv9dyOSEf2xuxOj9WKxCHLs50ozy7g0wCt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 346/395] xfs: fix blockgc group quota scanning when usrquota isnt enforced
Date: Wed, 30 Sep 2026 17:30:08 +0200
Message-ID: <20260930152348.180483273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit f8f6382ff13109e19d0fc1d0224ff7d29641e56a upstream.

LOLLM noticed the copy-paste error here -- if user quotas aren't
enforced but we're near the group quota limit, we fail to set FLAG_GID
and hence we might not actually free any preallocations, causing
unnecessary EDQUOT.  Fix that.

Cc: stable@vger.kernel.org # v5.12
Fixes: c237dd7c709432 ("xfs: flush eof/cowblocks if we can't reserve quota for inode creation")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_icache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1650,7 +1650,7 @@ xfs_blockgc_free_dquots(
 		do_work = true;
 	}
 
-	if (XFS_IS_UQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
+	if (XFS_IS_GQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
 		icw.icw_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
 		icw.icw_flags |= XFS_ICWALK_FLAG_GID;
 		do_work = true;


