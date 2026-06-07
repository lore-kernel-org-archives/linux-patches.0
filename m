Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FFA1E98EF;
	Sun,  7 Jun 2026 10:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827234; cv=none; b=i8AoMA3vRJXLoz2eOGhIkgdiPCF6A/9qrcys7WeRuM4gCxloqYx/w8Ec/a2lQmQ3v5gazkOEM8rgQ7qP7W8raed0X146FPuyiNc6SQj/P33w9ABWkLkqa13fvxqKeIvWbLJdziiIa2hZr9EZ1oroiC7jygKChVrFtEj6QTdZlU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827234; c=relaxed/simple;
	bh=f7iwDK3B9rJmUhryJiS/flJyCyzbm+IDCFEdpOuctyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ET/rRbnO+Z9HY6iqAFyfL5oPwpQUQfXtXgMlvEh2DisD3d0+lsN/1tWOEf0SqxJMg1SzhqyFdIsGMoYRQyE12cvwQBgaqkuE5Ydf9ItEGLuhG7LswogmOCc3JpeWhR00uFRy3E27Bny3bPv8MDDppxrC3YxOLCC9HfTb4eudUrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0Or7Dfx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0Or7Dfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538FF1F00893;
	Sun,  7 Jun 2026 10:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827233;
	bh=Rq5WnarWHoJ34h52TC0XsdW80GOlRNFo5rLDb1BKH1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W0Or7DfxVcEWQqxPMbUHfzMafbM6Q3QohIzoAq8/whBtyL3Saopn6yUKk/Jcro54m
	 GGkduqF3J+Sh9aVR8DcVXPy35ldIAuQtJkWQ5CLbcUzeNlV9fyGb5VeZTNc4BqhyIS
	 QPWEby+B9CCwbMtPy1StfryRwk3VPRlha8YJ9zQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 052/315] ethtool: cmis: validate fw->size against start_cmd_payload_size
Date: Sun,  7 Jun 2026 11:57:19 +0200
Message-ID: <20260607095729.510130377@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 16190c97e1f78c..291d04d2776a5c 100644
--- a/net/ethtool/cmis_fw_update.c
+++ b/net/ethtool/cmis_fw_update.c
@@ -130,6 +130,14 @@ cmis_fw_update_start_download(struct ethtool_cmis_cdb *cdb,
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



