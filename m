Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28A23D9521;
	Thu, 17 Sep 2026 17:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665307; cv=none; b=DSqZx8Xsb0OBLy3MeOy3KtfHMZH8YjDArbQu/RQhceO1NnShwC44shEXprKGr6owpBqJqZ2fc4FbjlSnZaK+j7gESmcCNnYL0i6nN4uBIAqVh8JOwx9PUoNDoCIEZfiWXx8FNdQUdYit0C2VI6P9IZhaAmO+K2yNccqShSvShp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665307; c=relaxed/simple;
	bh=MdAK7uK5TfQU+1NQOUP5h5NjHYvOtAPIgyoJUMeQa1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ttg/RFG6bN3h/Bl+H8Jlcgwva3quxuVDH7Ze+zZFKrgsmfX1fvrrStFmzq5SrQpIRszigCwUddWNyXBmWs6/mfT2W6KxYQAwtpouUXqp+S6BU0ZhzmbZxnfur0sMKDn0yZudb5WSyFIJGyW92eeX/NOuwoFYATMw3QPOOpbF3k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sbuy+hLz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sbuy+hLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193B21F000FF;
	Thu, 17 Sep 2026 17:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665305;
	bh=WfACYCY5mecvDeFQivmPjDUQ0w60nb2hGnjaLZFKuSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sbuy+hLzKGaKcMBy5sHz+8IHMIy9EHs0oC6AJAqzB8Y8GmJy6EA61mNxl1pQqnWvW
	 o/gcsB75oRJ0xJRXTMb1d4VR/FHwgEZEomNp4jCLe+l5PCDkql1bXN7Z8f/1pNTvma
	 blW5AlMtWkNH2KU27FprIFCMyqGoCRG/FFXX2QB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0662/1250] Bluetooth: btintel: bound firmware ID by TLV length
Date: Thu, 17 Sep 2026 16:07:37 +0100
Message-ID: <20260917151609.835428520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index c47d7900b5f79..0e5c2d3893717 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -685,7 +685,7 @@ int btintel_parse_version_tlv(struct hci_dev *hdev,
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



