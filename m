Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3AB222D59;
	Thu, 12 Dec 2024 17:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025582; cv=none; b=U4nde7SLpootMqqYs+nA1Cuf02ABh2M6s92Kzh6UNDVYrEX+ljnGsM2wqru5PI2IBcvrCVCjvojsE4TiUvZEfaaaT1rAtl9xN/m7t02m2SyYvyhLKPuPbs3zwRRDBSfuFlJv1Dnph9S+ZN7JnCYe32+sMnME3pzMpOiQlQ6Q2IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025582; c=relaxed/simple;
	bh=hk4BRVrMEYLqLrLleHPT/HVWT5mcbXplL/rAPwpI9l4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWzbT/HO8AnQQj4sNVSMMpedz37R0Su505FP199RajI6A6h1bkDHQZTQu8/jQ+ZX8ZZ2iZTwqkQfoMIoHioiwdMLfiJxufVZfK19Rb8requNFuCkrHn1NacEAsoW9vpyJU6MiV6h6Hwg3wNjtggtDGaP7DH0G7p2uSq6sEmO9m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrHma+9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrHma+9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6188C4CECE;
	Thu, 12 Dec 2024 17:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025582;
	bh=hk4BRVrMEYLqLrLleHPT/HVWT5mcbXplL/rAPwpI9l4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrHma+9yXsr7J24DZDuf2WSdpCIUsYRbmv4aNlpBU46nVQIx6ZnQgewNXDbMdjp0R
	 xmBipKRNbVgbot+tdD692ZC9UbyvWgzSMLNGz2eJS/ZBuBTsGyq1BNiPQTis1JMxAG
	 Bz5HPFLqDGxxPjA5lVf8S4wbbzyQ/K8mszOYLJII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>
Subject: [PATCH 5.4 218/321] drm/etnaviv: flush shader L1 cache after user commandstream
Date: Thu, 12 Dec 2024 16:02:16 +0100
Message-ID: <20241212144238.590804655@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

commit 4f8dbadef085ab447a01a8d4806a3f629fea05ed upstream.

The shader L1 cache is a writeback cache for shader loads/stores
and thus must be flushed before any BOs backing the shader buffers
are potentially freed.

Cc: stable@vger.kernel.org
Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
@@ -481,7 +481,8 @@ void etnaviv_buffer_queue(struct etnaviv
 	} else {
 		CMD_LOAD_STATE(buffer, VIVS_GL_FLUSH_CACHE,
 				       VIVS_GL_FLUSH_CACHE_DEPTH |
-				       VIVS_GL_FLUSH_CACHE_COLOR);
+				       VIVS_GL_FLUSH_CACHE_COLOR |
+				       VIVS_GL_FLUSH_CACHE_SHADER_L1);
 		if (has_blt) {
 			CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x1);
 			CMD_LOAD_STATE(buffer, VIVS_BLT_SET_COMMAND, 0x1);


