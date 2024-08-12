Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBAC130E27;
	Mon, 12 Aug 2024 16:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479192; cv=none; b=A7yGrBMp1LAy+Ojx4h4mOuyhD5ZrStTIipfYD+/kE4ZT/3VIMKTzO1SJkqSH7OXClNdjeX5Ggqid9B6wVoQ/9SkoQLFrcnzG+O7xOgse3v3fATl6Obes6TAdzWY/BUSWDhhcwzjGk0GWcXV1hRpLmp16s3krbBN3s6MjCn/hOto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479192; c=relaxed/simple;
	bh=RBA0MUz+jWK28gtEvXXIZ+nU5fjGTVwV0xuUqLYOKhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYoI+syeTl23G43PBOBRoCCAQStcbbFHcVDVDIESoGK8tZgGSRPH978BnaUuZR02WD4d3ONcViRyN8FelCB91muNbeWWAqf0aB8k+grRJEoijzkdyqk7wkqiYUOmJHjRw9KXQZ69VGWxKKwS20kcpgqJLC8dQyqh/Nyq+LD+HwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=No3N52Eq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="No3N52Eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2125C32782;
	Mon, 12 Aug 2024 16:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479192;
	bh=RBA0MUz+jWK28gtEvXXIZ+nU5fjGTVwV0xuUqLYOKhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=No3N52EqhkBmQhzNw+YZDWP6vguQAh6AUaRO1K1O4/rxX72960cWIu0eGp9anxvui
	 +vb0wxJaMrP/S5ZcruMtW78oDRKiByu1v8sQXVFADdpjCXFQKYm02KeXCSktkr+M5A
	 5FHfEr4tvbMFbuZkZPB9vYAQK/NSg6eW3WeAa+Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/189] wifi: ath12k: fix soft lockup on suspend
Date: Mon, 12 Aug 2024 18:01:07 +0200
Message-ID: <20240812160132.575845385@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit a47f3320bb4ba6714abe8dddb36399367b491358 ]

The ext interrupts are enabled when the firmware has been started, but
this may never happen, for example, if the board configuration file is
missing.

When the system is later suspended, the driver unconditionally tries to
disable interrupts, which results in an irq disable imbalance and causes
the driver to spin indefinitely in napi_synchronize().

Make sure that the interrupts have been enabled before attempting to
disable them.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Cc: stable@vger.kernel.org	# 6.3
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Link: https://patch.msgid.link/20240709073132.9168-1-johan+linaro@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index f27b93c20a349..041a9602f0e15 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -434,7 +434,8 @@ static void __ath12k_pci_ext_irq_disable(struct ath12k_base *ab)
 {
 	int i;
 
-	clear_bit(ATH12K_FLAG_EXT_IRQ_ENABLED, &ab->dev_flags);
+	if (!test_and_clear_bit(ATH12K_FLAG_EXT_IRQ_ENABLED, &ab->dev_flags))
+		return;
 
 	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
-- 
2.43.0



