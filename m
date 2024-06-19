Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1091414D711;
	Wed, 19 Jun 2024 13:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803731; cv=none; b=qG69WD25iNC0pTLa7foNueuP6dGhwu55sPuxzYihRrj7F9pm/hd8swwG2DlKj3Utb0BkZV6/l6x7L5jCDxeN9Tvyoel/xodTreQmQ3yTwX0HW1QSnx3zCyxELoSubGpW/YrqIsk+Gw8uBy1nHxK55zy0F25h+0ucbePPkzMqUBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803731; c=relaxed/simple;
	bh=ufSNOUwPVi97Yp1McyYEiE8T3xIaMlbtp6FZONGGty0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICXM1+orEXz67LJHNChK51C5Yu2JO0L/+OnTI20lkX08zPf7MxUgUnaZiVaAqsjZIQdIHly+U+99cfos1p7eOZ7tmxD40gqJsA7Golh8ke2eNbyLKKow+jIz2NP898fhvm5Mzcf0DPn4ckMfPsBn7iIfzPm5fq5M4hyCZUcR3lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CV9GVb61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CV9GVb61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1CAC4AF1D;
	Wed, 19 Jun 2024 13:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803730;
	bh=ufSNOUwPVi97Yp1McyYEiE8T3xIaMlbtp6FZONGGty0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CV9GVb61PjP7Xl6lSYG5ainIa5WnP5rcs7imcfH1n5Z1Lq0Slk0Uvp/W9kG1xROIG
	 TEN6Dx1fHAcuw/V/Gcmz+sm9T6PDbz0pCFJYImwhUzDF/pJ2LHX9roxt5se1yh1jLC
	 Kvgf2ivLvMWYeer/wJlYQ79ZUYgprzuU+yEIqD5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/217] firmware: qcom_scm: disable clocks if qcom_scm_bw_enable() fails
Date: Wed, 19 Jun 2024 14:55:10 +0200
Message-ID: <20240619125559.269725634@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 0c50b7fcf2773b4853e83fc15aba1a196ba95966 ]

There are several functions which are calling qcom_scm_bw_enable()
then returns immediately if the call fails and leaves the clocks
enabled.

Change the code of these functions to disable clocks when the
qcom_scm_bw_enable() call fails. This also fixes a possible dma
buffer leak in the qcom_scm_pas_init_image() function.

Compile tested only due to lack of hardware with interconnect
support.

Cc: stable@vger.kernel.org
Fixes: 65b7ebda5028 ("firmware: qcom_scm: Add bw voting support to the SCM interface")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Link: https://lore.kernel.org/r/20240304-qcom-scm-disable-clk-v1-1-b36e51577ca1@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom_scm.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index 58f1a86065dc9..619cd6548cf64 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -495,13 +495,14 @@ int qcom_scm_pas_init_image(u32 peripheral, const void *metadata, size_t size,
 
 	ret = qcom_scm_bw_enable();
 	if (ret)
-		return ret;
+		goto disable_clk;
 
 	desc.args[1] = mdata_phys;
 
 	ret = qcom_scm_call(__scm->dev, &desc, &res);
-
 	qcom_scm_bw_disable();
+
+disable_clk:
 	qcom_scm_clk_disable();
 
 out:
@@ -563,10 +564,12 @@ int qcom_scm_pas_mem_setup(u32 peripheral, phys_addr_t addr, phys_addr_t size)
 
 	ret = qcom_scm_bw_enable();
 	if (ret)
-		return ret;
+		goto disable_clk;
 
 	ret = qcom_scm_call(__scm->dev, &desc, &res);
 	qcom_scm_bw_disable();
+
+disable_clk:
 	qcom_scm_clk_disable();
 
 	return ret ? : res.result[0];
@@ -598,10 +601,12 @@ int qcom_scm_pas_auth_and_reset(u32 peripheral)
 
 	ret = qcom_scm_bw_enable();
 	if (ret)
-		return ret;
+		goto disable_clk;
 
 	ret = qcom_scm_call(__scm->dev, &desc, &res);
 	qcom_scm_bw_disable();
+
+disable_clk:
 	qcom_scm_clk_disable();
 
 	return ret ? : res.result[0];
@@ -632,11 +637,12 @@ int qcom_scm_pas_shutdown(u32 peripheral)
 
 	ret = qcom_scm_bw_enable();
 	if (ret)
-		return ret;
+		goto disable_clk;
 
 	ret = qcom_scm_call(__scm->dev, &desc, &res);
-
 	qcom_scm_bw_disable();
+
+disable_clk:
 	qcom_scm_clk_disable();
 
 	return ret ? : res.result[0];
-- 
2.43.0



