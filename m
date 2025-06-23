Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49991EEA3C;
	Mon, 23 Jun 2025 21:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715400; cv=none; b=eTYtlra/dimW9wlJPFQaXZOCOG29Uj0/tZl61TgZ37xlZ/HzhtmI3z5FASah0yEi5urJfjJCVr2drm6trawO4CwkR/nCDNJKbqnZPx4fhm9oeawJ/vAuR4DYtT75ukTL0oUJEWC7b1VBCXMr9IVZVmJaaYdy2RSMtXJVTsqe3vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715400; c=relaxed/simple;
	bh=BCQ79AzOfs3Nq9LVzCOVTcGDChuKE4u/1fHC0XEmrZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gp0KrOq8VU1bLx65Y94errS+lL6lMtamvuUg0kwpOhXKiWT6Z7B9v9x1rN6sAkHWd2iQehmckUcXVLFMyqvWvOkpdlvu9QokljXOp3Lf7Ay0iuHx9CvRCBa5o1XfzOPgenaY4kIn5LIG2D40xcLoci6dHRvtnmYI/elk9Ct2PYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GlHcztL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GlHcztL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71907C4CEEA;
	Mon, 23 Jun 2025 21:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715398;
	bh=BCQ79AzOfs3Nq9LVzCOVTcGDChuKE4u/1fHC0XEmrZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GlHcztL3DdT6u6kmvQdxbHk2QFrUEZ6TEwx9Jd33UJ2lhFeZvTeUvCRUlU96xghcz
	 T82FDmdoxbundoi+QPXpplmAKt7Kf2DqiQNEd7o/QcplcuV6MqCugUZ4mbyz56vNhd
	 fe9kgdJJohUdgLBdaCMAy+SPB0OZdCR7gFbwQKgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 250/411] regulator: max14577: Add error check for max14577_read_reg()
Date: Mon, 23 Jun 2025 15:06:34 +0200
Message-ID: <20250623130639.942140059@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 65271f868cb1dca709ff69e45939bbef8d6d0b70 upstream.

The function max14577_reg_get_current_limit() calls the function
max14577_read_reg(), but does not check its return value. A proper
implementation can be found in max14577_get_online().

Add a error check for the max14577_read_reg() and return error code
if the function fails.

Fixes: b0902bbeb768 ("regulator: max14577: Add regulator driver for Maxim 14577")
Cc: stable@vger.kernel.org # v3.14
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20250526025627.407-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/max14577-regulator.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/regulator/max14577-regulator.c
+++ b/drivers/regulator/max14577-regulator.c
@@ -40,11 +40,14 @@ static int max14577_reg_get_current_limi
 	struct max14577 *max14577 = rdev_get_drvdata(rdev);
 	const struct maxim_charger_current *limits =
 		&maxim_charger_currents[max14577->dev_type];
+	int ret;
 
 	if (rdev_get_id(rdev) != MAX14577_CHARGER)
 		return -EINVAL;
 
-	max14577_read_reg(rmap, MAX14577_CHG_REG_CHG_CTRL4, &reg_data);
+	ret = max14577_read_reg(rmap, MAX14577_CHG_REG_CHG_CTRL4, &reg_data);
+	if (ret < 0)
+		return ret;
 
 	if ((reg_data & CHGCTRL4_MBCICHWRCL_MASK) == 0)
 		return limits->min;


