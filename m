Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A250B312825;
	Wed, 20 May 2026 17:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298495; cv=none; b=ZsoAptL7fYVDzxYEw1W4BR+T0eAsYBRYOSoBIabaq6lnLqLwjGeCQQ8DX0oL8b20SqofJ8fe5sVPWunDIsAusQNW8BY4hp4uhuGULZ2sCK5trsOptqLC36kx6M7/MBt3SsQ+kylj/997HGM/0d9zvzibDw5pp8rj4UT+pG4XMII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298495; c=relaxed/simple;
	bh=fDUvQAioR3SE99sbZdSGbU5v6hxzs0MoegRB/tkj+zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cq2RaVtbvHTxaIOnOFzGttLiyL/5xWCIOzKy7IqvheLI73K1OeI7OTqf76mjSOHkPqTeun+DWHxwCj9RriVoTwq69I5A8zyng5DmNNM1ShwY0rbIbduqkPxkiiHQOOXn5CCRAydFELSYJpJHnDqxkbmxbtqjUmMT9bGr+VEoNWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZI1avMrD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZI1avMrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142C91F000E9;
	Wed, 20 May 2026 17:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298494;
	bh=9zkzT8o2C0m5xKVvuRDsBdC/RJxktIxqOVVF1l3xDp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZI1avMrDNiQWMxSrZy+/zLaxHg0vC8V2jYrVGugB7P9EW1EPjI/Jh5V0hoeIeLo8W
	 DmroehrqtdF7yo8lv0y9GZYcBXdmGZmNkdbPfjLX6FhRb0IWZ7TRPRRNFyZqp4hoSL
	 HQB87u4zNL8haDRM0LVrQE+i9YiVnhlSmZ3/lbcE=
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
Subject: [PATCH 6.18 431/957] ocfs2/dlm: validate qr_numregions in dlm_match_regions()
Date: Wed, 20 May 2026 18:15:14 +0200
Message-ID: <20260520162143.867984237@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 2347a50f079b7..f159785a21116 100644
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



