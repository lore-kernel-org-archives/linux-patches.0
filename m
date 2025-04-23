Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094DD27933C;
	Wed, 23 Apr 2025 15:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421366; cv=none; b=gK4BiBzfiDTrfW3xY/7bdAk4iIA206JMqneORY8+9E15PmOu4r781VU+V4VZSI6AruupspXMGTQ424UPbfH9fbmuH3VzWhfaF/Wm17VANpCzC0PAKOc2yFPuibgxBxMqDn35/JX8LUHIE9eq4Blla0LJtn1MFyAXrV7OhzAjGCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421366; c=relaxed/simple;
	bh=3q+fmJDooJfW4RXS0uHFOqyjv9LO9CDJL67MYa+ri0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXjU3ag6cCDnJMiWWL6JJpVZe1oCiCfDVKhy/yuvDiNiNkic0B9lRlsNrrzypv/EJOJTC3Vxu1KsUOmOin2tTcB/LmY97wriVob1dsS3+SPbBCYtsOYta8D2BwSxLBtIREChtev/pQw5gwx4k00gkvO3DZTVQOKMMZp1M64O3x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDYjVTNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDYjVTNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A633C4CEE2;
	Wed, 23 Apr 2025 15:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421365;
	bh=3q+fmJDooJfW4RXS0uHFOqyjv9LO9CDJL67MYa+ri0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDYjVTNbhxjtgXK+TjRnlshem076gxv5UDBwHG+Ejv2LcXddSr2GpH+Ke6dtzQCJH
	 MUDVTZU6WKXpw3eydafjV6MAVv9Xm/FviQjjHjBXQu862iIALWSKsQw7Wq94BLjCN9
	 SdOkEny/nplUUaRg/R7+SgtW3jn6PxLh9MCjlWKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Chenyuan Yang <chenyuan0y@gmail.com>
Subject: [PATCH 6.6 172/393] mfd: ene-kb3930: Fix a potential NULL pointer dereference
Date: Wed, 23 Apr 2025 16:41:08 +0200
Message-ID: <20250423142650.485524969@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

commit 4cdf1d2a816a93fa02f7b6b5492dc7f55af2a199 upstream.

The off_gpios could be NULL. Add missing check in the kb3930_probe().
This is similar to the issue fixed in commit b1ba8bcb2d1f
("backlight: hx8357: Fix potential NULL pointer dereference").

This was detected by our static analysis tool.

Cc: stable@vger.kernel.org
Fixes: ede6b2d1dfc0 ("mfd: ene-kb3930: Add driver for ENE KB3930 Embedded Controller")
Suggested-by: Lee Jones <lee@kernel.org>
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://lore.kernel.org/r/20250224233736.1919739-1-chenyuan0y@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/ene-kb3930.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/ene-kb3930.c
+++ b/drivers/mfd/ene-kb3930.c
@@ -162,7 +162,7 @@ static int kb3930_probe(struct i2c_clien
 			devm_gpiod_get_array_optional(dev, "off", GPIOD_IN);
 		if (IS_ERR(ddata->off_gpios))
 			return PTR_ERR(ddata->off_gpios);
-		if (ddata->off_gpios->ndescs < 2) {
+		if (ddata->off_gpios && ddata->off_gpios->ndescs < 2) {
 			dev_err(dev, "invalid off-gpios property\n");
 			return -EINVAL;
 		}


