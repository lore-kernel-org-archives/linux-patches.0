Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556EB2F5337;
	Fri,  7 Aug 2026 15:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116784; cv=none; b=dBuZ0GMFjXYJ6GQP2C981UpLCumdsFM6miMQ9OpqWRsDj0grLjHyVEc4BCUA6QMzzSYYy+wHhQFPBcVoYUTFBzR5dqNbi202Itn3sZvRnCD4Ox8UM4FKTpQQSDeLjp27JIWBmZnCCaFXN04+YBNHC0ADYdBJTjQxEA1253oizCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116784; c=relaxed/simple;
	bh=fBfkRYffSHVyHzHH1L2XiboVibo7TRkgDavAtTE6x3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ja3kkueMQDq+Qn8a3xmqalgAXUy67Sg++TjbHGNum2ZFFD9RRaNBiT7MgZ5OBtkiMnQhKpVmaAjcUROvBcW7LBzkKDWJ8UHSuHgJkA0Wd5vh7g566hpPwiNzUBfdyz0l29CADckTt2n5LQP4KUovCUAKgNkF+ph1+aUpaUhQbPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnOKNqVA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnOKNqVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67621F000E9;
	Fri,  7 Aug 2026 15:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116783;
	bh=BPEcP1h7lhKS79LN8KkU5SS3Cs/Yhmf2dVL5vNnLWx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnOKNqVAv+zGMqCqlrt5TaZWp01erMagAV76yfeD1LjXDxncXGvXxrNXnoA5RA9vC
	 7y3m+6wjvICasDI70TmKAlHyyUwFLfe20eBT9SXr6m4ezkGf7FKIxblXDbf8/3d60x
	 9a88Ei1d8X2U8TDf7F2O8Xytf27FRvHjCw+oOX5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 089/438] ASoC: tas2781: Use correct calibration data for SINEGAIN2 register
Date: Fri,  7 Aug 2026 16:34:45 +0200
Message-ID: <20260807143429.882796079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index a78a8f9b98338..775c3767bf3a8 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -1308,8 +1308,8 @@ static void cali_reg_update(struct bulk_reg_val *p,
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



