Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3A751815C;
	Wed, 30 Sep 2026 17:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788013; cv=none; b=JKaSbZVB4YD/FjAQFtJcY0nqt/L7kti2WtSB364ux6v1X43Ic0tIoSKxYRE+B4gdX9efHkPPSIQIiUqBOmZVbAH6mq7gIVJ+bVbq+u6ddFPNTf8F8dCztETr9G3KR8AYLxMQEm77VyGxZ4m2aYZGOJjeQZ3vNoB79eqJVU/V8Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788013; c=relaxed/simple;
	bh=vnT/E2Q4INYTBOkxRG0y0GEHVS6F/4G8RonmwgX89WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFnOQwWPpVNNNxbrsNDjvCaWB6g383RMQr8Gb3yaWZvK6uRGx2OT33ce9q3DnJNum0yZPmiD0pDbgqoRQGlf6Q+jBzbnuEhCiRbYk60WMA4unVE9rP4HuxJhMbrZR3m+IEVDIQmBMkvz+gSEPEpZnMQdaD+Hk1IIt6/uWEnXaOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AuxPLn8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AuxPLn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA231F000FF;
	Wed, 30 Sep 2026 17:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788012;
	bh=KIfHHSL4xVpvMBccDNWaMp4YI9nWFEwh21U8rzk7HqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0AuxPLn8w1o6kLf8ZwGmdbesTpWgoq0ttzIgLP9nWzRvPdCA6dcfUlgB66Bulnspu
	 t38h/EACudk5iiqjQZon25zF/iO9LvxnQLuKPwlHK0AWDFjW0JVc2MAwi0UhsyRLB9
	 oGSevE4Aw5VXSIWa1EgrbF9W7tZKA8Bck/out2iY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 432/457] xfs: fix blockgc group quota scanning when usrquota isnt enforced
Date: Wed, 30 Sep 2026 17:28:57 +0200
Message-ID: <20260930152355.314193346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1656,7 +1656,7 @@ xfs_blockgc_free_dquots(
 		do_work = true;
 	}
 
-	if (XFS_IS_UQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
+	if (XFS_IS_GQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
 		icw.icw_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
 		icw.icw_flags |= XFS_ICWALK_FLAG_GID;
 		do_work = true;


