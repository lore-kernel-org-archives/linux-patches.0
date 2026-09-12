Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11F732D7F8;
	Sat, 12 Sep 2026 18:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236962; cv=none; b=oAAWHTZ6EVA/dI7FJr2J8gC5ha9bZW23Sl2BtcNLm/GK5urmcl4lClpJuNcYMC1dXyhVFt5t9kAi0uDpEPXUVjTuvy4tpJmkv0QLiqDcLWgwdUkgvPdZmMingooN+wbzXF/L1WmIQgrwTyzV1ugTkJWPTHYa56mhNV8Y26Q0JsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236962; c=relaxed/simple;
	bh=6CtTEDsKFFIwfJse5SnprRhgjjmK4gjO3KAwgTtuZHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gC5PVUUU0iqmVvCfcU796EakLc7rJvuNQ3X7FLmE9olAh6DaySPhevNOpRxlyzTXUJEjvLzSNxTzef2Wv/49i4MltDxkydCb/ZfonObZDyZN/MnMugg7PKDWZI0DtRqmnTCAwHHnEPjbZbA2dqhWkLrvD/M35V3+oGbhtyWM/RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sc0FdG2B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sc0FdG2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70FD1F000FF;
	Sat, 12 Sep 2026 18:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789236960;
	bh=cfKflbIMIfTofRqGcccuhX5jalfew8dz9Lr2Vcf1lQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sc0FdG2BCNybcF1zuJlQPuUpFGDX+dkyV99cIZFc7Fu24JLbAy88jfaiO3gi5iM+W
	 540weXlGQBPsLuCAs5shW4FhmJZOl3Q43mjP5VrpqAMZfj7ISZ9oMIZfghVV/X4cpV
	 svTP3TOMeBqHGrxlwdmDzuNKYzQe9uamzwxgmbBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 125/935] regulator: max8998_pmic_dt_parse_pdata: of_node_put on reg_np after ownership transferred to rdata
Date: Sat, 12 Sep 2026 08:52:35 +0200
Message-ID: <20260912065529.690962824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -611,7 +611,6 @@ static int max8998_pmic_dt_parse_pdata(s
 	}
 	pdata->num_regulators = rdata - pdata->regulators;
 
-	of_node_put(reg_np);
 	of_node_put(regulators_np);
 
 	ret = max8998_pmic_dt_parse_dvs_gpio(iodev, pdata, pmic_np);


