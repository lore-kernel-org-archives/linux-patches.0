Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7C32DFF1B;
	Tue, 17 Jun 2025 16:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178347; cv=none; b=D604CVv05/l7kxStqgaLSfWnWk0TMtxd7havxmeuOs/1QWnvKsEy9rzUBIh/5Ej62BIiFH8ucC4HkSH/ArB7zGZALAX0lWP7sz/ghCO6YlCUGMtJ8E4h3XglOn5ymaNkqj1Jch46uamvduxekIwIiYuQTGnwLXpiauOil+S9Rwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178347; c=relaxed/simple;
	bh=s+Bvk112ZRmZ41FdVwY81mWQFnWDWyqIjeBqahuy3rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiaF2JXP7usUxfUKwumBJOWTBsJLT2Pss6Xf2saenaVXT9pvRd2BtC9Y0ppIwDax5eqEaKygSgVNVcQCoyqjJQymQhTvi8OMcvt22KWjUGJjweHBbwmi8z4J6on3mYgLAieBBZa4YtvJE6le9UOSFC/S9XUY+5wcsGUhkJGIWtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ww/K6Ts8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ww/K6Ts8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1775C4CEE3;
	Tue, 17 Jun 2025 16:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178347;
	bh=s+Bvk112ZRmZ41FdVwY81mWQFnWDWyqIjeBqahuy3rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ww/K6Ts8SxGcEGNvckY/y9nmdPdGFt62LYAZ/SZJ7LQwosehK5YztOW7SXjDngxB3
	 74tXgGlJ3cs0TzilpTIe5AXKzGz3BgTHzdeWHQ9rLS5Dpiw7EHRQ0A909VaqA2sCUb
	 fsAWvn1qcCkjip0AGjBxZ9rfsw9nCsD9DdLHEhac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 447/780] remoteproc: qcom_wcnss_iris: Add missing put_device() on error in probe
Date: Tue, 17 Jun 2025 17:22:35 +0200
Message-ID: <20250617152509.657281657@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 0cb4b1b97041d8a1f773425208ded253c1cb5869 ]

The device_del() call matches with the device_add() but we also need
to call put_device() to trigger the qcom_iris_release().

Fixes: 1fcef985c8bd ("remoteproc: qcom: wcnss: Fix race with iris probe")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/4604f7e0-3217-4095-b28a-3ff8b5afad3a@stanley.mountain
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_wcnss_iris.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/remoteproc/qcom_wcnss_iris.c b/drivers/remoteproc/qcom_wcnss_iris.c
index b989718776bdb..2b52b403eb3f7 100644
--- a/drivers/remoteproc/qcom_wcnss_iris.c
+++ b/drivers/remoteproc/qcom_wcnss_iris.c
@@ -196,6 +196,7 @@ struct qcom_iris *qcom_iris_probe(struct device *parent, bool *use_48mhz_xo)
 
 err_device_del:
 	device_del(&iris->dev);
+	put_device(&iris->dev);
 
 	return ERR_PTR(ret);
 }
@@ -203,4 +204,5 @@ struct qcom_iris *qcom_iris_probe(struct device *parent, bool *use_48mhz_xo)
 void qcom_iris_remove(struct qcom_iris *iris)
 {
 	device_del(&iris->dev);
+	put_device(&iris->dev);
 }
-- 
2.39.5



