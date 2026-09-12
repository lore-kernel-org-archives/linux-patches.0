Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E49D47C107;
	Sat, 12 Sep 2026 16:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229215; cv=none; b=HUjRIH6jUBL0BzOVowJ3uiorNhL1WNvzr0gEy9rRDNUhMJbMzB3RbseUDda4uwnsE7P0TuYCdT0R8uZzUcetIAV7q7IepiFpLu5m3BNio5RvK39tb4GbRt3XOwIeurzd03JxF+tGx6uBoJs10iOpg1jYp/jxoJ4bwbqzT3ZSQsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229215; c=relaxed/simple;
	bh=Ck6B+b/DnLThlLZ/HVtc2HHFlQ7TSpsKIyHys6qedds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKykScaVkfAuA66WzLfb74bfPqAyPVsgyxrA4gAlX4owuwD/Mi2dmmxgHvd77+Cp0fnaW7og0vdmsCkbgIlWn4+08C9IF5Ea9QYJbPIKX0pw0/APUDPYTZvEBPchuuhnYla16OkhavrlwsAwwdMdFn4pmRZq2d0/eBt6wG2rPpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6eDpvLA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6eDpvLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C341F00898;
	Sat, 12 Sep 2026 16:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229211;
	bh=+kE5NLIcGGGjj3bx9Aj3AexRagKn3nC6xnk47QEVUoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6eDpvLAMcOdFxe53n84fPQ30awG86GTfPWq7U8NkBOMa8PGVhdfTwsTrgJKGzHJ2
	 zJvGJNY90hka5znolf7oJ24+h2u5nxcl9vv6sVYXvuKsqG8Ueso+GqhtHM+RvlgHX+
	 fV2iIKEfmojDVLJTvN6KtpQurDsIi9x03sViBQns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0543/1191] staging: rtl8723bs: fix mismatched free of HalData in rtw_sdio_if1_init()
Date: Sat, 12 Sep 2026 08:54:31 +0200
Message-ID: <20260912065600.443355372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 335e6002df70f..3b5a6f685bce5 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -310,8 +310,8 @@ static struct adapter *rtw_sdio_if1_init(struct dvobj_priv *dvobj, const struct
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



