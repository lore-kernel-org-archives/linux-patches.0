Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102CF381AF1;
	Sat, 12 Sep 2026 19:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241356; cv=none; b=gqA/N1lYaojOnRhAwWP/uxPJDqljlXj/EETNhvTZixv38YClRP+irETI1MEKzhLmsGHrJW+7geP1PkCdt0qcMgCobp5DDHmJbBTbvD+trQgYOjBoruudrhIy60gewGYFMrMn4Qmz8aL5xVBCZp/6xiwzmnQm+JUenWBHjjy/3mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241356; c=relaxed/simple;
	bh=KJmfzQa5ph8yS2DTZWT+PK6aJ1AizvFwid0QP7j6kCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbVNU4YX2LhTu3DlKlrjVc6KV9OKqrdY9yXsCQLOle3K2OaasIYdnTk8EcHB2DypbBt0A17QEtu44UeswunjiDbBgS1sZ5DId+vQw9VCYvfyCV0J51UpsVngbbbqYZBXpcrbayF9n5B+m2p2WKr1K6PBZUoQwq2uqH6lp+Ct5OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABs26iv0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABs26iv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2921F000FF;
	Sat, 12 Sep 2026 19:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241354;
	bh=oVJKDTC6LK+nSDBBR22pkTBaYRhWqnLJ/BLKZCmiZnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ABs26iv05a0FND+/VZrNGCUA6aopYwivoGXNdX8K1jtAzdtiRDaeFkhdrTSh+1BcB
	 ZDOfgZL+0zpgKYEmyPPbb9K1gTevDO+7deAOYIvsO/UWRrWvNyPmA89msSGvDBxeRI
	 LQms3p0/dzY9lPXpniZ38umcUPKj0O8gcBKR/rLs=
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
Subject: [PATCH 5.10 120/798] ocfs2: cluster: fix o2hb_dependent_users leak on pin failure
Date: Sat, 12 Sep 2026 08:55:48 +0200
Message-ID: <20260912065519.726144927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2444,8 +2444,13 @@ static int o2hb_region_inc_user(const ch
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


