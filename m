Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB466775D;
	Tue, 23 Jan 2024 02:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975299; cv=none; b=QrxASh80QQjad1R6w2xQdFc0dxdvQZNssESPMymR64BjL6s6IO+zJs10Wd90sEp2ehmC/T1sCRMn4dEc0Y6L+yYqCBgRH0SJ97XzZDUWIXl+t3m+NsuyY/abmCzLlOcSsVeRtIXrumbePlP7YMMQKgmkYpUbf8o4sC5Dt8pn64M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975299; c=relaxed/simple;
	bh=ak7oCgia2TppNiSfqYB42O39BDCMIPSfW3/AEshHf0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGvPfp/C1Ze2T/xB9G/292ZvjaTkYUhpU93GoRXD5sExfyHtjuuzirTw8eASQqne+LscvbmfO9LCjatVth0dmfUhPsRjSOJDCR00v31MtW14HVFRZrT4/rqzkLIClwWkwAIQm2t9EbAUofFNEE301zJ5ge8pLyMpMfVgy9VF5Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWd0N80q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWd0N80q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E42C433C7;
	Tue, 23 Jan 2024 02:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975299;
	bh=ak7oCgia2TppNiSfqYB42O39BDCMIPSfW3/AEshHf0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWd0N80qLQ+RbthUTjouDNj22bMj/bAnZbbnUfcJXWhmJhOE6DfdiCHsDtN6CuMd6
	 Mo4m81dsydUt7QWqrQRx+5zw/A9R8qvkiHeELJ9nOFbT3S1nhFzdstcQD+lN+1VFb0
	 ZhEjuJUw1RMPYF6OJZMqDvI0zcwyVNBgRmvGOjzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 264/583] drm/bridge: tc358767: Fix return value on error case
Date: Mon, 22 Jan 2024 15:55:15 -0800
Message-ID: <20240122235820.085153466@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b45bffab7c81..d941c3a0e611 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -2273,7 +2273,7 @@ static int tc_probe(struct i2c_client *client)
 	} else {
 		if (tc->hpd_pin < 0 || tc->hpd_pin > 1) {
 			dev_err(dev, "failed to parse HPD number\n");
-			return ret;
+			return -EINVAL;
 		}
 	}
 
-- 
2.43.0



