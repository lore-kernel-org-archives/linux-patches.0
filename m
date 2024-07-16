Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFD01DDCE;
	Tue, 16 Jul 2024 16:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146370; cv=none; b=UqHPv8TfFS8nM+zEKK+n1tVKfcNqb7BjOq8E8KhDzikkQzikzPQbuBKDZIeTdnTP/ADOKTgmiyPkhy8Ky4wpgGm2SHJe9F1/zS83rJR4bXoReXYfLsN5oBtMJZ1KbdSz+w8wCT2t8JOk0WtYH5+BnFQzNdRqMkcQwmxthR8lja8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146370; c=relaxed/simple;
	bh=smD16ZXdtFdHpeFbQwrtxQHss9oWLYmXHlUUY4I8byg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eg/35KWFFpH0hgeAa8rsI01mrym8DcSJ1rEgTyb4wFZ5pKLrYQ3yMShFJww0NicTEgGRXXBCI7mxdrgnOoTai0ISoEzt26qdttlc9XMGhQbN8MCXiA4G+/Scrjpd2zkt4ev+PbBZpvl9Z857TCjYeeZ2NagfB4+EHnZgXHP5tPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ezt072aR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ezt072aR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA5EC116B1;
	Tue, 16 Jul 2024 16:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146369;
	bh=smD16ZXdtFdHpeFbQwrtxQHss9oWLYmXHlUUY4I8byg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ezt072aRt7P/4CDD7rQfO39XlM1XtHJDhp2A9zvN/rI+s0aytMv/nx9s0O6dKgzKJ
	 I1HWsMoGo9FIiNdPhBrWJmkvdKvgxq557RLUT/4tX4yB6f3QVi8cMeFjv6VYI01LTA
	 2XqFCW6/Q+/Ea0/7vJuEz2axCRzBrCrsCuIozTww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 144/144] i2c: rcar: fix error code in probe()
Date: Tue, 16 Jul 2024 17:33:33 +0200
Message-ID: <20240716152758.042335378@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1105,8 +1105,10 @@ static int rcar_i2c_probe(struct platfor
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


