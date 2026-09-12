Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171A747C11A;
	Sat, 12 Sep 2026 12:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217151; cv=none; b=SlOXlvdu+Gb9M9MIVzIwY0L/YGNwKwq6XwZsuwHbJiEkbZgjw8Z4Ugd8/S8UImhzp7ZY0wSCK+P5l411XZ67shmdfksxlhCbC341H7JwUuTg+YXjuMmpy5W7PUNue/uhG6AP/kbp59JqdmguFYJLHj3ZjyDFklqvqwxECe04uA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217151; c=relaxed/simple;
	bh=L+0yH+Ge5wyVMpeOJEYQUWW+2i3C8cYrYiASRIZ+/YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6SuAe3P6R2Sl4gwE0K0GGBFMN9TpFpp9qhSDFGRHtJK7rG8Gr/MRhJFPfb0wp983HqfxVe/iNNF2sAkKhf8uHMtDXxxh1zVQnSmXO+UEbguoVpThQpez2Uf6CVkT42H8OQlrTb5+AG9ABi1WejWXSQiCjTl9g4znO/cSdcwFw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPRdOKjv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPRdOKjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA921F000FF;
	Sat, 12 Sep 2026 12:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217150;
	bh=yGifr3KM3dEkU/hMAZczoUx9XZQ1Q403o0zaUmWsUKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPRdOKjvh0Otzime/n0S5/qGBjgci8d4vR8hQmY0pXF5if5saM2WI4kiKDDxCmaH+
	 nGzZ9Zle2kOcwimv0Ry/vqXzKygx/JKhAKrtvhvfZkGrPIsYKodHtrEBiug4nnK2tY
	 t/bFjg6bvq8h8KBv02BYKTgioiTwqBndtv4fd3fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0838/1376] wifi: mt76: mt7915: unlink TWT flow if the MCU rejects the agreement
Date: Sat, 12 Sep 2026 08:54:24 +0200
Message-ID: <20260912065626.226179219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 16a04441eab0dcd4d7126a6f66b370adbf28f96d ]

The flow is added to dev->twt_list before sending the agreement to the
firmware, but the error path leaves it linked while flowid_mask is
never set. The flow slot can then be reused and memset while still on
the list, corrupting twt_list, and station removal leaves a dangling
entry behind that mt7915_mac_twt_sched_list_add() later walks.

Fixes: 3782b69d03e7 ("mt76: mt7915: introduce mt7915_mac_add_twt_setup routine")
Link: https://patch.msgid.link/20260724124813.3961474-17-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index b058a38a88cf2..bd8bd74f0336d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -2371,8 +2371,10 @@ void mt7915_mac_add_twt_setup(struct ieee80211_hw *hw,
 	}
 	flow->tsf = le64_to_cpu(twt_agrt->twt);
 
-	if (mt7915_mcu_twt_agrt_update(dev, msta->vif, flow, MCU_TWT_AGRT_ADD))
+	if (mt7915_mcu_twt_agrt_update(dev, msta->vif, flow, MCU_TWT_AGRT_ADD)) {
+		list_del(&flow->list);
 		goto unlock;
+	}
 
 	setup_cmd = TWT_SETUP_CMD_ACCEPT;
 	dev->twt.table_mask |= BIT(table_id);
-- 
2.53.0



