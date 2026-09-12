Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398D031618C;
	Sat, 12 Sep 2026 15:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227275; cv=none; b=UWewQTqZXum7zHhCdS69BSjJGsb6pbD5t9F3+TaN9+/4VC6f9yMf2Zp89GScxRfa/YdzNYFwD2vutpm3y0AUfJo4rmHPiTulWIG+yn+/+tehoqQLLX833dzihvh3WEU89OQxsmbLJZ8q3ql0WEyx8mIzQnA3BM2CURekBRcRIis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227275; c=relaxed/simple;
	bh=7vHTtoXvwnimYcFZJNse3tcbfsxJbO2DlV0edZK4lSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOK6R8EqpBJwxELR9ufpp9d0lCVR+YEjzswkyxaljfeyoHn0LnATfbmSspopH37bGdZpIySJ22xsCmAXBVXH9UqnG2+5dWpHnocZDK/DBkbdqsFpuS9EzRiEUR3/gDwLqQReOZHYgG8AmeSk9vSiHAN/vBaGSKNErLubPFjCmnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uh0nafLF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uh0nafLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC351F000FF;
	Sat, 12 Sep 2026 15:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227274;
	bh=qHoKZelFQUly62cXQ+EgEVDNODJxYd5ZpUqq4/buCHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uh0nafLF3q5I7VCIKitHMfCTkQSc/Yp6PToaOM25mUVTHIRLGqpq9bjJpUQsYlyCm
	 JikBBnUhnqilg9FAYW7ueMBSxllTdpN5S/YAAJyJ1g4RyFCreteGlI5OU6iAmNkgYU
	 t0eJGe5I+g55poALkAAq431k4y79tbQpUCyc8MPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 0145/1191] regulator: as3722_get_regulator_dt_data: fix premature of_node_put leaving dangling of_node pointer
Date: Sat, 12 Sep 2026 08:47:53 +0200
Message-ID: <20260912065551.458505771@linuxfoundation.org>
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


