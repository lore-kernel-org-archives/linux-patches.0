Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6632312B72;
	Tue, 16 Jul 2024 15:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144792; cv=none; b=hON+dat7b+jHbhsZfAsdHyHwwcYbPHmjbJJ4gHFHkZAgNWFNQMC7n3XakbxrMddlxAiB9NPX6v87q8iPJHllet+6ScKVYkzy5jyi6AbHUtcPakN/MU+TaklhmcpnUPkpea6m6bHzzxAP/nRF0beI9LBQygwmbTKu7ycxF4mvPgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144792; c=relaxed/simple;
	bh=H/Ltk/jqQmFVOU8GrDsyNAoOv2s9/6ZSpaHdikcdmjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhENrERaDPr1vHLccGFYb1MCqXEp6XqKd4H/+EDv5iI9pCPwk6vROM3+XAPx915vjrXZ2hIHstVQalw3NH8ausV0r9djLHkLhW8ZlcOIiJatxNPU6A2XC8Bj9+hlA5DfCZhGbY99P7l2hpJ5NLWoZga0tbfXgzW2MiTIy86+s94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYo8zrBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYo8zrBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8C3C116B1;
	Tue, 16 Jul 2024 15:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144792;
	bh=H/Ltk/jqQmFVOU8GrDsyNAoOv2s9/6ZSpaHdikcdmjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYo8zrBNDqXmjiGarvP1ierpzpKcd/WgNpVNzmqO8MgHAZ+KzFfaONJKR0/vaC+HY
	 TQ6Vw6PCmbi17KVbdI/8IkSAP91UE2g0iYBhLIo0uJPS8wo69l3CGlIYPaPafwcet0
	 /mmI+ulrF4k07QpqB7TNhZMXAph1mIMqUmbS3MnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.10 108/108] i2c: rcar: fix error code in probe()
Date: Tue, 16 Jul 2024 17:32:03 +0200
Message-ID: <20240716152750.144415781@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 37a672be3ae357a0f87fbc00897fa7fcb3d7d782 upstream.

Return an error code if devm_reset_control_get_exclusive() fails.
The current code returns success.

Fixes: 0e864b552b23 ("i2c: rcar: reset controller is mandatory for Gen3+")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-rcar.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -1034,8 +1034,10 @@ static int rcar_i2c_probe(struct platfor
 	/* R-Car Gen3+ needs a reset before every transfer */
 	if (priv->devtype >= I2C_RCAR_GEN3) {
 		priv->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
-		if (IS_ERR(priv->rstc))
+		if (IS_ERR(priv->rstc)) {
+			ret = PTR_ERR(priv->rstc);
 			goto out_pm_put;
+		}
 
 		ret = reset_control_status(priv->rstc);
 		if (ret < 0)


