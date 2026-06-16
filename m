Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19935477E21;
	Tue, 16 Jun 2026 16:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627607; cv=none; b=KtvJBZ1c6jOm2DdIZ/8zEkulsV7RIM2RGLeRA6gX5jmijPd5p/rkQFAf34DCxU8zo9AUF9bxPiISliRhMjJ9b48vs2AZfeFMLOUjimMSb2xF5GxI/5XHzNpH3L1XNunj7fQn7B7nEPHJgDkqXDHHMwbzEQ2AA6MC03dy43EVf2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627607; c=relaxed/simple;
	bh=Yjo2enGuRr6RcTAx1iPZHXWmZ4Nh9G3BvYcktiU3wkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q35KFve0p75OLnrCmDoGHZnSamtW1xiC3DKzxGtZN5n/9dTm/Uu6pfbhU3iq6zhYenLosPqq7cHl2zr8dDUDGcqPSs8ZA1IM1HbM4v8X4/tloib05lXM7KWYimUpV6wzd1EjZ91gWKcjHwFjN5r+gL76k0e9q3HpK4uKDicaIWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8CGWUiy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8CGWUiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2C01F000E9;
	Tue, 16 Jun 2026 16:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627605;
	bh=uM7EzihgF9WgLL0EdGuxKoU+1EaHoKHYN3XCKU/AcUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8CGWUiyDqNJ9pkQxIQTqQcHPuVY6BwyEj2XBJ1YvN39PlXez92UbOSen9THcZ5us
	 L/RL6EdQmxCcCrEXy/QwC3Jx8NmXCWLq4Yugkk+jfGbXwHUwhy/cI6SRmSFSdlq8Jr
	 jTsV5d8GeELrLojOPPSv9Alau56C5XGNX5hjz0PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 197/261] pmdomain: imx: fix OF node refcount
Date: Tue, 16 Jun 2026 20:30:35 +0530
Message-ID: <20260616145054.187863809@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit fba0510cd62666951dcc0221527edc0c47ae6599 upstream.

for_each_child_of_node_scoped() decrements the reference count of the
nod after each iteration. Assigning it without incrementing the refcount
to a dynamically allocated platform device will result in a double put
in platform_device_release(). Add the missing call to of_node_get().

Cc: stable@vger.kernel.org
Fixes: 3e4d109ee8fc ("pmdomain: imx: gpc: Simplify with scoped for each OF child loop")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/gpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/imx/gpc.c
+++ b/drivers/pmdomain/imx/gpc.c
@@ -488,7 +488,7 @@ static int imx_gpc_probe(struct platform
 			domain->ipg_rate_mhz = ipg_rate_mhz;
 
 			pd_pdev->dev.parent = &pdev->dev;
-			pd_pdev->dev.of_node = np;
+			pd_pdev->dev.of_node = of_node_get(np);
 			pd_pdev->dev.fwnode = of_fwnode_handle(np);
 
 			ret = platform_device_add(pd_pdev);


