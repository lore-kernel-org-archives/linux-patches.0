Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164651E2618;
	Mon, 21 Oct 2024 10:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507121; cv=none; b=gNNHXu9JmoLrZVYwlrbm0C/cM7ilSvBIh8Tq/4AGBxrMZ4MSDk40Eik2MBrMZS9XPlf0K6e3Wg7grXY+g24v36fbn7Hnq/zI2JrXOuuRreTWU4WfWkDUovCV2ns0O6BruZWtKbyxqC+EiElbnCwDC99q5VZLsbT/QqxRI96MZlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507121; c=relaxed/simple;
	bh=J1p0xivP7K1Ws0G/ikkiGx+itttSP7JRfL8eApI/Img=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrEzglHv2BuivwtMt/DE4PbxNMuRrCqZxtIRm3N9tQEeMIRh3Sdg61hrepSInZDhSLR/9B+/93hvLd1PUBlqBVuhMgWy6ckzZ2EFpgMcWR2HSYPD+eEVTp/nartkF8EGO/h3IStbuo4p/TormT2M9Nct4UnZcH6l8j2vDHyM//0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfyt0+Yf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfyt0+Yf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D719C4CEC3;
	Mon, 21 Oct 2024 10:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507120;
	bh=J1p0xivP7K1Ws0G/ikkiGx+itttSP7JRfL8eApI/Img=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfyt0+YfgH7erBD+PK9ti6Bh8yIw9cV2AGrFx/y9Qt6SwRGhFdANz7hdGRGU/UH5+
	 TaGuHVt9PguEpHI8vYjCq3DQjl21m2mHuiY2cTcMdQvoji1G26oVOq+RGPCSamr+sD
	 aNg7t7Ynix7FbR2NNAoyuMWDfGFj7aKXN0mB/wDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jonathan Marek <jonathan@marek.ca>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.6 097/124] usb: typec: qcom-pmic-typec: fix sink status being overwritten with RP_DEF
Date: Mon, 21 Oct 2024 12:25:01 +0200
Message-ID: <20241021102300.475662251@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

From: Jonathan Marek <jonathan@marek.ca>

commit ffe85c24d7ca5de7d57690c0ab194b3838674935 upstream.

This line is overwriting the result of the above switch-case.

This fixes the tcpm driver getting stuck in a "Sink TX No Go" loop.

Fixes: a4422ff22142 ("usb: typec: qcom: Add Qualcomm PMIC Type-C driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Acked-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241005144146.2345-1-jonathan@marek.ca
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c
+++ b/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c
@@ -252,7 +252,6 @@ int qcom_pmic_typec_port_get_cc(struct p
 			val = TYPEC_CC_RP_DEF;
 			break;
 		}
-		val = TYPEC_CC_RP_DEF;
 	}
 
 	if (misc & CC_ORIENTATION)


