Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CE6422556;
	Fri,  4 Sep 2026 06:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502517; cv=none; b=PN+QBefLNPHm4ccdDgy+9/fmyYlPuxReKnvYOzc1BdW2gHuSomeDxnj65k2ayFdDm7ZbfH6aksn5CEZfx9o21UmtvNpaJ2VUjCTRfARN+Cha6LdM73AEAwvYuyWUcSPQPpDi4zpWJKU0RIHYoWr8YtbFny40CgLq9QK6nYR2XnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502517; c=relaxed/simple;
	bh=+FSFvDEmz3u+61vjI2YdjSsUSYYNiF9MkoM9VKfwiPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brZaPtdNhsIv1VHXTBRckuXObqnmY0bhQW2ObgIF37dvZRSOLeMKd0ZAacRG2Rwr09/bxGZgRu5cABF+Z4Lt/kX4JAG5DcsNSQrivN7796p9r9Qqd4qJR5Zzymx8W41RGST8VkSl3z2YV0RLSnUWuiF4n70femUaWC3jQ2CrO74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxSwRTBd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxSwRTBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3764E1F00A3D;
	Fri,  4 Sep 2026 06:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502516;
	bh=jEcUkUaGKn6vqyTyzKDJU9CF7HnqVsT8KfQ5fCUDcpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BxSwRTBd97AlUiPCSVGtZa0cP2C9JvSKXP8wU1WtHpePwfcVNc7Bea+0Yg25MrIid
	 uvjgGvQGQ6ffROJsbQ/0jQTdJOpL14Rid6ukJ1dv3E/frVjjF/JuersfA8TBachi0s
	 TPjZdvwD//ve04hGfeQO/KJK5Mbg1LuQWrImBOpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 236/403] regulator: max8998_pmic_dt_parse_pdata: of_node_put on reg_np after ownership transferred to rdata
Date: Fri,  4 Sep 2026 07:00:39 +0200
Message-ID: <20260904045740.236904198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


