Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965CB5D756;
	Tue, 23 Jan 2024 01:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974379; cv=none; b=GMQQmOjFQt4UVRWYA1jZabs1NmNXhfSEme71+oKbssBnFbjZJDIm8GXk4PXI6WqI6NsTFwLpEyzJgvMYHut9ettJGnA+t5rwSKLRBojJTuZNn+hs0yEJONq+Rbxh745FS0WSUH6TkJWUKKnFSB450nu1z+jBasV0I2JBn9dLtKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974379; c=relaxed/simple;
	bh=Qc1uHyfphXvWwaNGdLuTqfXeCfHiO0q+YNyTvOkrrx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eB1fiuwi7JoGack/5NktOu+OuCdMIpkhP5G/9aDkihO7AmmUZ+4WuUaYOY8RoD/GchRGqypYhfHhVzvBVmzsWEsJ90q4cblCJmZk0lFcdaZ5QRUKLeNOEwwilXSqna7kQM37Crl+3Ww/K9gjV3Dz4WYAuElhktM1vheOFVCl6SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeWQaida; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeWQaida"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579C1C43399;
	Tue, 23 Jan 2024 01:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974379;
	bh=Qc1uHyfphXvWwaNGdLuTqfXeCfHiO0q+YNyTvOkrrx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeWQaidarPGWa5NXSIS2EQmWLIMXiJU+wNI0eNCEogkGvN3KqCN5SK7W7/4VtwCJ0
	 wppNJyl+VTswyvcwTlW/cvhM8G7rGKHFLbG5L5X99x4F/9xhiqwRmFlqHPtSz3aOca
	 vX9BvmFuP7hIi5UiGSJWctJC74IoKr0vqXmNdzcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 199/374] drm/bridge: tc358767: Fix return value on error case
Date: Mon, 22 Jan 2024 15:57:35 -0800
Message-ID: <20240122235751.523768567@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 32bd29b619638256c5b75fb021d6d9f12fc4a984 ]

If the hpd_pin is invalid, the driver returns 'ret'. But 'ret' contains
0, instead of an error value.

Return -EINVAL instead.

Fixes: f25ee5017e4f ("drm/bridge: tc358767: add IRQ and HPD support")
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231103-uninit-fixes-v2-4-c22b2444f5f5@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358767.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index 14d671742963..4c6f3052156b 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1633,7 +1633,7 @@ static int tc_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	} else {
 		if (tc->hpd_pin < 0 || tc->hpd_pin > 1) {
 			dev_err(dev, "failed to parse HPD number\n");
-			return ret;
+			return -EINVAL;
 		}
 	}
 
-- 
2.43.0



