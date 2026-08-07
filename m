Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD00447A889;
	Fri,  7 Aug 2026 15:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114846; cv=none; b=aXlwtadG7fgwSZ3TXKSnEWXkri25OTH+gwkOOQh0zJ2E8YLb5WSeF05mV9YQ6U4ZjgPisSuuQ/20sw77wPNLSOZJ2V3RiVmcPC8gvH/A1Dt6dqkx3wu6rGUkFZtwFd9vs6QnfOoxo/SAjvzLvj8p+A2sVn2QMN36IGJ0wFCDdIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114846; c=relaxed/simple;
	bh=PiePzOlvdJ+v5/ALonHaEJHzE/4xz04WkCF06tFQfuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acCY7oV0iO1qRNbFrmQjQrNWBSat0oXAVxKIrPnOS+oX6k3P5Xq2orNDpE4yEpK8l2ssQdlPThhRogrqhhQVBkE0VuV8H8gZHyC+seqRd0mJJ7FEdD8pxSDRE0SZ/1uS4rgOecZB1KQyzvq188u7U3fAUrVWfWWnkdm8Vcv4FSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCf/K7Om; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCf/K7Om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BD21F000E9;
	Fri,  7 Aug 2026 15:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114845;
	bh=BNrzEwCCmEIVv4q0VcwOxTTD28+m50r6Sf0qcSOQmNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCf/K7OmvrsWQUGR/rCHdW74g66G4WNAFcHGEcKF0tKm9P7HumVZ1j2V7DoUSZRSq
	 bFkygAOLvKNOAQDjIR3S+unWgZ6nl+hlpuz7O4/MFBATvqTDw+sxDjPPwc+DxV9VdO
	 fQ1FeFQboSwgg51rwg1tV5o/kLprJi9D2+6tnpzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/396] ASoC: tas2781: Use correct calibration data for SINEGAIN2 register
Date: Fri,  7 Aug 2026 16:33:48 +0200
Message-ID: <20260807143425.738422504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit dd88cf6273de61f2f7206c2066af97798dbb38b0 ]

The SINEGAIN2_REG case in cali_reg_update() references t->sin_gn[]
rather than t->sin_gn2[], causing the second pilot tone gain
calibration to be programmed with the wrong register address.

These are distinct fields in struct fct_param_address and are
populated from separate firmware parameters by the parser in
tas2781-fmwlib.c.

Fixes: 84d6a465f211 ("ASoC: tas2781: Support dsp firmware Alpha and Beta seaies")
Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260720081616.631413-1-wangdich9700@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index a3b4d2c3b4789..0b83446da45ea 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -1303,8 +1303,8 @@ static void cali_reg_update(struct bulk_reg_val *p,
 				t->sin_gn[2]);
 			break;
 		case TAS2781_PRM_SINEGAIN2_REG:
-			reg = TASDEVICE_REG(t->sin_gn[0], t->sin_gn[1],
-				t->sin_gn[2]);
+			reg = TASDEVICE_REG(t->sin_gn2[0], t->sin_gn2[1],
+				t->sin_gn2[2]);
 			break;
 		default:
 			reg = 0;
-- 
2.53.0



