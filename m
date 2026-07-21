Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B16C3E7141;
	Tue, 21 Jul 2026 17:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655125; cv=none; b=uwqgerMam/UG0fOFej3jdsYTaxgc7XQ0rX5uFpO0TXgXaNsoNZdbKP+jOck48W+QcZRy9flHFxRJepbpzXIAYotuxU7R7mxPwC0/ux6aQ0Eebl14VEkQpgrvSGW9nXAbpvpWV280x0jVlSNbWC3Ui/KGqqKLKmOjK0gy2s1xcZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655125; c=relaxed/simple;
	bh=U1urTXeyh87jT26A7pznYrch2fbmmA6QTDrrGLU8/I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWuL8WxGFn8xBbTeDC6PhIg1XexKJrcsFr95MNk+aMX0ss22MPk9uMhT6fRj0PFv5rZGavTKOKjrGPsi0E/E85i+3A+yq048lyKHf3CTIrT2x0YEkj4rlQ13vgZZhL3h2MIFuDiC+wh+Zv1Vu9EQb0GYwLcYB1VJZzUCXRAOaZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKOk3lWu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKOk3lWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7FF1F000E9;
	Tue, 21 Jul 2026 17:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655124;
	bh=A5cfxNXp5/opBpn27JJBMzvnH3a+OgVo6nRQpLfZYbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cKOk3lWuHQd250Y299FcStG1qJHhRLzhIYjwtzMJXY7vRMSTfzbPKKkGOGp9p5cDR
	 WJEtO/pSGK6/LO4g2/2t5Tr9yczLQs+erop4He9sn7dnX9I63qf9aQS1MPGZN0xQJV
	 URt82NWFTNZuS5dpX3Vr+GM3PC8ndG0u87MtzlwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1965/2077] net: ipa: fix SMEM state handle leaks in SMP2P init
Date: Tue, 21 Jul 2026 17:27:18 +0200
Message-ID: <20260721152639.053188414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 96ca1e658ae459276292bd6d971ab5d8c7e0379a upstream.

ipa_smp2p_init() acquires two Qualcomm SMEM state handles with
qcom_smem_state_get(). However, neither the init error paths
nor ipa_smp2p_exit() release them.

Release both handles with qcom_smem_state_put() in the init
error paths and in ipa_smp2p_exit().

Fixes: 530f9216a953 ("soc: qcom: ipa: AP/modem communications")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Alex Elder <elder@riscstar.com>
Link: https://patch.msgid.link/20260624065955.2822765-1-haoxiang_li2024@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_smp2p.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -232,19 +232,27 @@ ipa_smp2p_init(struct ipa *ipa, struct p
 					  &valid_bit);
 	if (IS_ERR(valid_state))
 		return PTR_ERR(valid_state);
-	if (valid_bit >= 32)		/* BITS_PER_U32 */
-		return -EINVAL;
+	if (valid_bit >= 32) {		/* BITS_PER_U32 */
+		ret = -EINVAL;
+		goto err_valid_state_put;
+	}
 
 	enabled_state = qcom_smem_state_get(dev, "ipa-clock-enabled",
 					    &enabled_bit);
-	if (IS_ERR(enabled_state))
-		return PTR_ERR(enabled_state);
-	if (enabled_bit >= 32)		/* BITS_PER_U32 */
-		return -EINVAL;
+	if (IS_ERR(enabled_state)) {
+		ret = PTR_ERR(enabled_state);
+		goto err_valid_state_put;
+	}
+	if (enabled_bit >= 32) {		/* BITS_PER_U32 */
+		ret = -EINVAL;
+		goto err_enabled_state_put;
+	}
 
 	smp2p = kzalloc_obj(*smp2p);
-	if (!smp2p)
-		return -ENOMEM;
+	if (!smp2p) {
+		ret = -ENOMEM;
+		goto err_enabled_state_put;
+	}
 
 	smp2p->ipa = ipa;
 
@@ -289,6 +297,10 @@ err_null_smp2p:
 	ipa->smp2p = NULL;
 	mutex_destroy(&smp2p->mutex);
 	kfree(smp2p);
+err_enabled_state_put:
+	qcom_smem_state_put(enabled_state);
+err_valid_state_put:
+	qcom_smem_state_put(valid_state);
 
 	return ret;
 }
@@ -305,6 +317,8 @@ void ipa_smp2p_exit(struct ipa *ipa)
 	ipa_smp2p_power_release(ipa);
 	ipa->smp2p = NULL;
 	mutex_destroy(&smp2p->mutex);
+	qcom_smem_state_put(smp2p->enabled_state);
+	qcom_smem_state_put(smp2p->valid_state);
 	kfree(smp2p);
 }
 


