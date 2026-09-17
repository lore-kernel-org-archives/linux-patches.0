Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E75F4CDDDD;
	Thu, 17 Sep 2026 15:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659013; cv=none; b=b+YAk311GACBpwnv96qNa13QhwQZtBzMYues33nfeOe84YfobeHrimOMM+xysQr25THN3lVlvjJL5Ccfec/v+WDRvL7dmDaSoyTuVoZGGqRA8tMme1NcOPWqPUNqLIslwydekxs5NVJMhsuQ9JHiHhQFdz1qeYKegfY8ix/UP34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659013; c=relaxed/simple;
	bh=yxQJDXbv20KGMjUOT5ChNOYqizJxTSZ3mQG41Yk3q1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdB3Lt3CAGqrCXiOg1T/G8GG7AU+HC+CYEAMZw9hWN+7/Ehg/wbZ3p6okrayW3qX0xAkg+WPFT4DoA+0w1jVyCzEEyqAecdIf7a664FaS5DD89dK7lIIBOCxJnTrgdZVh8cd144PI02iwnDLOd0KGoKUjShdS9lb7q5uCqVMEuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5ym817V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5ym817V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA231F000FF;
	Thu, 17 Sep 2026 15:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659004;
	bh=aY2BPKDwd+X7YobKAaoszvO+vWf3tdn0BMi7BqOHr6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5ym817VMoXa5O15EdO6l3xoLmvH5Ya6PNOJuL9bBTd5oakpQhar8QSgwhssdjhtl
	 wXk5Z+2PYmUDDGyF7MRxc72DZ6PqCF/YiediJrJh9yERiuZgrWwmyGv5j/sdYWh/Sh
	 +L0Z86N/KIktlslNDxbW3JZgIv6rG8my3Ny6E48A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 110/733] Bluetooth: btintel: bound firmware ID by TLV length
Date: Thu, 17 Sep 2026 16:06:58 +0100
Message-ID: <20260917151353.721246364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ecee50373f566..96a55d5badda1 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -701,7 +701,7 @@ int btintel_parse_version_tlv(struct hci_dev *hdev,
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



