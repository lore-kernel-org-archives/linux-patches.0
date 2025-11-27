Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAAD260585;
	Thu, 27 Nov 2025 15:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255771; cv=none; b=V/fcRADRFxkw6zF775C8HrmGy5II2jSqo8gtBowxyRAlRa+Lq9owpJ5wF7OehbLEghCwquyL+VxgzkwzNDJcsv8irVeV8rpCjoMHjDv5KwPENcy91QT0sjvAbytCtly+XOLLmvdqTJcCT/g5JN9+nRrUqibBWQI2GrIav/13HIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255771; c=relaxed/simple;
	bh=6Q4wm0iexnL18r79CCH5wSWav79Flago6pXH6c8Olhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuY51bbuCEQ36EIEZpJ1VxtHT1bkoChYvKPixqXJeooGa8Axi1PwxAp3ADuLrojrFoY8mSpbMi6DZiRtj4GMkoJj0q2r3GbGMycirgUreky8LMdEiBjxUlDFLPUujeOGYMKh82XrLdZOuCMAaRib1mwEbpPuv8SQbmjmpLjFRks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1LA0Rm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1LA0Rm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60E2C4CEF8;
	Thu, 27 Nov 2025 15:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255771;
	bh=6Q4wm0iexnL18r79CCH5wSWav79Flago6pXH6c8Olhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1LA0Rm+QjtotKwvLcDq/z2TXxaz3w7eiO0uNQtpPxJeSFWaoaZiy8BDi35gMeKwP
	 i7N2QWdQeIiwJLc0Qey6/6G50xLLKnuR2DoFc+TTCRM1bWxkImXqHjpk62GfFLOiPC
	 PMo/ydX4dA4AYHN/AsemdQBqdCKfdX3oyVLcCSUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 109/175] net: airoha: Do not loopback traffic to GDM2 if it is available on the device
Date: Thu, 27 Nov 2025 15:46:02 +0100
Message-ID: <20251127144046.938562157@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 8e0a754b0836d996802713bbebc87bc1cc17925c ]

Airoha_eth driver forwards offloaded uplink traffic (packets received
on GDM1 and forwarded to GDM{3,4}) to GDM2 in order to apply hw QoS.
This is correct if the device does not support a dedicated GDM2 port.
In this case, in order to enable hw offloading for uplink traffic,
the packets should be sent to GDM{3,4} directly.

Fixes: 9cd451d414f6 ("net: airoha: Add loopback support for GDM2")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251113-airoha-hw-offload-gdm2-fix-v1-1-7e4ca300872f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_ppe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 62e46a8d7e3c8..20e77cdb86d0c 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -281,7 +281,7 @@ static int airoha_ppe_foe_entry_prepare(struct airoha_eth *eth,
 			if (!airoha_is_valid_gdm_port(eth, port))
 				return -EINVAL;
 
-			if (dsa_port >= 0)
+			if (dsa_port >= 0 || eth->ports[1])
 				pse_port = port->id == 4 ? FE_PSE_PORT_GDM4
 							 : port->id;
 			else
-- 
2.51.0



