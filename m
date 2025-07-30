Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49C4292B42;
	Wed, 30 Jul 2025 09:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868701; cv=none; b=MnxYhPUILzRei7v3U/99F6J9R6ur7HQSIyBM4fOewWCHQqRjY5IqfrXIeSCkp1N1F/0ZnSGD5MNenwb2Ue/gBPnelYV2vd5YCvPYG7nAl+G7ZEMiW/uGMfFZ372zn1qCQ3ctbgYUO1SO4COjwg6yByYdvbEExZrh5BhpWxia1qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868701; c=relaxed/simple;
	bh=790qoejcxB41oWnlBggvLiCZBR81v290+SHcNrej1EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHmPE1qBWZ75DnzLCBmUB38jkUmxtDuPwh5wzfXWf7rVVeEZsG2GuPQYICddiH2gl7q3F4SiTxn9zxtIEwBGbJv0nfCjs0kWlPJ1HactzTjXp6j5jheXlyqXCOV1OB7y/CX6Yp9IXXm1R6UEIW20xoW9pcawFgtnOb2Q4QdxMjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fy/THp6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fy/THp6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4CAC4CEF5;
	Wed, 30 Jul 2025 09:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868701;
	bh=790qoejcxB41oWnlBggvLiCZBR81v290+SHcNrej1EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fy/THp6Kmq+4DzO6U1iZMDpwV/KKrXqYUbOhDNBRop9CN47TK97vBbs5H94l1wrS4
	 9heWQkZ+IvIFMY4PoUSnyMq7ziM3O8JL7Re4upRR1ccaW4LMoZf/ZXSXw9moPnT9Mk
	 alaGBJ/+Ox4e3+J/BFOnJdZ2ZjpIR8CurI5y1crA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 055/117] dpaa2-switch: Fix device reference count leak in MAC endpoint handling
Date: Wed, 30 Jul 2025 11:35:24 +0200
Message-ID: <20250730093235.700386550@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit 96e056ffba912ef18a72177f71956a5b347b5177 upstream.

The fsl_mc_get_endpoint() function uses device_find_child() for
localization, which implicitly calls get_device() to increment the
device's reference count before returning the pointer. However, the
caller dpaa2_switch_port_connect_mac() fails to properly release this
reference in multiple scenarios. We should call put_device() to
decrement reference count properly.

As comment of device_find_child() says, 'NOTE: you will need to drop
the reference with put_device() after use'.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 84cba72956fd ("dpaa2-switch: integrate the MAC endpoint support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250717022309.3339976-3-make24@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1447,12 +1447,19 @@ static int dpaa2_switch_port_connect_mac
 	if (PTR_ERR(dpmac_dev) == -EPROBE_DEFER)
 		return PTR_ERR(dpmac_dev);
 
-	if (IS_ERR(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
+	if (IS_ERR(dpmac_dev))
 		return 0;
 
+	if (dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type) {
+		err = 0;
+		goto out_put_device;
+	}
+
 	mac = kzalloc(sizeof(*mac), GFP_KERNEL);
-	if (!mac)
-		return -ENOMEM;
+	if (!mac) {
+		err = -ENOMEM;
+		goto out_put_device;
+	}
 
 	mac->mc_dev = dpmac_dev;
 	mac->mc_io = port_priv->ethsw_data->mc_io;
@@ -1482,6 +1489,8 @@ err_close_mac:
 	dpaa2_mac_close(mac);
 err_free_mac:
 	kfree(mac);
+out_put_device:
+	put_device(&dpmac_dev->dev);
 	return err;
 }
 


