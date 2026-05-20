Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7070B3D75C7;
	Wed, 20 May 2026 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297400; cv=none; b=m0hcOJHtpRhnMa6M84RJJR8FJtfMead+gy1DIKVDNkaAPeeQklT85nS6fxakVAQEAfKo2+qAp02rWNearZ6Pg4fgoUI/s4zoPZf5BF9XF+WMi6ZxOKuJ5iy3+KhzPJca97SIz9/m0qEgLpeLb+vsjIrxSlFKd8tK8CNUk8hEXpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297400; c=relaxed/simple;
	bh=5OqBMl6kq2bciBxLAezZDP8NoV5t0wf/trybgWayKGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4Us8znHZDTDI1SlSkWGwcG0Zh98FTUUf+XWidSttTUda9BshqhDyZ0YxgC278mY7AbCoQoXA1lrPApzXpRpRa14sn771CGFvLbxlzku+zM4tBeCqw95KJiJ7Bk44fuvQwSj3PXAL8ohY7hi0vmTRkKgfZFEUmgQ8faEryUoAjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0mYvDSL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0mYvDSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A701F000E9;
	Wed, 20 May 2026 17:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297399;
	bh=tOTbs0bvAryWBedXNHRrRh6SrdleT1EKZwddYm81l4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z0mYvDSL5cS2wjgkN/FWU8zJ9LdTHny7TWyzj98WPy7vadjL7WaAv9R10YPyrDB3l
	 0UutCU8u9GCbVhtcgZDyCSMKgih+TbQggA3vFDJ6EuxY5ol7G3tykoBEIFP92E7TXf
	 +sRxlznrs89cB3OM6vdv70BpnMragj3ZicV/Efgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/957] OPP: debugfs: Use performance level if available to distinguish between rates
Date: Wed, 20 May 2026 18:08:21 +0200
Message-ID: <20260520162134.956642880@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit e560083c0467f86b72aecac377b27bd1e7d16c49 ]

Some OPP tables have entries with same rate and different performance
level. For these entries, using only the rate as the debugfs directory name
causes below error:

debugfs: 'opp:5000000' already exists in 'soc@0-1c00000.pci'

Fix it by appending the performance level to the dir name if available.

Reported-by: Bjorn Andersson <andersson@kernel.org>
Closes: https://lore.kernel.org/linux-arm-msm/75lzykd37zdvrks5i2bb4zb2yzjtm25kv3hegmikndkbr772mz@w2ykff3ny45u/
Fixes: 05db35963eef ("OPP: Add support to find OPP for a set of keys")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/debugfs.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/opp/debugfs.c b/drivers/opp/debugfs.c
index 8fc6238b17284..61506d30d5ff0 100644
--- a/drivers/opp/debugfs.c
+++ b/drivers/opp/debugfs.c
@@ -130,22 +130,24 @@ void opp_debug_create_one(struct dev_pm_opp *opp, struct opp_table *opp_table)
 {
 	struct dentry *pdentry = opp_table->dentry;
 	struct dentry *d;
-	unsigned long id;
-	char name[25];	/* 20 chars for 64 bit value + 5 (opp:\0) */
+	char name[36];	/* "opp:"(4) + u64(20) + "-" (1) + u32(10) + NULL(1) */
 
 	/*
 	 * Get directory name for OPP.
 	 *
-	 * - Normally rate is unique to each OPP, use it to get unique opp-name.
+	 * - Normally rate is unique to each OPP, use it to get unique opp-name,
+	 *   together with performance level if available.
 	 * - For some devices rate isn't available or there are multiple, use
 	 *   index instead for them.
 	 */
-	if (likely(opp_table->clk_count == 1 && opp->rates[0]))
-		id = opp->rates[0];
-	else
-		id = _get_opp_count(opp_table);
-
-	snprintf(name, sizeof(name), "opp:%lu", id);
+	if (likely(opp_table->clk_count == 1 && opp->rates[0])) {
+		if (opp->level == OPP_LEVEL_UNSET)
+			snprintf(name, sizeof(name), "opp:%lu", opp->rates[0]);
+		else
+			snprintf(name, sizeof(name), "opp:%lu-%u", opp->rates[0], opp->level);
+	} else {
+		snprintf(name, sizeof(name), "opp:%u", _get_opp_count(opp_table));
+	}
 
 	/* Create per-opp directory */
 	d = debugfs_create_dir(name, pdentry);
-- 
2.53.0



