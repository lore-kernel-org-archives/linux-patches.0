Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6802DC321;
	Sat, 12 Sep 2026 15:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226566; cv=none; b=ZaB8LjJa+bHB026xN5ia28pEffCXN+zFeNuDpAkYgFMVdkkry+LE/cm3uSgQU5t/0+P83+r27JyDpuBanudWibd6VMUJnNyaKoJqLkNtOKdPE4nPGvRF4a/sVt0KpiWJ/3MfDstzUrBaqRP6UMCdbHUxFZBOZ7PXm/4ty5n5rPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226566; c=relaxed/simple;
	bh=3qzAIjfGkCzVYO1PkO/zkIylPU6pC6CMDPR6s7bdkRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugVqWlRyV8a9GUXeMlqrKG0pWh+Vh4EfpIISP5zZTRevEuu5SxqOpt0xCUVM/LM27AaqWAHzTdjDztkgjfHsuTp4nv3m6hcN47uIURIO7vJriR1M5E4rhArIUmGDF+fd7Vb9/EsA18SLft7SyFju120g2+ueA9+OkXgFpgvtFUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wL2e4HGP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wL2e4HGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839C51F000FF;
	Sat, 12 Sep 2026 15:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226565;
	bh=jHE7fvLXuNvpAV3pAZQRbLiuV9+GrSi52ZvAR19//wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wL2e4HGPlsfR4snxqLbr9GyV9zqqB7vg9POCtjsDqwTzWxSLjgbZkog2nepFbiK9v
	 6YqWvU0cOPqbYOKakWwBknvJp2FSCN17JXSGo0ALrpEBoXEH/ERiVgce8MBMOew8iS
	 7peYK3C2nOYlTMTA437L+aWQneWKXXPuG0PQXVHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1415/1424] wifi: ath11k: Fix error handling in ath11k_wmi_p2p_noa_event()
Date: Sat, 12 Sep 2026 09:04:07 +0200
Message-ID: <20260912065638.947824420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6ef5b4c9598c928b3e2c4c4b543c81331941f136 ]

if (noa_descriptors > WMI_P2P_MAX_NOA_DESCRIPTORS), there is a mix of
return and goto. In such a case, 'td' should be freed to avoid a memory
leak.

While at it, change ath11k_wmi_p2p_noa_event() to return void.
'0' was returned in all cases, even in case of error and the only caller
does not handle the return value.
This is also more consistent with most of functions called from
ath11k_wmi_tlv_op_rx().

Fixes: 2408379f15a1 ("wifi: ath11k: implement handling of P2P NoA event")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/07f1fc75b2d5b4173ae1b7bb1da5be7f6fc608c8.1713212781.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 26ab52107f862..4db48d02a8f34 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -8676,30 +8676,27 @@ static void ath11k_wmi_gtk_offload_status_event(struct ath11k_base *ab,
 	kfree(tb);
 }
 
-static int ath11k_wmi_p2p_noa_event(struct ath11k_base *ab,
-				    struct sk_buff *skb)
+static void ath11k_wmi_p2p_noa_event(struct ath11k_base *ab,
+				     struct sk_buff *skb)
 {
 	const void **tb;
 	const struct wmi_p2p_noa_event *ev;
 	const struct ath11k_wmi_p2p_noa_info *noa;
 	struct ath11k *ar;
-	int ret, vdev_id;
+	int vdev_id;
 	u8 noa_descriptors;
 
 	tb = ath11k_wmi_tlv_parse_alloc(ab, skb, GFP_ATOMIC);
 	if (IS_ERR(tb)) {
-		ret = PTR_ERR(tb);
-		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
-		return ret;
+		ath11k_warn(ab, "failed to parse tlv: %ld\n", PTR_ERR(tb));
+		return;
 	}
 
 	ev = tb[WMI_TAG_P2P_NOA_EVENT];
 	noa = tb[WMI_TAG_P2P_NOA_INFO];
 
-	if (!ev || !noa) {
-		ret = -EPROTO;
+	if (!ev || !noa)
 		goto out;
-	}
 
 	vdev_id = ev->vdev_id;
 	noa_descriptors = u32_get_bits(noa->noa_attr,
@@ -8708,7 +8705,6 @@ static int ath11k_wmi_p2p_noa_event(struct ath11k_base *ab,
 	if (noa_descriptors > WMI_P2P_MAX_NOA_DESCRIPTORS) {
 		ath11k_warn(ab, "invalid descriptor num %d in P2P NoA event\n",
 			    noa_descriptors);
-		return -EINVAL;
 		goto out;
 	}
 
@@ -8721,7 +8717,6 @@ static int ath11k_wmi_p2p_noa_event(struct ath11k_base *ab,
 	if (!ar) {
 		ath11k_warn(ab, "invalid vdev id %d in P2P NoA event\n",
 			    vdev_id);
-		ret = -EINVAL;
 		goto unlock;
 	}
 
@@ -8731,7 +8726,6 @@ static int ath11k_wmi_p2p_noa_event(struct ath11k_base *ab,
 	rcu_read_unlock();
 out:
 	kfree(tb);
-	return 0;
 }
 
 static void ath11k_wmi_tlv_op_rx(struct ath11k_base *ab, struct sk_buff *skb)
-- 
2.53.0



