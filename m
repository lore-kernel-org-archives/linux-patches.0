Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1463D36405A;
	Wed, 20 May 2026 17:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298498; cv=none; b=suVEDJQq0LtjB23/610CTo57pa1rJAiUqvaAvh6AW/Fnt0I5GM/G7CuHy8VipmU9FzY9taS4hzYJUUDECkPVVliHYGjWFNAIfJurlCG8BtwOA8IX1bH6fTBg0H58vm5ZTCJHm8wr5YxNPgu+6k3mu/SPI7qz8CqOV6kg7OSqCSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298498; c=relaxed/simple;
	bh=z+Mib6AuvYl+rwe9awEVF/TjgEJ6o/ZEjeooucbRckU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKXaUzG/sG62cXLqn1TrfSJQzjvC04Bkr/jsporlq2GLM2AIgC+a+rQMsrs2z/ND8AuFOvSJ/irNzECjEbD0kXwkl2wvbQGkyzI+qpXPm4dRWzX2zJ1bdDDldH/TY5rZQV2CfK8ZGj81zhA7ZH+YBMBBL/EsrWCeMUyCrA3F/xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrX2eArG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrX2eArG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819921F000E9;
	Wed, 20 May 2026 17:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298497;
	bh=iVHVB0mGx4rUHiiyGUxhCd/YAd6kxZYjbGuAzCbLZDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nrX2eArGO7pQcWQRScxu0ceJOE1usS8xTvfQXRG+M3GNDS5aPLKeKQpmwLfIlC/Y1
	 +NB9A7OLgKT5iexE8siKWmszfz9myuoMJkrlu9qKgQjSOGEuPgJrvFgumOz89jgaJ1
	 9kYUmejImVux2aoxax4F2d/JQchZ+807S9Z5Cek0=
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
Subject: [PATCH 6.18 432/957] ocfs2/dlm: fix off-by-one in dlm_match_regions() region comparison
Date: Wed, 20 May 2026 18:15:15 +0200
Message-ID: <20260520162143.890535004@linuxfoundation.org>
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

[ Upstream commit 01b61e8dda9b0fdb0d4cda43de25f4e390554d7b ]

The local-vs-remote region comparison loop uses '<=' instead of '<',
causing it to read one entry past the valid range of qr_regions.  The
other loops in the same function correctly use '<'.

Fix the loop condition to use '<' for consistency and correctness.

Link: https://lkml.kernel.org/r/SYBPR01MB78813DA26B50EC5E01F00566AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com
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
 fs/ocfs2/dlm/dlmdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index f159785a21116..09bee7b86815e 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1002,7 +1002,7 @@ static int dlm_match_regions(struct dlm_ctxt *dlm,
 	for (i = 0; i < localnr; ++i) {
 		foundit = 0;
 		r = remote;
-		for (j = 0; j <= qr->qr_numregions; ++j) {
+		for (j = 0; j < qr->qr_numregions; ++j) {
 			if (!memcmp(l, r, O2HB_MAX_REGION_NAME_LEN)) {
 				foundit = 1;
 				break;
-- 
2.53.0



