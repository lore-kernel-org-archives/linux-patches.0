Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2884431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319E8C4339B;
	Wed, 15 Mar 2023 12:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883614;
	bh=M6ph/WFijeTmLu7gzaeWiW4dhZ5jP1CaWzsWIYpVE7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qc3x0MzuysGQ7hMveSWjmlW+Rlj15r+GsfkSUMK+LN4Q3sR7G0ttZ/OnJqltEodKT
	 HoZ6TKgaKARwycUPS2EP0W67B3eyk160wQ5zOhldko7IgHNwUm5YbSFCXEdqPOjmXd
	 Ob2vYFC9xmnOzNjWx0tR4SUY++7jg+rMds4epd2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Chen <void0red@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <simon.horman@corigine.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/143] nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties
Date: Wed, 15 Mar 2023 13:12:31 +0100
Message-Id: <20230315115742.507039323@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kang Chen <void0red@gmail.com>

[ Upstream commit 11f180a5d62a51b484e9648f9b310e1bd50b1a57 ]

devm_kmalloc_array may fails, *fw_vsc_cfg might be null and cause
out-of-bounds write in device_property_read_u8_array later.

Fixes: a06347c04c13 ("NFC: Add Intel Fields Peak NFC solution driver")
Signed-off-by: Kang Chen <void0red@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230227093037.907654-1-void0red@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/fdp/i2c.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 2d53e0f88d2f9..1e0f2297f9c66 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -247,6 +247,9 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 					   len, sizeof(**fw_vsc_cfg),
 					   GFP_KERNEL);
 
+		if (!*fw_vsc_cfg)
+			goto alloc_err;
+
 		r = device_property_read_u8_array(dev, FDP_DP_FW_VSC_CFG_NAME,
 						  *fw_vsc_cfg, len);
 
@@ -260,6 +263,7 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 		*fw_vsc_cfg = NULL;
 	}
 
+alloc_err:
 	dev_dbg(dev, "Clock type: %d, clock frequency: %d, VSC: %s",
 		*clock_type, *clock_freq, *fw_vsc_cfg != NULL ? "yes" : "no");
 }
-- 
2.39.2



