Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502793AFD11;
	Sat, 30 May 2026 18:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164328; cv=none; b=Lskn6HG4yV5Qpxi9O6c4qUIe+Aywhw2845hilosGG5vVvZbnLmBbZb+HF8SoTllBW5V1r/53btU3c2iyTn6yHivD66JsWALfPw903QLIDYCcVx6wlMTASCePme6cZ73B/Ab4bZchiVtwmXC1ABrpV4f+mwK2e6/qUIsGHey9VPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164328; c=relaxed/simple;
	bh=8zW7UQqwcq4o9TD1SD2lhotY9FN8vOtB0zZSyk7iBMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEH75eZJ3S0xErY5cHiIIZCzmS6QTCeMuyCyZhBdim/NyEYAYw08tApSk7HpKYJ4vDjoTWkeQ5qH+ORVTtduASPWB4qYPQ1UZkw58C3/V2Xrzm+UUddS4Wc0Reoh8VQP1fe+oEBQm3Z7PtTUN5xafQzNS/NWVQyMOC8acCDOPig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ei0OqPss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ei0OqPss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5893B1F00893;
	Sat, 30 May 2026 18:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164327;
	bh=qdV9HE7Q9xocy1NkrRBFBfeBVOi9feDvDlWXm5ScYaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ei0OqPssEslDzoawVy9ohKxNG2JU6uCbxeEyh6C6uOO6dbhb8S+WBfRc/rBF6O5G8
	 D90N7XigoMc/wSXVCotxwIDuuJHY75GwPuFh3Km2n+friOBH1CP4bKQNr9lL2Hcux3
	 vo8O9IOK+cN5gN2EO9dHUKwcFGbKj5Fdk0NAVZZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Yuhao Jiang <danisjiang@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 494/776] ocfs2/dlm: validate qr_numregions in dlm_match_regions()
Date: Sat, 30 May 2026 18:03:28 +0200
Message-ID: <20260530160253.075180503@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 7ab3fbb01bc6d79091bc375e5235d360cd9b78be ]

Patch series "ocfs2/dlm: fix two bugs in dlm_match_regions()".

In dlm_match_regions(), the qr_numregions field from a DLM_QUERY_REGION
network message is used to drive loops over the qr_regions buffer without
sufficient validation.  This series fixes two issues:

- Patch 1 adds a bounds check to reject messages where qr_numregions
  exceeds O2NM_MAX_REGIONS. The o2net layer only validates message
  byte length; it does not constrain field values, so a crafted message
  can set qr_numregions up to 255 and trigger out-of-bounds reads past
  the 1024-byte qr_regions buffer.

- Patch 2 fixes an off-by-one in the local-vs-remote comparison loop,
  which uses '<=' instead of '<', reading one entry past the valid range
  even when qr_numregions is within bounds.

This patch (of 2):

The qr_numregions field from a DLM_QUERY_REGION network message is used
directly as loop bounds in dlm_match_regions() without checking against
O2NM_MAX_REGIONS.  Since qr_regions is sized for at most O2NM_MAX_REGIONS
(32) entries, a crafted message with qr_numregions > 32 causes
out-of-bounds reads past the qr_regions buffer.

Add a bounds check for qr_numregions before entering the loops.

Link: https://lkml.kernel.org/r/SYBPR01MB7881A334D02ACEE5E0645801AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com
Link: https://lkml.kernel.org/r/SYBPR01MB788166F524AD04E262E174BEAF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com
Fixes: ea2034416b54 ("ocfs2/dlm: Add message DLM_QUERY_REGION")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlm/dlmdomain.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 9f90fc9551e1a..5a4b0f7293fa2 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -980,6 +980,14 @@ static int dlm_match_regions(struct dlm_ctxt *dlm,
 		goto bail;
 	}
 
+	if (qr->qr_numregions > O2NM_MAX_REGIONS) {
+		mlog(ML_ERROR, "Domain %s: Joining node %d has invalid "
+		     "number of heartbeat regions %u\n",
+		     qr->qr_domain, qr->qr_node, qr->qr_numregions);
+		status = -EINVAL;
+		goto bail;
+	}
+
 	r = remote;
 	for (i = 0; i < qr->qr_numregions; ++i) {
 		mlog(0, "Region %.*s\n", O2HB_MAX_REGION_NAME_LEN, r);
-- 
2.53.0



