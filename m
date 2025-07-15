Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C1027470;
	Tue, 15 Jul 2025 13:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585492; cv=none; b=edACGjLnkmA6dB1ZUFEgsoCJA4uNyfLgLgAZEuQ4fadeeTv3gxFHhuqWQ+nG3GjMyuyf+9py6g158gu4EXMRozb+O+zuN7mvU/lyjs8MQetBZjsk3h/2opfdTsgEF1y1heawhqCB84baxNP7ySQpIPVTqUPmrqYDEgGWXKMLfUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585492; c=relaxed/simple;
	bh=l8KUcjpLMaQZmsi/wbRAraGQYh7eu8t+ab3CRQGy6uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rxib7e8kExDlKT+uhT51gZ5WXs13AWLxf5fxwl1+S0WmzIhHXD03YnP8YlAWzI7+sT5wJnOiNdZY5V2mT+w0gTcnxdADTPnzRCwOJSTrLiyuNsRpJMjyThzY5pBm/+DHBnyRMI+XB23Y73Ky0f5ISljQOL07O7HMkFd7MlzbkY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjsKwVI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjsKwVI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F95C4CEE3;
	Tue, 15 Jul 2025 13:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585492;
	bh=l8KUcjpLMaQZmsi/wbRAraGQYh7eu8t+ab3CRQGy6uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjsKwVI/S0khIzKYUCgpvu4hoVtPaVU0E/DgLH053xfKw+qqYkXIXwEqc18Y7H1pH
	 SEB6j/cG6upvIKBsqYesEaBvzbZgWYDmb7l5HXE4Admfts2wFcwRjcql+Nupi6zJAh
	 0chhBrYZ9FHnuvkXFgONZZAi55aqyCj6Zp7pnaw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 061/163] net: ethernet: rtsn: Fix a null pointer dereference in rtsn_probe()
Date: Tue, 15 Jul 2025 15:12:09 +0200
Message-ID: <20250715130811.200747946@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 95a234f6affbf51f06338383537ab80d637bb785 upstream.

Add check for the return value of rcar_gen4_ptp_alloc()
to prevent potential null pointer dereference.

Fixes: b0d3969d2b4d ("net: ethernet: rtsn: Add support for Renesas Ethernet-TSN")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://patch.msgid.link/20250703100109.2541018-1-haoxiang_li2024@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/renesas/rtsn.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/renesas/rtsn.c b/drivers/net/ethernet/renesas/rtsn.c
index 6b3f7fca8d15..05c4b6c8c9c3 100644
--- a/drivers/net/ethernet/renesas/rtsn.c
+++ b/drivers/net/ethernet/renesas/rtsn.c
@@ -1259,7 +1259,12 @@ static int rtsn_probe(struct platform_device *pdev)
 	priv = netdev_priv(ndev);
 	priv->pdev = pdev;
 	priv->ndev = ndev;
+
 	priv->ptp_priv = rcar_gen4_ptp_alloc(pdev);
+	if (!priv->ptp_priv) {
+		ret = -ENOMEM;
+		goto error_free;
+	}
 
 	spin_lock_init(&priv->lock);
 	platform_set_drvdata(pdev, priv);
-- 
2.50.1



