Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B24B27CB12;
	Wed, 23 Apr 2025 15:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420495; cv=none; b=fj8zbKDFLFbD4CeenjkaBnTMOqmh/owx665YhJOhBuYy5kx9S+Z/NCAwzHh5gnsfeB+oN3cNbVjs+pU/u8GVMQxkuPXuWKpX+QnQtoM4Q+h0oBDg40I6hGJSv5Mo8HyT6Af57SQ/j7fYG0WyPiy4Bq31NnIx8JZ+fZqG361rpFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420495; c=relaxed/simple;
	bh=fFyRXWEhV1odPhixUuv+JTA4avgIyjPVqvD8vQU7/JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXkI1DV9+Ljz0mJTAQEzPmlJmCOAQ93q85W61nw+M8yvToMCmODMCGLfr9YeWyeLfQGn0YHgdxS1b49YtBZc/xfdQHqvxMrKx4zGHCy1xCJYROlc+qlfgrRFZaTzay1uL61Yly3ceqKbuVJ24O7wh4SgE2STL3PW6tBY+8Ij6Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tlp0TUxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tlp0TUxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8F4C4CEE2;
	Wed, 23 Apr 2025 15:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420495;
	bh=fFyRXWEhV1odPhixUuv+JTA4avgIyjPVqvD8vQU7/JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tlp0TUxvAEVYUOUxCaWOcPOIIagjwuDbm/q3tDLZC64ZwFUPY1rKSVh4fNnl6zfY7
	 noNnhl5/T/8M+HlZRQ7l+NSSJyqparjsEpOlZ9XOQlSgBBvLy9j0A0l/+HxMAXRKnz
	 SV9VpFI7ezzHMzXPVN+MPnJf6PpujB6cPzpfDfB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/291] Bluetooth: qca: simplify WCN399x NVM loading
Date: Wed, 23 Apr 2025 16:40:41 +0200
Message-ID: <20250423142626.511946882@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



