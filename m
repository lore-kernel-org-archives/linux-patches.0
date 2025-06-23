Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18EB1EDA0F;
	Mon, 23 Jun 2025 21:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714042; cv=none; b=YivSzifYwJWAeehNPvVcAnAL5HmnQbfEbBWMpcCRHFyRGUrduSX0T/f+jXhWSKXgwO3DTymJVrIlX4b7Hll43Azy3y7Vv67qYzRZuxlW0FqOo7tW9qOrn4hyMc5X66tBl56jvkH0MVo9KTyPy5JOVyJ+qiWjn+IU97f48vLH4vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714042; c=relaxed/simple;
	bh=7YCSJrMvNNu6OsN0NYFSe05up6+CJhsg1BtEog532Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VE8rCltte/LqMeeNmOMp6KkjY4ot90ed2LiYesu1C6Z0llDWTvYGklRkqkIWcNcyg9FNWIrxsfGaIK9hIWjgKcsuLur5aJLCH1X1230ovn7vCaox2DD2MgvrYAe4hmuo/Ig18Culg2jTanEb3jq0fCRGlyqBNhEzV11cyMYA4ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PEd6HEMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PEd6HEMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC7DC4CEEA;
	Mon, 23 Jun 2025 21:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714042;
	bh=7YCSJrMvNNu6OsN0NYFSe05up6+CJhsg1BtEog532Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PEd6HEMZQrUVbfLLk2DiymJMlVdveZb+0K9vr04NpOnRe52wrHixkL1dW7kjJalF3
	 vXEUL1GSLfl02lOGnSesBUhxrhsWbipXew0tgZPHsEOvz708LdbkFjNa5v+QMchpaT
	 KxzgLVm/ZYvSccmcIFvCyReB5BUBbHhbH63yCsWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/508] remoteproc: qcom_wcnss_iris: Add missing put_device() on error in probe
Date: Mon, 23 Jun 2025 15:03:06 +0200
Message-ID: <20250623130648.755607348@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 09720ddddc857..7c7b688eda1d9 100644
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



