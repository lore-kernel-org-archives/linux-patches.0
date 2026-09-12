Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D315486424;
	Sat, 12 Sep 2026 18:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236908; cv=none; b=YF6Am2aD5fWF5WWm/VdGORYwfuWRbTBOduI48uvX4bP+KVB8RPLy5yjsb2Yh9wVLKcyeCftqAguK1hqZVDWsLL+ISae2TqrRPy16pnQQ17WszbbieVm9ZF6Ur1xNveBGc8SP0p+76YepkArSC/10gPPZtOxRMXeTrUOqA49jG4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236908; c=relaxed/simple;
	bh=rfUkF/OHIoH/PmhuLbqzTvck+jwDSq5VzHKtMWayDak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDAufyQGQnf4MNOKNHKI+xEnULUPj5Qqvg39RrlJnECQlukmJ6vASD3SPBpyLMn4xNoxobxkNBB9jc8jN/MYF0Fo3ZEOzaadFw9MDgCgdBL8FrPrzh7F6gg6W+sYXU4D1Oh5BCm3ElCNLGICoO639BqRjzFlrI2Eqja+JcMlANE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Owlyirxb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Owlyirxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55BB1F000FF;
	Sat, 12 Sep 2026 18:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789236906;
	bh=IckOC7w8Ed4aEZwJb+ajprJ0qrNtoSHzp/2yht9uuBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Owlyirxb+fV+n7/PwWUWvIyco3XuWLlIaBbDU5o/QdGumeNjicxhhFRWOD7u8+O8/
	 9ykl57HcGPyCN4pqqr/Xb4ktXYvIhywzqUnjVrxoNjwLgDKbe506j0axQ4BXHOvDqE
	 R1N15AAdxOqSiGNPlTMabWZBK486euZUQJBYpbt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 124/935] regulator: as3722_get_regulator_dt_data: fix premature of_node_put leaving dangling of_node pointer
Date: Sat, 12 Sep 2026 08:52:34 +0200
Message-ID: <20260912065529.667927709@linuxfoundation.org>
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


