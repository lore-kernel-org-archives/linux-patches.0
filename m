Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B80D3A6B6D;
	Wed, 20 May 2026 18:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300784; cv=none; b=YEXE8xKpyOgrePM+XdCX/byVH8+MKMt90AZc0R/0eRVCKBc9NGaYtyU4tTd51f1v0VdUzxkBRKLSbHjvNDkY/boTv2G8WW3lH8rMSPRspt9oFo3Mp8TW6iQL/YeFZQboz6LYiawXjMcuWhyeJafalxLputS4ggOyBwegurEUKWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300784; c=relaxed/simple;
	bh=cESjLOv/kLVsMGpSi9dTeBQc+9zqeTG65/wKdzI0CLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sn9rvm2XvEu25XkpE//irX8i5q8765D1P4yG8aVudCRn1LzUG0qmelboKcV+nmlMkiFVQCftrI78oUqDYm7hiq9I6eGuTuSUlhWGGoxO/YUf0sqfHaqEP1kOemP9ujL5D5amSLe0NAPTJNGS2SDDGn8+WaaT+9HEyOfAIMmVjCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CO1pnD7X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CO1pnD7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8851C1F000E9;
	Wed, 20 May 2026 18:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300783;
	bh=84SVOeuB5q3FC5N0Z38GOKOZZHtcY2IxhSRR/Jo9d2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CO1pnD7XmYm1P0puXK0piFhOIpsHkTko2FI48LAtuB6YBOtl+wgwOBReYNMpV8Dlo
	 WfjhyP16hXzKQYDOfrmlQZ+nMLt8EVVO7/czy3W99jWHYeiaK+JbVEFsq11X0RYccK
	 WKMY02GyzrVrlUj80uzjI+ReDXPDi7g0L5vZTFhg=
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
Subject: [PATCH 6.12 307/666] ocfs2/dlm: validate qr_numregions in dlm_match_regions()
Date: Wed, 20 May 2026 18:18:38 +0200
Message-ID: <20260520162117.875293098@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2018501b22493..ad335fa6c188d 100644
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



