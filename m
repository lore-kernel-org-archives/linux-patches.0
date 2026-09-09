Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F8E5803BD;
	Wed,  9 Sep 2026 14:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962956; cv=none; b=RSpo1dMk0xMvDWIs8Ej3jnFSKAaVEeurObd1JEs0/2dqHSGCpn3YymIOLhHYReH3uf4f0j9xBJUJyHuYrFRpqReQGMQl2VJwJcXLllzPoQh5FiDyKO5DXX9eoYoo+vsQst9wM4mPkizesTa7rpvyqyReJqa8L3V7ksbiVpFZjhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962956; c=relaxed/simple;
	bh=wqa0bD3jL6x/C1fXrB6yze2IJGHGsGn0DPpjpgWvyvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0S/k92kGRsggQT7s8GT49W56USABDWsDeOGdddxCpTiiTuE4TASfyw45ihxFcofap+sbJTpuwH4ENUerjkpgunYHpZO+c6nzG1Aqbx/A0G6EeGIEzTklOWN+A7/bXKf/2Z/KZJh4G9hFJg8Ja4tTgzQdn9+Kp/gC4tYw5q0agk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJrd24Bb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJrd24Bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D041F00A3A;
	Wed,  9 Sep 2026 14:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962954;
	bh=4YPAmaRtEYcww6lobbMiPllRUvi44y+nAz7CXoFVvHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJrd24BbuO856oDSiRYRvffppkTvs4zc9poZbml4f7uRCinjA4Sb94ogVQ/scycEf
	 wFvg9kx2N2vCZz0kfWny00wkhHp2ufzM1y6Z1Dbw1Izb4LBvs29YH4ph6ct9YwErmc
	 Kep3lZa0Y+msH/mU5M5G1rLw8FCnDuLz38o53NGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 470/556] f2fs: fix to pass folio->index to f2fs_sanity_check_node_footer()
Date: Wed,  9 Sep 2026 15:42:30 +0200
Message-ID: <20260909134247.087409112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

commit 7e188e9f9437ab47c3237d609f1b26348d6fea1a upstream.

Otherwise in f2fs_sanity_check_node_footer(), it will check the
same nid incorrectly.

Cc: stable@kernel.org
Fixes: 0a736109c9d2 ("f2fs: fix to do sanity check on node footer in __write_node_folio()")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1790,7 +1790,7 @@ static bool __write_node_folio(struct fo
 	/* get old block addr of this node page */
 	nid = nid_of_node(folio);
 
-	if (f2fs_sanity_check_node_footer(sbi, folio, nid,
+	if (f2fs_sanity_check_node_footer(sbi, folio, folio->index,
 					NODE_TYPE_REGULAR, false)) {
 		fserror_report_metadata(sbi->sb, -EFSCORRUPTED, GFP_NOFS);
 		f2fs_stop_checkpoint(sbi, false, STOP_CP_REASON_CORRUPTED_NID);


