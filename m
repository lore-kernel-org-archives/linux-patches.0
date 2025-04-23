Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4911027F73E;
	Wed, 23 Apr 2025 15:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420577; cv=none; b=CUCVzExQLF8aHpl7O8y1e2wbiRhPj4aQLfSuqMhBM40u2acoEkWFHy/Eje5/L9l/UHnXfzIoMCLUoYuuo1/oF1BiNyBeYFQHw/sInfZCDstSw6BQ++1IplDUIv3jbBz/+mwW63WJAi6Q6kn3XjAvQh9EAoAcIfUNthNPIOPYLBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420577; c=relaxed/simple;
	bh=XgNOuZlujB1E9Qx8hkvikJMFpfo8Yo8h/7gO5oWgpVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZRAuzmgf6OLCCxIBANw9H+VcFth9gSCPNiVnipMtloUX2Qyv5O9EqEWwk4R0uqLK+CzBkP+LU2XUR8PUa9pxSk37PdFInzgHss2HdUtDJT0AtS6VelrSixoqfAEOFi2xn67IUjUSGHdT0iwMNpJe3y40AvMPUK6KxdFGnZS02k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYLwk/04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYLwk/04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB39C4CEE2;
	Wed, 23 Apr 2025 15:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420577;
	bh=XgNOuZlujB1E9Qx8hkvikJMFpfo8Yo8h/7gO5oWgpVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYLwk/04/PsT5GOkjU6EEi/3BVelGOD70+Ow+V38u8x2jVQDSXkRkml7/jlr60jXj
	 4qXyuPoNpbWuZj05/6jGEO57CMMZ8gbYBTH7mm/epEvKHjUYVEScdsGywyBXAGUIqU
	 DnZhngJL8Aw9jqydxUeY7pGEvIBxRW9U+OwJpisM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/393] Bluetooth: qca: simplify WCN399x NVM loading
Date: Wed, 23 Apr 2025 16:39:46 +0200
Message-ID: <20250423142647.014497887@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 892e2540f008a..5651f40db1736 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -807,6 +807,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		   const char *firmware_name)
 {
 	struct qca_fw_config config = {};
+	const char *variant = "";
 	int err;
 	u8 rom_ver = 0;
 	u32 soc_ver;
@@ -901,13 +902,11 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
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



