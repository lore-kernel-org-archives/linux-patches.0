Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F26E2561D7;
	Thu, 17 Apr 2025 18:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915511; cv=none; b=GxkBySggcDtuJZNJoV5fICzYUKEk5ZnLqBqP+M+DEg9aWZcaSm1VbQI1HNjpUmjB6y8Q6fcJpFgWzwIkVVMtTDTsGjXTL3hYCaJBDcuKMARKzvKnoIhrM/5fqHNoAjo4UOoRpZpuc4FmRen0MwdByMO9gWL457Tjhtm+DJ0wDB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915511; c=relaxed/simple;
	bh=B70s7R1kyWKAB7hGOAeS3AI69hcyzDhHxwWxLJtd0ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMeoAQcg1qm1qJxbxGa+rb63X2DUssc4Iwu5NBtjUxv5OvxcGf9Absz3Y8+sFzGuqGFqqzz8DbLnqkraLT7uMmaoiGr54J0T+sYtiUyuIjwUl/EfyvuhtHVDYrPjDMUqIjpS15xbAwoBHVw6aR5pnH3rWSAxWapcWt+63C/IZoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwvrSo/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwvrSo/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871EEC4CEEC;
	Thu, 17 Apr 2025 18:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915510;
	bh=B70s7R1kyWKAB7hGOAeS3AI69hcyzDhHxwWxLJtd0ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwvrSo/fIyetNGviHdv8e1AnGtReVDu2B1goS5f1as3qdO22zfXIr1gUI/75T1Xko
	 WGUnpOQonHn0W8s5LWzT/3Vnhr7Xhf4c/zZOrfixj/3I0j26r/Zslngd7ZobjYLL05
	 viCFxZovsv/QIeaRyBVra5t4OFvDWgkNPPEd7jiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/393] Bluetooth: qca: simplify WCN399x NVM loading
Date: Thu, 17 Apr 2025 19:48:52 +0200
Message-ID: <20250417175112.544185448@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 1cc41b5092e3aa511454ec882c525af311bee631 ]

The WCN399x code has two separate cases for loading the NVM data. In
preparation to adding support for WCN3950, which also requires similar
quirk, split the "variant" to be specified explicitly and merge two
snprintfs into a single one.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 04d02c746ec0f..dd2c0485b9848 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -785,6 +785,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		   const char *firmware_name)
 {
 	struct qca_fw_config config = {};
+	const char *variant = "";
 	int err;
 	u8 rom_ver = 0;
 	u32 soc_ver;
@@ -879,13 +880,11 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		case QCA_WCN3990:
 		case QCA_WCN3991:
 		case QCA_WCN3998:
-			if (le32_to_cpu(ver.soc_id) == QCA_WCN3991_SOC_ID) {
-				snprintf(config.fwname, sizeof(config.fwname),
-					 "qca/crnv%02xu.bin", rom_ver);
-			} else {
-				snprintf(config.fwname, sizeof(config.fwname),
-					 "qca/crnv%02x.bin", rom_ver);
-			}
+			if (le32_to_cpu(ver.soc_id) == QCA_WCN3991_SOC_ID)
+				variant = "u";
+
+			snprintf(config.fwname, sizeof(config.fwname),
+				 "qca/crnv%02x%s.bin", rom_ver, variant);
 			break;
 		case QCA_WCN3988:
 			snprintf(config.fwname, sizeof(config.fwname),
-- 
2.39.5



