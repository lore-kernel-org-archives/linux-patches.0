Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ED451EE08;
	Wed, 30 Sep 2026 18:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792674; cv=none; b=PUJo+S0OLqXds7hfLNW/g6y4Z1n7C29cCYCREypynMZ+Tpf7pUzGFh+s9lUbKpR5bbVXStiLDa19BlHQTL3SHS2/ldLVJIkzQiFVKUzVWAlWLs8zacAZG7PngeGpztZrFCgy1Xb9pf2eV2hBhDml1DvXHmC+bJtlhRWNhMIsyZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792674; c=relaxed/simple;
	bh=5iBMnnhmG+f0K3zpap6lV3lHU8hQtCab/2dJynpdcVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NooPi4YsBJ+FbnE30qhsTVm/BayDOHMn5BaY4cWkClhf2ofbfb//zYcKyZXpRBgqGTrkXPwr8CpxAfxqDAqsZZYNuAQ0be5A0dZx9nYTofZwl1X9/JT419hF3ao/kga+zy2926jhNDWa/zqKW9vFxEtpGkY9rHvSSc8SY4IWv1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkiyipKI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkiyipKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707991F000FF;
	Wed, 30 Sep 2026 18:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792673;
	bh=Mb6H6Am7SgYs2PiHIBQGF2vxVudlOWQQITY98qZZydY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lkiyipKICd/QWFUFfe8hWKRIoqD90DNoUdocPpTsXjgVUSxsHEVVVR1xdTjvco4E8
	 nF5/5a2svggI/bhn5hL8XLed2nbuhemfWHSV7wiTqzhwWb4qz7YVfJPfWegTkMfs8U
	 0z1WKWzhUetoxtMPYy1IYOSSgnjGqrgTA8jTYP+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.15 737/752] xfs: fix blockgc group quota scanning when usrquota isnt enforced
Date: Wed, 30 Sep 2026 17:30:07 +0200
Message-ID: <20260930152414.165080780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1560,7 +1560,7 @@ xfs_blockgc_free_dquots(
 		do_work = true;
 	}
 
-	if (XFS_IS_UQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
+	if (XFS_IS_GQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
 		icw.icw_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
 		icw.icw_flags |= XFS_ICWALK_FLAG_GID;
 		do_work = true;


