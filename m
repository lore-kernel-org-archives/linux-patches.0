Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47C433D4E9;
	Wed, 30 Sep 2026 16:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786779; cv=none; b=KtlJkZ0Oqpp85Hz8ZLIpgeDOOaZKcRrn2HDu94kuSVJl7YAdqFfBztIRxJKwXB//kKzObfXnL7//EYlPvXMtOowRBbnHOy86PQg0FEK6jX2tsAtbAznQqmXKrREGBevd90y2vsRe1YwMRSIbBqoPZBTowTVN2GeTqM6OmRG+NoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786779; c=relaxed/simple;
	bh=/ORbid/pX/eVZ6XrqNW09CM+dOwGrJ5mNb0bBh2vRi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RudefNtRyTKTnlDC8cnTZkAqGdlX9QIg/HCic8MtU085ZHlonmcdf+ADGJ/4F6LakfgKp6a1QRskOkX7UstyhUQFEaZ8KWXvbqoxPoV9WU60zE3kkM7ZfuYjbRXkqJE7VAFNnXV5DIoaPqOWkPZW8U1As/+JM1FmoE7u5hQAMe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTNuKmJ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTNuKmJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B611F000FF;
	Wed, 30 Sep 2026 16:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786778;
	bh=azyRJJciPKSI/LTR4pjTjTWEZ7UteXKjEHPgGq2jgYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GTNuKmJ3bc/E82mSuEyOz0yoYUh6rjt7Yg9QpkNMB3VKXieuuxFlBV+4q5yKqm+nZ
	 JD51Z/XEfuB8ZIK4kNyacM0FvH/1lIGMbYg/n88AfwoLBgUBA+tSS7kZXzcPjAPu4Z
	 /koIe6X4Gl+BAyWi9lKfVOEMkQnukGBUHML125R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 975/982] xfs: fix blockgc group quota scanning when usrquota isnt enforced
Date: Wed, 30 Sep 2026 17:28:31 +0200
Message-ID: <20260930152437.685855010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
@@ -1578,7 +1578,7 @@ xfs_blockgc_free_dquots(
 		do_work = true;
 	}
 
-	if (XFS_IS_UQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
+	if (XFS_IS_GQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
 		icw.icw_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
 		icw.icw_flags |= XFS_ICWALK_FLAG_GID;
 		do_work = true;


