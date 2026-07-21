Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC1C3E0C55;
	Tue, 21 Jul 2026 17:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653722; cv=none; b=jqAmB3d1HxxMXg/BLWFov/mHClLzfK9oWXhk8MfZwYskuwZZZ9m9PJkMcotVXLDgR2HGXP4+CDu224N04LLRhID1/VIU7h023urvyr2CVC/CDn/1uvimrD+0c6ncWGEbTWkxSFyK/G/lab/abue2bEfKA2zhKOyO85hmdJb1OTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653722; c=relaxed/simple;
	bh=6UHP+vJU2oZtoSp5FCXhfHkPAoqrVdCMjQlVVhRc+qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MS7zKzZ1DcLIghZ2706/+6/7RapaxRAlP/uso7v84Xn+4Rl1qOekOLIATi+FJD84LDeYVAScXByS3sB4Z9BnvdMA0Fgwta/+paZiemQx7cTmHzgwfh7Qq1iO/zFIJLhK09w4WERPPTrci2WxTm/3Kaob6+ToXFfQrQfkFcolPmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfEA8wvT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfEA8wvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C087C1F00A3A;
	Tue, 21 Jul 2026 17:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653721;
	bh=3R78Rs8560uIpgR3QKMXmIs+bAi80HIGQ3EfxTBFcVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfEA8wvTNS4MbVV8WX2R9KyVxu8iijaRtAE4mqudH1t+23QSIXIp/0d8E/eHP4+QT
	 zOpcCNt/EcRHQ/bCvgfDrpinm2ZaaGpJtSG/18j3wFa+iz2yaacF/MFFMtSptPOvFn
	 ghZAURha3urnBHki9oJOHT2s3QEKN9CW7OtEXqa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Li RongQing <lirongqing@baidu.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1381/2077] afs: Use scoped_seqlock_read() rather than manually doing seqlock stuff
Date: Tue, 21 Jul 2026 17:17:34 +0200
Message-ID: <20260721152625.388700882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 3b1601471a88f86082fc1f1c2475645cdf59f7d8 ]

This is an addendum to the patch to remove the erroneous seq |= 1 in volume
lookup loop.

Switch to using scoped_seqlock_read() as suggested by Oleg Nesterov[1].

Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/aifaeKvz3KemfzaS@redhat.com/ [1]
Link: https://patch.msgid.link/20260622090856.2746629-15-dhowells@redhat.com
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Li RongQing <lirongqing@baidu.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: d672c276f685 ("afs: Fix leak of ungot volume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/callback.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/afs/callback.c b/fs/afs/callback.c
index 0a09a9ca3c6b37..74853e0d0435ae 100644
--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -113,16 +113,12 @@ static struct afs_volume *afs_lookup_volume_rcu(struct afs_cell *cell,
 {
 	struct afs_volume *volume = NULL;
 	struct rb_node *p;
-	int seq = 1;
 
-	for (;;) {
+	scoped_seqlock_read(&cell->volume_lock, ss_lock) {
 		/* Unfortunately, rbtree walking doesn't give reliable results
 		 * under just the RCU read lock, so we have to check for
 		 * changes.
 		 */
-		seq++; /* 2 on the 1st/lockless path, otherwise odd */
-		read_seqbegin_or_lock(&cell->volume_lock, &seq);
-
 		p = rcu_dereference_raw(cell->volumes.rb_node);
 		while (p) {
 			volume = rb_entry(p, struct afs_volume, cell_node);
@@ -138,11 +134,8 @@ static struct afs_volume *afs_lookup_volume_rcu(struct afs_cell *cell,
 
 		if (volume && afs_try_get_volume(volume, afs_volume_trace_get_callback))
 			break;
-		if (!need_seqretry(&cell->volume_lock, seq))
-			break;
 	}
 
-	done_seqretry(&cell->volume_lock, seq);
 	return volume;
 }
 
-- 
2.53.0



