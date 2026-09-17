Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EB94E36E7;
	Thu, 17 Sep 2026 18:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668822; cv=none; b=hX/fxYLuxsKPra+EAg/V4HywzDm1prCGxULdr7+W/gDhckn2wbhdhVzA5/SmkFk3S3RC8x/46TxyWgDObFlXhlRsGXRmQLp5bBlEPmdJL5QoBd3/QB+9p4mNIrAJfEYfqZfEGKOHOq63RtVaqPZo2a/QtWBTcPTZUtCjDVoRA2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668822; c=relaxed/simple;
	bh=nKHj++rvmYHEyVhTw4GbieQrSKGAt/Z5VqWtTkcw230=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMPCUXtf2ECU7DaczJmRCxo6yInEiUhsbNwpAI97dHoMcJ8g8nDxNN8ZHQHIySMS9y5u8ZCZdoF/i7+P9PUxUiXw0eNxH7nHNnLiYjnaS+4gJSMPJAxisjvsYcM1CKFeYO7Z7mXO7XHtu/22ntQKw/DEpIV7mq43YOiRAvnvo4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOF5NXPC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOF5NXPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CAD1F000FF;
	Thu, 17 Sep 2026 18:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668821;
	bh=RyTOVgTnUmmaGKX7vAoqRCG40v+dhmHF9NYXjSiPBsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OOF5NXPCqhEbN3qtJ9kIUs1ltK5x32wGo08Sm42h1WJDtW08wrhKx8vT4cbzaewul
	 UGgVJasQwDl1p4uDl1cPecc9566j7ROoMW71jMHO+Ztiy4Zx9MajkMysg56tX7qZVu
	 1FCFxq56/4+7mmTYuWD9oNqLOunYRsgfZ3fR9zXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0551/1102] Bluetooth: btintel: bound firmware ID by TLV length
Date: Thu, 17 Sep 2026 16:08:14 +0100
Message-ID: <20260917151553.674747127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

[ Upstream commit ac8aa9e0ec93a12a60230066f199f49c3b9aac3d ]

The firmware ID is treated as a NUL-terminated string even though the
TLV length is its only boundary. If the value does not contain a NUL
terminator, snprintf() can read beyond the received response.

Limit the conversion to the advertised TLV value length.

Fixes: 164c62f958f8 ("Bluetooth: btintel: Add firmware ID to firmware name")
Reviewed-by: Ali Ahmet Memis <ali@iusegentoo.com>
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Tested-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 0efc2d9e787fc..daec8a65c4915 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -677,7 +677,7 @@ int btintel_parse_version_tlv(struct hci_dev *hdev,
 			break;
 		case INTEL_TLV_FW_ID:
 			snprintf(version->fw_id, sizeof(version->fw_id),
-				 "%s", tlv->val);
+				 "%.*s", tlv->len, tlv->val);
 			break;
 		default:
 			/* Ignore rest of information */
-- 
2.53.0



