Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B98F3876B3;
	Fri,  4 Sep 2026 05:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501250; cv=none; b=GrHqIli3kkVMRUuWopgDVAsZznjP7Qlo/kBo8T2QNlUMw4cjc+GmQJApJ/JTuh7kj0bUmNFRgpPSRDulT+vxY1hdfXkjvNIMF9/oGatXcy3ScR2Cq2DU8ofllQL3WuLxUw0yx48h3aEJS9UTj67teiuBv+7queNQ0D4Tc3vpYqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501250; c=relaxed/simple;
	bh=TItCGaj4Ao7LtugVK+JMbTOlVP9rHdf2g7lFgGZVEQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmU/2txsL4nHO8YTkMsb4r3jeXyGwY/8ZowMvqtOvu7rRxFkJ6+6WWAvx6S/1S5Gik26vCNFPXs8LYiGVFc7n4MbdWI1QlvW+nVpq4lEnX4Rp7kQ/qA2g2dpg9aghiUPuCQVj3xupRNaGTA1jVz0rQ1+10k5wcWAvtj32CuMLiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2byKT3HU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2byKT3HU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C2E1F00A3E;
	Fri,  4 Sep 2026 05:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501248;
	bh=/wuUGVQUOocCKrzZBK+qrmzGv+cpDDJuwC5v+ulJ4vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2byKT3HU8c6Vo3MoYpz3vtA7RiNB0vj7rqx8OlDMSaVSP85Qla10acuK7iyfGPpal
	 FKD0OScHa23BHw0/vjBmLBAYbCuxTtavnXJYSxtZWQk3ouio2y3CxQiyWQkdvioiP9
	 YYM4IqiyeazjpFXEVA5uWasCqYGv7WiMcbaS6EL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 341/552] ocfs2: cluster: fix o2hb_dependent_users leak on pin failure
Date: Fri,  4 Sep 2026 06:58:18 +0200
Message-ID: <20260904045757.987439624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 12c2ab42dbe227956c765e2674364bfca5de0533 upstream.

In o2hb_region_inc_user(), o2hb_dependent_users is incremented
unconditionally before calling o2hb_region_pin().  If the pin fails, the
counter is never decremented and any partially-pinned regions are never
unpinned, since the caller does not call o2hb_region_dec_user() on error.

The leaked counter causes subsequent o2hb_region_inc_user() calls to skip
pinning entirely (the > 1 check), leaving heartbeat regions unprotected.

Fix by rolling back on failure: call o2hb_region_unpin(NULL) to release
any partially-pinned regions and decrement o2hb_dependent_users to restore
the pre-increment state.

Link: https://lore.kernel.org/20260722124933.430554-4-joseph.qi@linux.alibaba.com
Fixes: 58a3158a5d17 ("ocfs2/cluster: Pin/unpin o2hb regions")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/cluster/heartbeat.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -2442,8 +2442,13 @@ static int o2hb_region_inc_user(const ch
 		goto unlock;
 
 	if (bitmap_weight(o2hb_quorum_region_bitmap,
-			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
+			  O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF) {
 		ret = o2hb_region_pin(NULL, false);
+		if (ret) {
+			o2hb_region_unpin(NULL);
+			o2hb_dependent_users--;
+		}
+	}
 
 unlock:
 	spin_unlock(&o2hb_live_lock);


