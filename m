Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C527951AED4;
	Thu, 17 Sep 2026 17:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665304; cv=none; b=Aggc3VbJL6tIOfAjTA5okQ1RLW7XgUX38R+wdHlQsb4njW9qmAV/ALB2XNm2Qi6qJhXA8R+IqcHCHkfWkuMJ0tdn6IESSsDjUFSe1SwrZUyG3aF8S1o7ffDi3Gi+nWunnmgtkt5VLHxxJDFZ9wC5o7u9r4az9ruxMDqbtgyvqUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665304; c=relaxed/simple;
	bh=eSQ7wFimI7NzGPofUAo120TfVTQZyk96HPelLcHV6HY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFRaVmdPxyCVWobfX7LdVrnvE9Eibthk7Z570ogxyX45RSC8+sY94z5I9KUZsIs9cb1LjGgs11uxliQYC2dc8oMJMVYYoDcV82RnXalwK3k+8RD3XIbZ1FB9EPIGMG/ArW2SPNanMxpTLe2/HatPGu0qmqQyOB4mVTeWHxZrits=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAGOTGL1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAGOTGL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E92F1F000FF;
	Thu, 17 Sep 2026 17:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665302;
	bh=b6e/zA4q0mIVCndAq/5rXoVDq96lO4B8iSAZLniRXA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GAGOTGL1i5Uv4QHS+7u0a4fmHHBO+gVtKWg0IKq2L053kmq8gA/3DLnowroAUi7wO
	 2x0WyjTtGzPBqiT0Y7uPCLFvYPr309SgHvgcJlJQ9UMO2rulR/QFV8BBqCbuXRJC0d
	 WpRCaOhCSqTPFd5CsDfi1FifTRqsZ0lEJJvAy4w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0661/1250] Bluetooth: btintel: validate version TLV value lengths
Date: Thu, 17 Sep 2026 16:07:36 +0100
Message-ID: <20260917151609.808672673@linuxfoundation.org>
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
index f665682c91b6b..c47d7900b5f79 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -554,12 +554,44 @@ int btintel_version_info_tlv(struct hci_dev *hdev,
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
 
 	/* Event parameters contain multiple TLVs. Read each of them
 	 * and only keep the required data. Also, it use existing legacy
@@ -579,6 +611,9 @@ int btintel_parse_version_tlv(struct hci_dev *hdev,
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



