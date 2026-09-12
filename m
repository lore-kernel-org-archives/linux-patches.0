Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9462271464;
	Sat, 12 Sep 2026 08:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200396; cv=none; b=ODmye1kIyafOmNtZRN0voAGi42osoZFykH7QmMkwyxH73tRnMudkF5AljWIdFiVgJtsq8pkV/9Ao8FI0tQx41TgP9mY0d4rPhaTxXXEgaWVEfNUu8oTiftf2HKuDS1t1ctCNvSNYFyvbHP9MI64lSDwpQ620pvz6iuf7rFy9d3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200396; c=relaxed/simple;
	bh=51B1tvwpWjjaZNtzjXACuFLt+9s0B6ZMgacPlL1PPAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpUICkJzTGE633liunzBzQ6wAqUv79MJ5P8vOAfnj1kYQo41bv8q8PNUFW3TA7g/W9q4M9/nGx0/TtuOuxP+Va8Nh03jg0sp5rWyX5TwgchbQkOmTm20eH+1Ubwl80ojAjDfsm8wYa3TxXRo/jVQRXzQ07kR3UKiyx2YUgycLTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/w+q5Vn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/w+q5Vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BCB1F000FF;
	Sat, 12 Sep 2026 08:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200394;
	bh=6kXnkfog1vAM8u2fIetQX0Fz/8AgeOvYoV6BhL6tn/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/w+q5Vn9nP6HqLWH9K47s57448M0GVFGQzIGXst2zca8LxyOy9EgAGkvQBXTZ4ey
	 q1tomJUaS1uCt+uI93HyGzm5nmeymWRBtHN4NtWQ3yd8GxLyhf0NOiS3Ylo1CZdnQy
	 hA6jNNdjgJtxym9EChk+SdmR+yOmg4sDEQOZoMEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0774/1815] wifi: ath11k: fix stride mismatch in mac_phy_caps_parse()
Date: Sat, 12 Sep 2026 08:42:04 +0200
Message-ID: <20260912065707.080413965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit 7a246c72132eb943b5844ba79dad597b47429dba ]

Currently, in ath11k_wmi_tlv_mac_phy_caps_parse(), kcalloc() sizes the
mac_phy_caps buffer as tot_phy_id * len, where len is clamped to
min(firmware_len, sizeof(struct wmi_mac_phy_capabilities)). The subsequent
memcpy() destination advances by sizeof(full struct) per slot via C
pointer arithmetic, not by the clamped len. When firmware sends short
TLVs, the second and later slots are written past the end of the
allocation.

The reader in ath11k_pull_mac_phy_cap_svc_ready_ext() also indexes the
buffer with full-struct pointer arithmetic, so the allocation must match
that stride.

Fix by using kzalloc_objs(), which derives the element size from the
pointer type, making allocation size and pointer stride provably
consistent regardless of what len the firmware provides.

Compile tested only.

Fixes: 5b90fc760db5 ("ath11k: fix wmi service ready ext tlv parsing")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260728-mac_phy_caps_parse-stride-mismatch-v1-2-27a9c1a3fbd0@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index ec02c0a089b0d..1575b7faac7d1 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4809,14 +4809,16 @@ static int ath11k_wmi_tlv_mac_phy_caps_parse(struct ath11k_base *soc,
 	if (svc_rdy_ext->n_mac_phy_caps >= svc_rdy_ext->tot_phy_id)
 		return -ENOBUFS;
 
-	len = min_t(u16, len, sizeof(struct wmi_mac_phy_capabilities));
 	if (!svc_rdy_ext->n_mac_phy_caps) {
-		svc_rdy_ext->mac_phy_caps = kcalloc(svc_rdy_ext->tot_phy_id,
-						    len, GFP_ATOMIC);
+		svc_rdy_ext->mac_phy_caps =
+			kzalloc_objs(*svc_rdy_ext->mac_phy_caps,
+				     svc_rdy_ext->tot_phy_id,
+				     GFP_ATOMIC);
 		if (!svc_rdy_ext->mac_phy_caps)
 			return -ENOMEM;
 	}
 
+	len = min_t(u16, len, sizeof(struct wmi_mac_phy_capabilities));
 	memcpy(svc_rdy_ext->mac_phy_caps + svc_rdy_ext->n_mac_phy_caps, ptr, len);
 	svc_rdy_ext->n_mac_phy_caps++;
 	return 0;
-- 
2.53.0



