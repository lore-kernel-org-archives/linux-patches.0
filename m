Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6E53546E4;
	Sat, 12 Sep 2026 07:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198739; cv=none; b=kX1veFOajM4uZpqA53SQWkkP582/D7Ou0YBxIIM5W3GqwH73O3Axn3EXjWyCwLbuEHP+loQFyfUbyTCPrfm19GxDscHsI2UM8/KSOGCEo5nnOouEQcxiMoklDdcBq/SLyai8XeRfomPEsuRIGml2PvYg/64v6aVHTa2OJsqF3bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198739; c=relaxed/simple;
	bh=HOvzGDHnpCAxGqakCBA5rbvd8vkD58ODeWueUTz3DUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNGkShmMW049MznbvN71EllUO2WPSyqnf8s3LjTpMhX2JXFMU1rs4e4JH5yv8pQ5sA2IJhy3YN9q3u9Hx9NBZe4L45ouWRlFkhgnFe4c4a93Ze7TbWgKbAayL4K9ZW8rZqHBjO05P+OhllQZHNvGoiXffZVSaVjy9ZdRjYNJX0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qbj9eBsm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qbj9eBsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECFD1F000FF;
	Sat, 12 Sep 2026 07:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198738;
	bh=dJ8L6lITHhNsL5uyrkSHK5JQ1PPCnJhyp+Jz9AQJZ3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qbj9eBsm7zoJ1//E8akcny8z+Ec5kjYJWQOh4Uuwu57+DNvKdtk08GFCOsjjZKuXu
	 mCBOoyGOVTlmkvTrjc83YD/uGVqXZvwhzYsJ9hEQehXlDUa9U8LE+6TwsZYru9zvpA
	 8hJ6aLTmVZ6hdBHNlhd71mMINGRRTOP0FvNnvXhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0441/1815] remoteproc: qcom_q6v5_mss: Fix MDM9607 subsystem control instance ID
Date: Sat, 12 Sep 2026 08:36:31 +0200
Message-ID: <20260912065659.244254235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

[ Upstream commit 846baa5ab461e24d31f942dcdff1932e8516dd00 ]

On MDM9607, the modem firmware exposes the QMI subsystem control service
with instance ID 0x22 (34), as visible e.g. with qrtr-lookup:

  $ qrtr-lookup
  Service Version Instance Node  Port
       43       2       34    3     1 Subsystem control service

Currently, qcom_q6v5_mss uses ssctl_id 0x12 for all platforms. The QMI
service never shows up with this ID, leading to the following error when
trying to shutdown the modem:

  qcom-q6v5-mss 4080000.remoteproc: timeout waiting for ssctl service

Set the correct ssctl_id to allow clean shutdown of the modem firmware with
the subsystem control service. ssctl_id 0x22 is also used by other
modem-only Qualcomm platforms in qcom_q6v5_pas, such as SDX55.

Fixes: 4fe236a1d024 ("remoteproc: qcom_q6v5_mss: Add MDM9607")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260706-qcom-q6v5-mss-mdm9607-ssctl-id-v1-2-f59e728af621@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index 425601af50d1c..eb14308e7aef0 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -2486,7 +2486,7 @@ static const struct rproc_hexagon_res mdm9607_mss = {
 	.has_ext_cntl_regs = false,
 	.has_vq6 = false,
 	.version = MSS_MDM9607,
-	.ssctl_id = 0x12,
+	.ssctl_id = 0x22,
 };
 
 static const struct rproc_hexagon_res msm8909_mss = {
-- 
2.53.0



