Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE4F37D11A;
	Wed, 30 Sep 2026 16:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787549; cv=none; b=LReqEb4qmSol4MQf/LaasWsV+nfe69n/JgghtSGs0PTnD+6nHsuJsTDkMzSCfam/zgM2kJ6+viJcgPgOTiAjUsqhWdehD3GeHndscZjTxZmzv1vy5tNA+AvZO22r+aYbcWLYRk+Ek6dUm0sEZVaENLeYCKoTSiNrcrl3AayGYoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787549; c=relaxed/simple;
	bh=n2ExROFO0TgjNhMdW32L6el8U3RVngnm06vS+A5EhDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuE/imMP86ACNcLpQaUJx3E4YuruKhP6FwkrF4ws1g/QUgfJIBocGQl+kBJkKZAY8yPe13GcGeqQ+ReCENyc1swvA0zwhK/gAgfsw37pkO7d0YA6bYLAzmB0RLOm6Cspo7BsMMPVEyCiGUyHl0YYwIL644x6ip31K4LegY2FgbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sK/gJadG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sK/gJadG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC9A1F000FF;
	Wed, 30 Sep 2026 16:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787548;
	bh=Jjr2zl0KVuLxEdyrdmWKKAfIg93C1FPflbECrv3MSGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sK/gJadG3ZP6Q4cFh/PUgM7NJZTUfY/nLnTd3X9jtxxucdC2AdQPXa5wpCrnPfzQy
	 FsIVsAxL9xsVDk2xvc5ccJXprrcRyQ76VLjLLB9HSdfWLA6OiirfuSYwiYB5xuMxRo
	 yGYWPjX6x0Ya3AiQ/UCLmnmWYGJGUMdA9aE9Fk3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 269/457] gpio: arizona: Fix runtime PM leak in arizona_gpio_direction_out()
Date: Wed, 30 Sep 2026 17:26:14 +0200
Message-ID: <20260930152351.847271815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit e9d810279f84b30738f7790c0ed15f8dd5b9024a upstream.

Switching a persistent GPIO line from input to output acquires a
runtime PM reference on the parent device, but if the subsequent
regmap_update_bits() fails the reference is never dropped and no later
direction_in() can balance it since the direction was never changed.
Drop the reference on the update failure path.

Fixes: 27a49ed17e22 ("gpio: arizona: Add support for GPIOs that need to be maintained")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260916094701.2007509-1-vulab@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-arizona.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-arizona.c
+++ b/drivers/gpio/gpio-arizona.c
@@ -115,8 +115,12 @@ static int arizona_gpio_direction_out(st
 	if (value)
 		value = ARIZONA_GPN_LVL;
 
-	return regmap_update_bits(arizona->regmap, ARIZONA_GPIO1_CTRL + offset,
-				  ARIZONA_GPN_DIR | ARIZONA_GPN_LVL, value);
+	ret = regmap_update_bits(arizona->regmap, ARIZONA_GPIO1_CTRL + offset,
+				 ARIZONA_GPN_DIR | ARIZONA_GPN_LVL, value);
+	if (ret < 0 && (val & ARIZONA_GPN_DIR) && persistent)
+		pm_runtime_put_autosuspend(chip->parent);
+
+	return ret;
 }
 
 static int arizona_gpio_set(struct gpio_chip *chip, unsigned int offset,


