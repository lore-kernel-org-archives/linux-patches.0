Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EB94071DA;
	Sun,  7 Jun 2026 10:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827468; cv=none; b=ECM7fZhGpbDKGsW/UBtFgf1p3D1qRWV94lvtpp4GnSME2pKhs45ietWKjAnBsZ37sFd/cDRB91UtOWB5sejzQtg93CKkBfZapaiZYlzS+Nf570z0DJFF/Mz6pYTt+bmHon1uOVtJ9xih3ulJecAtOQ9GVSrhAoAhhIYlXN1U7vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827468; c=relaxed/simple;
	bh=1XHbJbuMWNV65pcIfWe8/n+Sg3XS3fcD7UaafVVsrCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3ldm8aHYRpOv6BXZ+Fp3s9tXIDMWzEWQYTh31aJfwOxaNEGyZFqOc+vQIF4+XlYHXX89bPmJTHjOJ4LsSgTTmofTo4vMjU0+U28Mm9UaCTCrO6YZf/NWMqLBzr9pJkgKUetJztlG5CWSWyeHgWeliMGkufhTWmGGaSMGCqjzPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+7cbUwG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+7cbUwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0FD1F00893;
	Sun,  7 Jun 2026 10:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827467;
	bh=jujiWzYpG1Jw5W2dBz89yCW0cAXWuADPXeC0I9stHlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W+7cbUwG8WhP9D0hNFeSsm/Na96qHmb6tztJseV01O8vrJucDIQM9pzhmayDIYnPu
	 pWmqoXHZJVZBMe4nUuEHqQ5d23OihoA9rPeUklEjBTafpRX/K+g3i14VViQvgPyFOB
	 o6RCL/0dB5j+dwSxB9kLR7UaZP4goG5dwgSuQ1fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/307] ethtool: cmis: validate fw->size against start_cmd_payload_size
Date: Sun,  7 Jun 2026 11:57:35 +0200
Message-ID: <20260607095729.869352079@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit d5551f4c1800dc714cec86647bdd651ae0de923e ]

cmis_fw_update_start_download() copies start_cmd_payload_size bytes
from the firmware blob into the CDB LPL vendor_data[] payload without
validating that the FW has enough data.

Since the start_cmd_payload_size can only be ~120B an image too short
is most likely corrupted, so reject it.

Fixes: c4f78134d45c ("ethtool: cmis_fw_update: add a layer for supporting firmware update using CDB")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Link: https://patch.msgid.link/20260522231312.1710836-10-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/cmis_fw_update.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ethtool/cmis_fw_update.c b/net/ethtool/cmis_fw_update.c
index 560bafd4d16864..9c6d9571cf24db 100644
--- a/net/ethtool/cmis_fw_update.c
+++ b/net/ethtool/cmis_fw_update.c
@@ -129,6 +129,14 @@ cmis_fw_update_start_download(struct ethtool_cmis_cdb *cdb,
 	u8 lpl_len;
 	int err;
 
+	if (fw_update->fw->size < vendor_data_size) {
+		ethnl_module_fw_flash_ntf_err(fw_update->dev,
+					      &fw_update->ntf_params,
+					      "Firmware image too small for module's start payload",
+					      NULL);
+		return -EINVAL;
+	}
+
 	pl.image_size = cpu_to_be32(fw_update->fw->size);
 	memcpy(pl.vendor_data, fw_update->fw->data, vendor_data_size);
 
-- 
2.53.0



