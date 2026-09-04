Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21082F9DA1;
	Fri,  4 Sep 2026 05:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501205; cv=none; b=dSiK/EcyiYxLfVK4L83Mg0h9NGwahb1CgL12WtxqYRpOK91Q52jfhnG6BsxSTdKrnQ0nPznkb9ZW0/414WRIXeYzbd+YiTvD3Acg7h8FLFp1qbxYdyca8auDLGCm10IIc1ckUc9nqZ7tOg7n3bD2M/e+MgwPBi09zZN+LrJEKww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501205; c=relaxed/simple;
	bh=jBdeOLYiNl3OZZu79xHZzXea7z1a+Z21hsJe4eGzTZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgXDMlc4X8q6E6id1I4QRCaI21w0lA0S8sNgzVAe8M708M6GtRTylRHq0FgfwLhLBRUDF8coYT4bnm9jprPmf2vunR5px93kxM6Kf3Y8YXpoUOFDVRw035tC3K6hRFuQhmxI2hsIgOzbnEeTqSNmMTyF1t2wqxBWO19+vaALK9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3Ijkwfg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3Ijkwfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1671F00A3D;
	Fri,  4 Sep 2026 05:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501203;
	bh=zCpUndT7/9xE0QBcJOdv96tqgiDcCobBUg3vB+XPYcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C3Ijkwfgg5JOOqzzV9mqKjfrtTm940ZDgVxGHfwsmHOFMfs2T8/ocCv5YFHz+r3Gn
	 1zzHVEgoGqLQ4i0yywFQB8elWYiBq/PPShjxcZMHMzBRuyUSKJKt0s/OxlZbW2sFRW
	 v4bk8Dx6nvsyGOcXRKXBPQRIK9fAcZnCvYOsgS5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 327/552] regulator: max8998_pmic_dt_parse_pdata: of_node_put on reg_np after ownership transferred to rdata
Date: Fri,  4 Sep 2026 06:58:04 +0200
Message-ID: <20260904045757.682378807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: WenTao Liang <vulab@iscas.ac.cn>

commit 7c8cc25d8d86f9eb3979255935cfdc7d062ad746 upstream.

In max8998_pmic_dt_parse_pdata(), of_get_child_by_name() acquires a
reference on reg_np which is then stored in rdata->reg_node, transferring
ownership to the regulator data array. The subsequent of_node_put(reg_np)
at the end of the function releases the last matched regulator node's
reference, leaving rdata->reg_node as a dangling pointer for the last
entry.

Remove the spurious of_node_put(reg_np) call.

Cc: stable@vger.kernel.org
Fixes: 156f252857df ("drivers: regulator: add Maxim 8998 driver")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260626160326.54457-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/max8998.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -582,7 +582,6 @@ static int max8998_pmic_dt_parse_pdata(s
 	}
 	pdata->num_regulators = rdata - pdata->regulators;
 
-	of_node_put(reg_np);
 	of_node_put(regulators_np);
 
 	pdata->buck_voltage_lock = of_property_read_bool(pmic_np, "max8998,pmic-buck-voltage-lock");


