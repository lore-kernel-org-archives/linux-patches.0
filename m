Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7DE351C04;
	Fri,  4 Sep 2026 05:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499580; cv=none; b=ZQXqXGfH8h9MdEKx/PCegHmvmDhsIAhswnlYJrx6NKdtoavWMjje1nBQ2CdiBHo5sLbA454HZOCq/ch0c6w74ywDHuzs1bOTWLhisQymCHCvs/B3FvBXHXAf0V0vW3Ic4lOG0GoBS1vM08Q/7R68E4bacG6iswXOvg2R4Cc7bhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499580; c=relaxed/simple;
	bh=OFLGCJaqJrNgzNMCDrqtdLRVMmPLufjQbCEzERWTG6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzc/gGeQqEWiCG90GdYsanJcP04PfHHP0rhbATw7AZjy1tw6XDujZ+oAtuK6PMRHGS6U9jxJlHhTWtypdgW7HROEMK/wnnrPIQgkwF6oGQo1pfPG95fxsC6EDgHCOJplPqp7yALxFTt5j2QaVF1+/vrppPY0KZZtc2CbTpUVyDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J97EuM3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J97EuM3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D18C1F00A3D;
	Fri,  4 Sep 2026 05:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499578;
	bh=mzpbX1sDn4se9Uwh3NnlboOmBcrx67iRUQQokHtxQRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J97EuM3puP4PvhQ2Tbgq/JQ5Vnk2Pz7Ac9+gKIsycPem0++xEZ/HRxZNXiml9zRBV
	 VpLQjps6d5o0V0pmMnElSrDPuHpwcTR8EuJ5+g9waU5JFZTGlVFFyCqtsSen5XDrXP
	 fwHQ9aqfiRImlvhLq50xmtjOo/leALm47eQAj6F4=
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
Subject: [PATCH 7.2 467/713] ocfs2: cluster: fix o2hb_dependent_users leak on pin failure
Date: Fri,  4 Sep 2026 06:57:15 +0200
Message-ID: <20260904045814.290760410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -2469,8 +2469,13 @@ static int o2hb_region_inc_user(const ch
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


