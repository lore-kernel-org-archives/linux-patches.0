Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488191ACEDA;
	Mon, 23 Jun 2025 21:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712906; cv=none; b=P59Go7SNmjX++cHxnBfKj03c6poA5dczrNuTdXkLzgXk2X5PCFypxLHYCk+/PURbtDMJUzU0NZS3Siw7rFOdpRd9ZYVUvo+v67B2iSduNu2fpGfxcsFtXzfG4Cr+ejZsXXEaBSl1Ip3Tod3Pms+dl7ls54O6a30PqmHaF+k/cW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712906; c=relaxed/simple;
	bh=kt+HeAdXs4+zMfoCCKAYPbo7/yQfKeVUThyTkYdCDXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDL1DKgy1Xi8smYmYKT3v6wU9hxRaKvcOiNmXf4Gngh/dG8IB106iM4k8Sa0WhxnJGQXJio1v5k62lPm2/Ly2TKqvtEotiFt7bEBTY86p3nvMp7Rertoe5HGCvfSSVLH/MUVqvK5SqzUOIp5QcZct7U+9nv1R5FspUeXtq9pKBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTuTq2QT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTuTq2QT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CA7C4CEEA;
	Mon, 23 Jun 2025 21:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712905;
	bh=kt+HeAdXs4+zMfoCCKAYPbo7/yQfKeVUThyTkYdCDXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTuTq2QT8R8lvJWUjuzNrTU7HR42hmoGYKT97kLDYkyojzonqn1h7TTi8sb1KahFh
	 J5ojJRlp8RFwFZt5P8uCCxgYWWoEZ8C9edrItVK3ErbmRFOoz7QRgx+incxATB64YA
	 vJvOCf/8+aWFotCCDJrg16yFgwp4QqhJDx9T0hT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/411] remoteproc: qcom_wcnss_iris: Add missing put_device() on error in probe
Date: Mon, 23 Jun 2025 15:03:59 +0200
Message-ID: <20250623130635.864941938@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



