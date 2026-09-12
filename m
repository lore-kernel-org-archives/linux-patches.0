Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB344455626;
	Sat, 12 Sep 2026 13:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220424; cv=none; b=ZE0F+cRy/W+/w66sVzz4v+BNvaZJ+EX4eigqu57CXBbuVMmLHwIt6z+zP1xYRS1+6penLwA//iP28kmAZ1peydd/dpXnNg52bpGlrjjdCUigXFFQPrI/Mcb39cDhGYw8Cr9yN1BL8bmo6QtjqsjfqUy0/9jt8Id9tGBlAjFCYwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220424; c=relaxed/simple;
	bh=AH6ZPrZA4k05UNgrlOo+0NGrIcNyccJUPAxycsChXR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tmy2ViJhDqPd1baqqEsTQo0rucM1mRmki2R5rmQ5K2JcX9knrFavdVYdoYXGdymIEaNVKDCi+ltmNE6cer7ctJqoshtrU8bGXyiHt8qpJfOUZYYEy/Ck2BGQWsOKOgdgarI5COsCpepAok80xpFZO+LF+2g/fuhuS3oOCOSG9fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4rsjdq+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4rsjdq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DE51F000FF;
	Sat, 12 Sep 2026 13:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220422;
	bh=5cawHsKBjRqi63m5+vjYrN6INt4zRgF0f4foiY6VW+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x4rsjdq+3gVRyb4vM64o9Tx42abVJM4ZD6WRY0RqfEvC7X8nZX8u0gZp9f6tt5ucd
	 SdGwZc5yXpGRJXaESor6FIWu216rSW6rP5Xljyfh9i70/iIlW3nMD+r06Od0RoTwwr
	 mUk04UulXweEHJLhA3ARQ4x2Kc308NZ1K/j+P2j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0175/1424] regulator: max8998_pmic_dt_parse_pdata: of_node_put on reg_np after ownership transferred to rdata
Date: Sat, 12 Sep 2026 08:43:27 +0200
Message-ID: <20260912065611.211801871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


