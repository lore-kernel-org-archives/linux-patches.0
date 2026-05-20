Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F243ED5C5;
	Wed, 20 May 2026 16:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296061; cv=none; b=LhMiPsxwziz3DHn6U1Yt+wfJUXkpqW7DyhC2ihyBLgfdWmxlR92Qx8FtBU0e+XN5AxWtTXxiOwJKLGI3XdyFzIwmJJnHZOwbIg2cl7FoCHHQmnDoSEFdIyeEqxD8kckR3qS79EKAc1nYNH9i7QIbRZVtfj/pHXLdBaMmHLeCu3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296061; c=relaxed/simple;
	bh=6oF9BCNS6lW0ceBGANrnwOSMxSLczm+PVWlCK01SztA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZR+9/x5o4yIelrhlTvRP2IwHUHj7auJJN76HbxhPwAz+KndKKnwZgh7CFR4cEXqZI0Ck7wtNAlkll20hoJewNYRtDNHTmQWj8y9CIDjUVxDmfJcuzSQwKWFk6/UZib3r/TGqBoNYOtQdMIqaES/ayEUYYxXogv9K+n+gieJhRck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vyr2FSFE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vyr2FSFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B401F000E9;
	Wed, 20 May 2026 16:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296060;
	bh=HGZF6AR+yP/5txBVNRk1CGpY8lVH34eFB5iKFCDcILo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vyr2FSFEvI5klK5Ii9bYo77yar6oXVSeiv9Zun4cinnUndMYTRwxaeh0Gb6t4My2A
	 5Jv56RqBrgwdX8Xd6ptpkrb+kWP8MEPRUAK0uoieeOsfp7K6ZyUFO/pSt97p2bYblz
	 EjZqCxqAd4nHaJhHTrme7TO6Z2IR20q1fuoOGK3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0657/1146] i3c: master: dw-i3c: Balance PM runtime usage count on probe failure
Date: Wed, 20 May 2026 18:15:07 +0200
Message-ID: <20260520162203.050929275@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 19d6dd322c3f05550606dbfcbafb5f6989975c02 ]

When DW_I3C_DISABLE_RUNTIME_PM_QUIRK is set, the probe function calls
pm_runtime_get_noresume() to prevent runtime suspend. However, if
i3c_master_register() fails, the error path does not balance this
call, leaving the usage count incremented.

Add pm_runtime_put_noidle() in the error cleanup path to properly
balance the usage count.

Fixes: fba0e56ee752 ("i3c: dw: Disable runtime PM on Agilex5 to avoid bus hang on IBI")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260321-dw-i3c-1-v1-1-821623aac7bb@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 3379cb16eeca5..b87073d2f8afa 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1667,6 +1667,8 @@ int dw_i3c_common_probe(struct dw_i3c_master *master,
 	return 0;
 
 err_disable_pm:
+	if (master->quirks & DW_I3C_DISABLE_RUNTIME_PM_QUIRK)
+		pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-- 
2.53.0



