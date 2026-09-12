Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D961EB5FD;
	Sat, 12 Sep 2026 07:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197726; cv=none; b=lNyAvBfWp6Z9aoxXFGBXN1ebFHEHV/lcOBenCSzOwsqxuMclz7TVgpnHLeJE3axG/8QNFc37KRiH5nbzghylr5ypYL4ferMpkLS+Nj9Qg63hruzQJzwb0aXGmTuVRGmgGcs7WKWwIHhMC6Wmefz6BjS5ycdkuVkEfnhFcRPHsWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197726; c=relaxed/simple;
	bh=JmZmdyDPWRGMS//uflBPDvCyuMH98dfNlMZvkLFg8Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVCC0/Rc1oGE8Kbqjr21NIfFaSHcs7gZFPQId/5bnY0XqWwYuuZZC1W7NDSxrjj753Zp8pdEVrdXjXw9jakSYWzEbeCxWtGLwMOM4lETb+yOkydwd34ug5DDrUiQ7PQzlG0ODu6P+r0yop6Mql4lOSP3ocvp5RGRtwXwYhm4/j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kw1HHzo4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kw1HHzo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9642D1F000FF;
	Sat, 12 Sep 2026 07:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197724;
	bh=f01tca4Jyp0koZ16D0mI1szExudOOmBrOJ9eSPRXqPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kw1HHzo43Wdk1j4ZJgJJ4c0yFHeQwJFKUYsex9PIdFanZEsl/sLHrB0Qgat6XWmMM
	 IJ6GUReMfQ0Ye8CxcpFZWQq7qcbdO/naqVh9z8940V3+2butGadDUBH5rtn0HERNyQ
	 xQkvRylPqkNpC81WpvPMqE8t79JkjZHV4Zm0Anb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0235/1815] staging: rtl8723bs: fix mismatched free of HalData in rtw_sdio_if1_init()
Date: Sat, 12 Sep 2026 08:33:05 +0200
Message-ID: <20260912065654.509329558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index c43a0391a5ca7..ee4a9c66aceed 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -285,8 +285,8 @@ static struct adapter *rtw_sdio_if1_init(struct dvobj_priv *dvobj, const struct
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



