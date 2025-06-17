Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F212F2340;
	Tue, 17 Jun 2025 15:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175757; cv=none; b=rZsahAGrn0xcdLCgRwpGw58IM5UHUiZmXkNqTTIaLBFN2F/Kncu0SYmnGf2cCCehjGVwvulZCm/g3TrGV4snmzFlXFwo86rZo2KbbHUQWLALHEq2YSG1MkJRT6eEYCRs+AA5PyU5hp9hNYpHNZDzfG4CBeanSSM3eq9KJNX5kwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175757; c=relaxed/simple;
	bh=dhkJ5kyhMfTx5Wj0c0twW3vogU5eygcxCvfwX92H320=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZ7w7qKNtixMl7adGImhE9zVZ78LQ+qyXTuVsXTkjCQxe34M4ctlLTBFby/88RBMFoGOXF16A3BHFdTYzJ+Le1SA513dFfStiqmQE73gN/xX7J2M4ZT2IffRlrvB5jOlNWi6FlNYVYT5mwDjKIIAtoV3oURwk8v8bDF/oO3QO4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVyqj/5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVyqj/5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4F1C4CEE3;
	Tue, 17 Jun 2025 15:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175756;
	bh=dhkJ5kyhMfTx5Wj0c0twW3vogU5eygcxCvfwX92H320=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVyqj/5/TeFtZ1g6+Q7Gjzdc5r4V2R8wi1LT1qgfYVBzonjFXZ9j+CRSkNsww5co5
	 p3gXwW2eFKt2K+S/qDrg1+rIEbYK18guxll6kEfVOAOKulX+2rOsuvKQtf8uO3P3TP
	 cYDO7n+Kg6aVttXWBTWQTyvZTga+6VimWOLs/rvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/356] remoteproc: qcom_wcnss_iris: Add missing put_device() on error in probe
Date: Tue, 17 Jun 2025 17:25:25 +0200
Message-ID: <20250617152346.664305418@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dd36fd077911a..1e197f7734742 100644
--- a/drivers/remoteproc/qcom_wcnss_iris.c
+++ b/drivers/remoteproc/qcom_wcnss_iris.c
@@ -197,6 +197,7 @@ struct qcom_iris *qcom_iris_probe(struct device *parent, bool *use_48mhz_xo)
 
 err_device_del:
 	device_del(&iris->dev);
+	put_device(&iris->dev);
 
 	return ERR_PTR(ret);
 }
@@ -204,4 +205,5 @@ struct qcom_iris *qcom_iris_probe(struct device *parent, bool *use_48mhz_xo)
 void qcom_iris_remove(struct qcom_iris *iris)
 {
 	device_del(&iris->dev);
+	put_device(&iris->dev);
 }
-- 
2.39.5



