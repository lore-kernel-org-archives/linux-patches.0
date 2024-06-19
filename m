Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9315A145352;
	Wed, 19 Jun 2024 13:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802048; cv=none; b=HV8Fz1C872qmXMok1wQAfTiF1BiTgRhkjo6cmnG8wbDP19iVncMMFMEXgxPJp5FPP1PtHY11NrfBfxR1OdGP+12cNjI4QVhE63Yu/LUGFnFNcZUb7a09WYNuoAeDFWJ0UzoeZ9fshMtbqQl8ETcY0g8OnQedjtTygxhCMg/w9No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802048; c=relaxed/simple;
	bh=Pkle6CRaiRUpM18TeoBv5svzvDVpg2DyR3BJN5veKSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e666m3jVaCxQCEOtuFnBkn4dHFoteHrqfM5QlQjf9tW9C9PkSPBeWz7sF1IhTipt1cKVac8L2Hhvf+tU8e+tN1IGuu6XKNsX4H8KEH/IRV1NUzuL3YBKb4/HqL7ZZeenc6Wj219Nf5Fb64MpqQa6+jl1ehQimekXhO/wkoduLYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+OgigTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+OgigTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A8FC4AF1A;
	Wed, 19 Jun 2024 13:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802048;
	bh=Pkle6CRaiRUpM18TeoBv5svzvDVpg2DyR3BJN5veKSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+OgigTGp66MnzVTJT/z891aq0aWf0WKaulcNbdIXQXMJ/iWod5ZfiDXweDJuFLJE
	 XvzAHixevpKNu/XjgtAsMPE5DY8KkfyLmlgLEPHpFPoT36tWCZhHWp8eB2dx7mziQl
	 bjqQvbaLbbXhD7uBTC7jU820VawbYCUtski7+d0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/267] firmware: qcom_scm: disable clocks if qcom_scm_bw_enable() fails
Date: Wed, 19 Jun 2024 14:53:36 +0200
Message-ID: <20240619125608.853261904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ff7c155239e31..7af59985f1c1f 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -498,13 +498,14 @@ int qcom_scm_pas_init_image(u32 peripheral, const void *metadata, size_t size,
 
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
@@ -566,10 +567,12 @@ int qcom_scm_pas_mem_setup(u32 peripheral, phys_addr_t addr, phys_addr_t size)
 
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
@@ -601,10 +604,12 @@ int qcom_scm_pas_auth_and_reset(u32 peripheral)
 
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
@@ -635,11 +640,12 @@ int qcom_scm_pas_shutdown(u32 peripheral)
 
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



