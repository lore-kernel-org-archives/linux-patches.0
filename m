Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DE12C9D;
	Mon, 23 Jun 2025 21:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713607; cv=none; b=oYbyEsgJUY7YLnwbTDRp1+G/UgVS8zPUSv4zNGmw1wDJBEEwcRFVTAAhNcbA7C4vxb8AiKq6EB3HYfkIvkrDVnmpy46ksxNBk/UH+SnB0fiZ9iEXoAzy4HvNW46u9KB1Mqux9BL54wYBriaBWDbha6svQUsvmTPnxnLcD0Lx1TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713607; c=relaxed/simple;
	bh=ek1IFE7FeHGyDqI1nixQRzN8W5C/tc1sfYHel/k7IMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pi9I6aPuH46kZH13scD6pxeu88pVAZveeydVB9NfpI+yl5qE8IjN7cmnzohooPzTBQDiUrSIccTUuoTUomABvoB7N4tu9pub1yLQ4kLrWpI0qMjj8JcOvU4tiFNsvy7328M6StC3tz01TyQNdQlhGD3vq82n7oG2Ni6vnMzYR0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3CkJeSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3CkJeSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9E3C4CEEA;
	Mon, 23 Jun 2025 21:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713606;
	bh=ek1IFE7FeHGyDqI1nixQRzN8W5C/tc1sfYHel/k7IMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3CkJeSBnzNAEMRuBTxnqek3BZErTbrc9tSZ4UUVQ+oXHdeWBSVT+RUb6yP7SPHhw
	 vpPFltExq6BvpBi0yUrrpnmvsgMvxVWg7uJIkwIKKKnQrqpa+e8BsSJ8fd1EwqUIbS
	 8CJMqXWhLrGShXR99muHvr1dA38VEM8UQ6KEMS+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 053/414] media: gspca: Add error handling for stv06xx_read_sensor()
Date: Mon, 23 Jun 2025 15:03:10 +0200
Message-ID: <20250623130643.380617385@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 398a1b33f1479af35ca915c5efc9b00d6204f8fa upstream.

In hdcs_init(), the return value of stv06xx_read_sensor() needs to be
checked. A proper implementation can be found in vv6410_dump(). Add a
check in loop condition and propergate error code to fix this issue.

Fixes: 4c98834addfe ("V4L/DVB (10048): gspca - stv06xx: New subdriver.")
Cc: stable@vger.kernel.org # v2.6+
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c
@@ -520,12 +520,13 @@ static int hdcs_init(struct sd *sd)
 static int hdcs_dump(struct sd *sd)
 {
 	u16 reg, val;
+	int err = 0;
 
 	pr_info("Dumping sensor registers:\n");
 
-	for (reg = HDCS_IDENT; reg <= HDCS_ROWEXPH; reg++) {
-		stv06xx_read_sensor(sd, reg, &val);
+	for (reg = HDCS_IDENT; reg <= HDCS_ROWEXPH && !err; reg++) {
+		err = stv06xx_read_sensor(sd, reg, &val);
 		pr_info("reg 0x%02x = 0x%02x\n", reg, val);
 	}
-	return 0;
+	return (err < 0) ? err : 0;
 }


