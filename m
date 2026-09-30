Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEECF3502A8;
	Wed, 30 Sep 2026 19:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795030; cv=none; b=FQB2vRt5U/icsAIf3OMgvfX8dJqCGmRkE5NBIyWqf/i4VLQC+v0xJYqcAM28d4yacNyJ0Se98HKKJi0COpC5BEh8imRp+aWI/cGqz0cXbaRTqtdSiYB2hO4w2FvXs8NiPTXdPHBYetpyFwP98CULKflPYCRirxgOGxt8wZOx0aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795030; c=relaxed/simple;
	bh=S48kIW9DjtA8AJ65CefMU30ZLJvRnEaJuWPF8dm1iuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mfso/VWB5YEjoR0JVp7yJn40BNwgo/c13ff/lELsUvBpHlmCwwrz4lr3kenWJaOhXssHlGQntrXtHUzgZWwAI+rtev0Xb4csnMiEFsHJbWaSeQJQIFGt9wxuj5wCkrMUbLbxyhYC6oB7HdmWWncHzY/j5VmGL9IWZYHtNZu43yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/Xn14wb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/Xn14wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487EA1F000FF;
	Wed, 30 Sep 2026 19:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795028;
	bh=fukaoEX88bXRRZkZUXn00mQF8F3mvq10yMtCA86sohw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/Xn14wbYVNMLk0tIb32GQaHFjph8Q5V+0qNFXSXx+KZ40FS4l6Lwp9yNlowWjRB8
	 +b80m+QUfNwkJqZqiX5zwYT90cqPvFqh6sZEmbmuLnoXBFoY5QO5AYjqHs4cSWk1Bt
	 hs/qD5KnPydxtxvXuTEaLeFwFHk3ZH3X8irVRrjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0416/1193] Bluetooth: btintel: validate version TLV value lengths
Date: Wed, 30 Sep 2026 17:18:20 +0200
Message-ID: <20260930152443.441321506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

[ Upstream commit a086c0892969bf8a0151b0f12bd14a68827c88b2 ]

btintel_parse_version_tlv() verifies that a complete TLV is present in
the response, but it does not ensure that the value is long enough for
the specific TLV type. A short value can therefore cause an
out-of-bounds read through get_unaligned_le16(), get_unaligned_le32(),
or memcpy().

Reject values shorter than the minimum required by each known TLV type.
Also reject responses that do not contain the Command Complete Status
field.

Fixes: 57375beef71a ("Bluetooth: btintel: Add infrastructure to read controller information")
Reviewed-by: Ali Ahmet Memis <ali@iusegentoo.com>
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Tested-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 24c9d7081bc60..d713bbebbc5a5 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -538,12 +538,44 @@ int btintel_version_info_tlv(struct hci_dev *hdev,
 }
 EXPORT_SYMBOL_GPL(btintel_version_info_tlv);
 
+static u8 btintel_version_tlv_min_len(u8 type)
+{
+	switch (type) {
+	case INTEL_TLV_CNVI_TOP:
+	case INTEL_TLV_CNVR_TOP:
+	case INTEL_TLV_CNVI_BT:
+	case INTEL_TLV_CNVR_BT:
+	case INTEL_TLV_BUILD_NUM:
+	case INTEL_TLV_GIT_SHA1:
+		return sizeof(u32);
+	case INTEL_TLV_DEV_REV_ID:
+	case INTEL_TLV_TIME_STAMP:
+		return sizeof(u16);
+	case INTEL_TLV_IMAGE_TYPE:
+	case INTEL_TLV_BUILD_TYPE:
+	case INTEL_TLV_SECURE_BOOT:
+	case INTEL_TLV_OTP_LOCK:
+	case INTEL_TLV_API_LOCK:
+	case INTEL_TLV_DEBUG_LOCK:
+	case INTEL_TLV_LIMITED_CCE:
+	case INTEL_TLV_SBE_TYPE:
+		return sizeof(u8);
+	case INTEL_TLV_MIN_FW:
+		return 3;
+	case INTEL_TLV_OTP_BDADDR:
+		return sizeof(bdaddr_t);
+	default:
+		return 0;
+	}
+}
+
 int btintel_parse_version_tlv(struct hci_dev *hdev,
 			      struct intel_version_tlv *version,
 			      struct sk_buff *skb)
 {
 	/* Consume Command Complete Status field */
-	skb_pull(skb, 1);
+	if (!skb_pull(skb, 1))
+		return -EINVAL;
 
 	/* Event parameters contatin multiple TLVs. Read each of them
 	 * and only keep the required data. Also, it use existing legacy
@@ -563,6 +595,9 @@ int btintel_parse_version_tlv(struct hci_dev *hdev,
 		if (skb->len < tlv->len + sizeof(*tlv))
 			return -EINVAL;
 
+		if (tlv->len < btintel_version_tlv_min_len(tlv->type))
+			return -EINVAL;
+
 		switch (tlv->type) {
 		case INTEL_TLV_CNVI_TOP:
 			version->cnvi_top = get_unaligned_le32(tlv->val);
-- 
2.53.0



