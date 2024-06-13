Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86866AFAE;
	Thu, 13 Jun 2024 11:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279373; cv=none; b=Y7F7EUi4pM9khtx7BbvrOJ3sbDNfyYKLpyU0VTWi1d81kFfhuoqEcB7BVUvBkAu0HbxCxtj56YoOjLMB9GmhslcmPuHrcqKJF95iNpmPJEnp1ZOXZg9zbPkklF9g/SvkCEEyaGgKjO3ILd/F8USB6NLWA/j/p1bcYN2shvVjxQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279373; c=relaxed/simple;
	bh=9Xt4CmBc/IWVlYEpfirL6VyzEAvWWZBsaLISltE6SJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiEFFCsI1XYuHKzboJ5JF0C5dDncp0eIrWt0Lh0Hva/pwHIMEl7A/QUZ/EJbb3cwocasWVmKWPy7av4cmZUT0mkdyFREJaVz/swd7Gi9ewuLGbba06d5BCmqI0Ikr+ALUGpx/YJ/hQAd+oJO0M1WB2zGDJUxPEtpLAE2aA8kY5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVprGWSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVprGWSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDA6C4AF49;
	Thu, 13 Jun 2024 11:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279372;
	bh=9Xt4CmBc/IWVlYEpfirL6VyzEAvWWZBsaLISltE6SJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVprGWSGNzRchu9DsyadK23MdqF1kM8Z5B5awM3w7EkX16xdRd7GYg4wNudQc+HEl
	 qOjUToWy61dZINi/zduLHNaiZ+rK5swZAR/AsD/55270wG5NCM2/d/E95/oRjcC2SU
	 p7IfwvqNuBMrnTuD5fDK/rnytHRZCWAAVV5M+Gkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 052/157] firmware: qcom_scm: disable clocks if qcom_scm_bw_enable() fails
Date: Thu, 13 Jun 2024 13:32:57 +0200
Message-ID: <20240613113229.438943968@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

commit 0c50b7fcf2773b4853e83fc15aba1a196ba95966 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/qcom/qcom_scm.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -569,13 +569,14 @@ int qcom_scm_pas_init_image(u32 peripher
 
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
@@ -637,10 +638,12 @@ int qcom_scm_pas_mem_setup(u32 periphera
 
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
@@ -672,10 +675,12 @@ int qcom_scm_pas_auth_and_reset(u32 peri
 
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
@@ -706,11 +711,12 @@ int qcom_scm_pas_shutdown(u32 peripheral
 
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


