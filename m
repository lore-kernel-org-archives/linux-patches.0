Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717A736A36A;
	Sat, 12 Sep 2026 09:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206784; cv=none; b=lXnyVcTX/wkqKwr+cuEqQ8SOgMYoClzCHnswToYzAX9FL7IaoTLelEryJoyLxQIX3r8hq4S5Ngyk23s1XqsRje+JmRzLS2Pqu9lN9ioxctfKjk/rCO0lSRUS0ojekt75RJJoysmxoTm4MRW7uZA47rP3IMgQyTBXtCrNSnL1atE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206784; c=relaxed/simple;
	bh=xDv9un8d7l2N6sFCfLZKBgK0fUBGPA9SPBcCuryrDrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrk5pXWYTPhrmj4d4J6cBoxLvfL4wozIxLbJPVZEruhGvFkq+SMYlfj6TMKquSoebL3nSG+6/194rjiLp8uCKx5P4gflgcODbdyt+T6PvI6e89ZycUI8fhLu8RAfHMir3iXsoG6wqI52CjhXNEfMXEupLMXR/53yRZEpldHG7Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IB6MLZF7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IB6MLZF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9621F000FF;
	Sat, 12 Sep 2026 09:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206783;
	bh=+Gbdoc2h0YTSqfkljUSRJnS8yqwDNu8FfSi9rhP8B7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IB6MLZF7/QZawtkZAVwIErAx23rMQBg2gsv3qYgI+BLwFI5X/bC/SiKBlq7ra+dag
	 U9+zHnLOwZemHytSJcDmSZwhlIkPoFh+6HNDECNCc86mz590Qr3s2dotYwsultfWZu
	 KnwSVMv6UJYWx0CBBg1iGwQdvA/OXpO2Pm7Q5pkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0235/1518] staging: rtl8723bs: fix mismatched free of HalData in rtw_sdio_if1_init()
Date: Sat, 12 Sep 2026 08:40:04 +0200
Message-ID: <20260912065628.801012752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

[ Upstream commit 264676418b726baca7be49171e306b6aa05cceb0 ]

padapter->HalData is allocated via vzalloc(), but incorrectly freed
using kfree() in the rtw_sdio_if1_init() error path. Using kfree() to
release this vmalloc-backed buffer can lead to memory corruption.

Use rtw_hal_data_deinit() to pair the free correctly and free
HalData with vfree().

The bug was first flagged by an experimental static analysis tool we
are developing for kernel memory-management bugs. Manual inspection
confirms that the issue is still present in current mainline.

An x86_64 allyesconfig build showed no new warnings. As we do not have
suitable RTL8723BS SDIO hardware to test with, no runtime testing was
able to be performed.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/20260525091836.812565-1-dawei.feng@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index 139ace51486d2..ae379e99736ad 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -307,8 +307,8 @@ static struct adapter *rtw_sdio_if1_init(struct dvobj_priv *dvobj, const struct
 	status = _SUCCESS;
 
 free_hal_data:
-	if (status != _SUCCESS && padapter->HalData)
-		kfree(padapter->HalData);
+	if (status != _SUCCESS)
+		rtw_hal_data_deinit(padapter);
 
 	if (status != _SUCCESS) {
 		rtw_wdev_unregister(padapter->rtw_wdev);
-- 
2.53.0



