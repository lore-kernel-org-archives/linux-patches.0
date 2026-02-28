Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65CC421A16
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301161; cv=none; b=sOLRygeLXqDw0I9CxlWfJgcWFMigZghqc+Sr5HRJwFq99sqODIa2o0InjOw/ya3ghDzzodhN0amAdXewPn9280wVXIvNWSEZeyZVkE7rAslvOKXqt30kexwnL0HmES57jDmRZYGEAxERfg3YMnqTYt4Gjz/AGtD++9Bc8Ei2rro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301161; c=relaxed/simple;
	bh=FIzBvFIdzrkXdwEgwPFJPoL4ik+LPGQBoPJ2yMLIVco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gy6G73LVu2eUAjrbXVmrqjsS8z157GZs6G6O7rmF0N4p7cljEmy02hbJOPotWrv/exDspHOmjGbtQsldU/6Wma46Bq1DYvXBJsqxsi9AQVCE2YlsRPNU2xn1wQxKoIWQxns5OqXfDtG3InyRXsCD9nFl1Zz75ngSqx56oWdKDdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bxUCtC98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bxUCtC98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1294AC116D0;
	Sat, 28 Feb 2026 17:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301161;
	bh=FIzBvFIdzrkXdwEgwPFJPoL4ik+LPGQBoPJ2yMLIVco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxUCtC98W+OuOdjYaQzBFqeLOZ3blwSg7HKbWz6S/dgnAIICbS9gvRXfMUyjPirAH
	 zR96eB0nAZLF7oGC/KKtfzoff40CsVihfYqbZIN6ksN6Jpv59tzItdYbCGfVg/SHt9
	 P2dRoUDClbD5m69QS+fh/HjvI+59mK7+k9IRlrG6CcpjEyYdTnaAxgv+Bi26+JaBrj
	 wqzTXXQI7+2ElY3iAL7iM4LZBa+Q02nUMoWNbZ/su8Ucquizm7NmIcXxpFPuS5ly7f
	 Weim809QVQ7oefDTkQVW3DbaEk0LuO9OEdysFhPZKzr7jArRSAnHS+sgYenPt5VVpv
	 YTmI2y0l4vfyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Liang Jie <liangjie@lixiang.com>,
	fanggeng <fanggeng@lixiang.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 326/752] staging: rtl8723bs: fix missing status update on sdio_alloc_irq() failure
Date: Sat, 28 Feb 2026 12:40:37 -0500
Message-ID: <20260228174750.1542406-326-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Liang Jie <liangjie@lixiang.com>

[ Upstream commit 618b4aec12faabc7579a6b0df046842d798a4c7c ]

The return value of sdio_alloc_irq() was not stored in status.
If sdio_alloc_irq() fails after rtw_drv_register_netdev() succeeds,
status remains _SUCCESS and the error path skips resource cleanup,
while rtw_drv_init() still returns success.

Store the return value of sdio_alloc_irq() in status and reuse the
existing error handling which relies on status.

Reviewed-by: fanggeng <fanggeng@lixiang.com>
Signed-off-by: Liang Jie <liangjie@lixiang.com>
Link: https://patch.msgid.link/20251208092730.262499-1-buaajxlj@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index f3caaa857c864..139ace51486d2 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -377,7 +377,8 @@ static int rtw_drv_init(
 	if (status != _SUCCESS)
 		goto free_if1;
 
-	if (sdio_alloc_irq(dvobj) != _SUCCESS)
+	status = sdio_alloc_irq(dvobj);
+	if (status != _SUCCESS)
 		goto free_if1;
 
 	status = _SUCCESS;
-- 
2.51.0

