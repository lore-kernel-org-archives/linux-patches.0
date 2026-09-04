Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D48421240;
	Fri,  4 Sep 2026 06:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502515; cv=none; b=HIeV8qi3i96rRkCI0VDfMI0DNqLBzvHM3lP27Wc/WBQk46nvAvBKf7Sdo4NZsvz0h4+WBezPnQcqm34+6ywOAf9Pi7oKD5bo6glKUM7Og690n9oL320Y0Ue1vKd77Va9ZqINWd0DwatoKIaScEsRI/03acg0NwQFQLRgn2oKuSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502515; c=relaxed/simple;
	bh=1c3fXZx5BdVicQj00MmRruL3TJwK5XpaqmYsNI8cp94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOHJi0fsjOI0NBkvIfSnwIBi4lf/1B/lAKDiVpDQ1YBE2hrt8ihq/RVUxZFJgyaJ43UY9or5XdmV7xUDlBgR5zyuPya0SsSgnPng3OfSfGpDat7RMCseAN016ZivALabydDIxxSVDmpif0cnGzuTH6L5WuzpwsyCgFgj0WclqPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKIQF+w9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKIQF+w9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6042A1F00A3D;
	Fri,  4 Sep 2026 06:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502513;
	bh=EYsNN9LfvlTSyrm9dnTkOuCDQ1DAekf5be68OsmpIsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KKIQF+w9wQrpvvZtwKA4Vn5VKDndmh0r5dGRX95eLLM/HHWmT6E2jFIYa3HcP3Zbg
	 llvNan1hGvN/02v93oc2VBdg5DerKvM7edJsHBpSN65eFTsqbM16LXaom63m9KtoBl
	 ms3IFJXuj7o+Z6oROUz2cKdndK/0CR8C14HbFIyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 235/403] regulator: as3722_get_regulator_dt_data: fix premature of_node_put leaving dangling of_node pointer
Date: Fri,  4 Sep 2026 07:00:38 +0200
Message-ID: <20260904045740.213022372@linuxfoundation.org>
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

commit f9324d670ae0b88cbfb0aa48fcaefa5baeb8da4c upstream.

In as3722_get_regulator_dt_data(), of_get_child_by_name() acquires a
reference on np, which is then assigned to pdev->dev.of_node. The
function immediately calls of_node_put(np), releasing the reference and
leaving pdev->dev.of_node as a dangling pointer.

Remove the of_node_put(np) call to let the device hold the reference.

Cc: stable@vger.kernel.org
Fixes: bc407334e9a6 ("regulator: as3722: add regulator driver for AMS AS3722")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260626160150.54291-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/as3722-regulator.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/regulator/as3722-regulator.c
+++ b/drivers/regulator/as3722-regulator.c
@@ -600,7 +600,6 @@ static int as3722_get_regulator_dt_data(
 
 	ret = of_regulator_match(&pdev->dev, np, as3722_regulator_matches,
 			ARRAY_SIZE(as3722_regulator_matches));
-	of_node_put(np);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Parsing of regulator node failed: %d\n",
 			ret);


