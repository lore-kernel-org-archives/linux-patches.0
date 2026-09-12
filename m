Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A812352022;
	Sat, 12 Sep 2026 15:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227522; cv=none; b=fFGlzsQ6+yA7Ka8a5U7YOb49uaVE9bP/X2Zre9vnvjz9xgKsgOW7rivSTxxKTLksaUaNkandTI8tFCJg3KBSKchD44l6SZ0IDzAwEsG45uufimwBMFH66RzO4M6ABi/XQH37Ptkw+J63t6gzyEk0K47D0K8xSOuIZ6z78hr+j0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227522; c=relaxed/simple;
	bh=KCrGzhPheZCXi129tGG2UKEdHB8dILRT+3zVFzy7QrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sv+OyitfcjlPCztstHzan7beWpXH3K0ZvkAjvd0dtTeH9XcXuxlJuNhroANIp7trBTNGkbFYg3jtvSmRuXIu2dSKaq05L9aX0HO5JuplcUFIQwbRsuZs7ndbl5OcXowurgGHN/W6BLozXlqxY3KgXV39am71s7zJVkYVAgQUD20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VvpFr+uH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VvpFr+uH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CF61F000FF;
	Sat, 12 Sep 2026 15:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227520;
	bh=U/GFXjHRm7Xa+MgDTanep595vnLHB1n7EAfkxV/5tWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VvpFr+uH5x30kTjtPlfDr+BQ1lYCgR4xF7n6mzYtFbV+QnypWx/dmirL2nRAWjy3g
	 X00+5r2W3ePL8TfBPrjfebVupqV2wrX4WwjTHB3O9joaSx2FijHR0wIMZCDmVFmSUt
	 W3AyrMMNprz9CiwCu8r5I2G91i2v8o9Ctjpnk6T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 0146/1191] regulator: max8998_pmic_dt_parse_pdata: of_node_put on reg_np after ownership transferred to rdata
Date: Sat, 12 Sep 2026 08:47:54 +0200
Message-ID: <20260912065551.481722659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


