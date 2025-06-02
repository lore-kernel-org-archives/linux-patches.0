Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDEC22ACD6;
	Mon,  2 Jun 2025 14:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876389; cv=none; b=uqLEmASOPwMIaIvpbD/2joR6lIIYTg8iKXnjCSdSDLYuzIZTBQviXFdu9KH8MuSJ9SAIBX1TINqlfVwaWdIJeqBvpItiBh6edkUlAh9h46WCRDWOJYVpTiEkklSsyCgX5uhTBoZfiUKToOJ2InT1r3CVVm4S2Ja9O79v4FKcWFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876389; c=relaxed/simple;
	bh=YBiOVvLSsdzOqvqYB4heWBnekybTa/efAs/nlLv9T4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uM3TWpFUOfe0k0jViB+42y/Ih+/iKfPd85kvw56jViAi0aWfgLVXk26ykoYDHo6g6s4Od3FiOe07+Rf9yVmmWRZT5RG7ti+nN5+osn6NxFlEpaSkxjCKtWjgeIrILtb4pUYN2W6Rnj9DLSTOhvbz+FLd27MY1133vBFpdUshVfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSS3houy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSS3houy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BF7C4CEEB;
	Mon,  2 Jun 2025 14:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876389;
	bh=YBiOVvLSsdzOqvqYB4heWBnekybTa/efAs/nlLv9T4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSS3houy/FaCTMmE1Q3mhIEiGqCGMx2U+jPkBDdLdCfXOL1XgHoLiWhyy0k/CI8Hv
	 HR44cDB47zxdBsbxCk9G3QVTjL+j1OCKtqzhIiD9DRLE774hfyOs7Wld6e6cAcd1py
	 KaeFnr+AsnS/Y2ZJVdU+7fHIcTTKIsn2SmITBs0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Matti=20Lehtim=C3=A4ki?= <matti.lehtimaki@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH 5.15 162/207] remoteproc: qcom_wcnss: Fix on platforms without fallback regulators
Date: Mon,  2 Jun 2025 15:48:54 +0200
Message-ID: <20250602134305.070651017@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Lehtimäki <matti.lehtimaki@gmail.com>

[ Upstream commit 4ca45af0a56d00b86285d6fdd720dca3215059a7 ]

Recent change to handle platforms with only single power domain broke
pronto-v3 which requires power domains and doesn't have fallback voltage
regulators in case power domains are missing. Add a check to verify
the number of fallback voltage regulators before using the code which
handles single power domain situation.

Fixes: 65991ea8a6d1 ("remoteproc: qcom_wcnss: Handle platforms with only single power domain")
Signed-off-by: Matti Lehtimäki <matti.lehtimaki@gmail.com>
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sdm632-fairphone-fp3
Link: https://lore.kernel.org/r/20250511234026.94735-1-matti.lehtimaki@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_wcnss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_wcnss.c b/drivers/remoteproc/qcom_wcnss.c
index 3e07f5621d0f2..90c09cde6e0fb 100644
--- a/drivers/remoteproc/qcom_wcnss.c
+++ b/drivers/remoteproc/qcom_wcnss.c
@@ -446,7 +446,8 @@ static int wcnss_init_regulators(struct qcom_wcnss *wcnss,
 	if (wcnss->num_pds) {
 		info += wcnss->num_pds;
 		/* Handle single power domain case */
-		num_vregs += num_pd_vregs - wcnss->num_pds;
+		if (wcnss->num_pds < num_pd_vregs)
+			num_vregs += num_pd_vregs - wcnss->num_pds;
 	} else {
 		num_vregs += num_pd_vregs;
 	}
-- 
2.39.5



