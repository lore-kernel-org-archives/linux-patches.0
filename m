Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEFD4BEE20;
	Sat, 12 Sep 2026 14:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222832; cv=none; b=bzRRJElaRqpeZ0IRHrcUu3DiK1DbVUzhH5m5/DW3vVJGhF6mopIeje/Ta44txUcSP9/uYxQBwl11QI7KdTTvFLvZU4LoPIh6jwFt8MkPKN6JOnsAKJwoldgA5PUnKVy1tpLIG6JpNcNBESfqI9meBKuS+lQPfOzWfxQQrYJNvvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222832; c=relaxed/simple;
	bh=2KFZdjNCseK0pjo2AIZPtuOG0V4ygOIHiEoq0ep64U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVRqGl35+HWRteHjCDaXNQ8J7Dtbq03N1dhykmlytYDKuoI+gQJCPXR3D3wV2Ih0SznUXwOtyO1M2nQ3QP0qZgHvfD2R1wYOAjGoitEw7zLmjV8fLwMm+rSAvi6k1qToIZh4RyRN31TxxdBt8M1SRVlNkKWzNTF/7fyyM6YOndc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ssTq+6nx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ssTq+6nx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA8F1F000FF;
	Sat, 12 Sep 2026 14:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222831;
	bh=8/+AGxfBpUfzQkwmDa9M7iB41sq72RUG4lkbW0zt440=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssTq+6nxaeXGiLBevmG8h/akTwIvrJ1YDNwdvG/gSJY6sYFPFJdD0jvJDk/3D5rEI
	 4BpAAIkm227Ib19iNabGV3G3MD/alLgHAksOTaJbG0dqMWkbNkPaAxGEoPJRHFnfFU
	 YIjTzzn0vzQ0CPNuRftfC58VXlQgr/unZ67RUPwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0665/1424] staging: rtl8723bs: fix mismatched free of HalData in rtw_sdio_if1_init()
Date: Sat, 12 Sep 2026 08:51:37 +0200
Message-ID: <20260912065622.185590674@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



