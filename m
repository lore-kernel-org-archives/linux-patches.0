Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C3C15EB0;
	Tue, 23 Jan 2024 00:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969516; cv=none; b=FXbD2F5ilQrWOzbqfgTBH+07J7UTt4QnXFtnGZ1fR5c0OLmaUTsudSWRaKS4ao/GmJFg+vQFr9U+eP3yWe3S5IJqfbYuZqXSwEL5gTgcQ2hm1I18nF+p9HJzy4H/Cm7NWR125NZ2dFQdk1O7tDrtMyMwwZkWvVLWBdBR22yLavU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969516; c=relaxed/simple;
	bh=lbm3RSRAPDbyuxDNzL5+OuEsly4QMTF4mesMamjDZXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsmvy0gi2uRNL7M2Q9HGFUONUeTRXf7pZ8xYiRcIsa+DOkqQMxaSiDsXBJudr8xFXpLtc4T0D10N4wx1QuaSzTqCPc8V5wNXTO6250LMrg2wWVvEaa5hX3mV28nFcegfwjtVFKNYyncRIn0j/vUkzU3eDkM/7L4RVVDd2JYRqsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNm8Iq2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNm8Iq2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3B5C433A6;
	Tue, 23 Jan 2024 00:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969515;
	bh=lbm3RSRAPDbyuxDNzL5+OuEsly4QMTF4mesMamjDZXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNm8Iq2sejnGUV2eBvJUKsKtUEI0Jf4tAKiCabtw+hwOtjblJmxcSr5J0sCgbFwei
	 w+u6j4/h6KM/jSe2PTm1mUinceHAT1Pt9Tsgnq05e3+dJOOctobuwINSwQk7oNx0rI
	 ge+SxiNUx9H1Xj8BhN+Xjd9MkylPfsnzRi6qWsaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 298/641] drm/bridge: tc358767: Fix return value on error case
Date: Mon, 22 Jan 2024 15:53:22 -0800
Message-ID: <20240122235827.233565195@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index ef2e373606ba..615cc8f950d7 100644
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



