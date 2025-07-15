Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB2D2E041E;
	Tue, 15 Jul 2025 13:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585749; cv=none; b=t/NnUWxfQQKQG+vM7hJ6TofBI6wYDQMX8GwO6TvOcGCS7X7KmBYgRhqYBch0sWaxBINPmfvhSOWe+h1xJ1+18wBidIkNhRE+IGqGN/UoGYuF4bG5IaOR472vyoByfdzEiwiFzVJ7QBAqtxAIuqGeI4ViXVRbtVvMVCRgjsbMsEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585749; c=relaxed/simple;
	bh=4jmm+g81anQBTCqMzfawFKIPIGRVAQ5PfbLtXNzQVG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQ/FUWnf7EGwn5Qi2t+aFUnFkM/Ghxn0MjeK7pOYfvL6H4TPEhNJsmCtN5S/2p7oi755k+O3me3mzcEcdXhOtiYdALOp8wGdpsYK8hBVWv4qup2FYHymo9S1gbJyuEHMYp4XjaIVRJ/zGKlSWCuRAOz7dTOj6oXa/TfBAFcwFhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kqx5fH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kqx5fH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6048C4CEE3;
	Tue, 15 Jul 2025 13:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585749;
	bh=4jmm+g81anQBTCqMzfawFKIPIGRVAQ5PfbLtXNzQVG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kqx5fH+w6TdNI51lvqsvjA72uzBrlA6U8eZlcutO/Adw29mCJAzdDJqe67B6R7Oy
	 izjQ9wHhfFT6Jm1kzwRhIsrYXG1sMHWUOHi8wV/sczVCUTwqD1YQdFSpLYz5RpK8DS
	 IP7EFtKVzsLYJXosLavEETkEol+ANcDDpXZdNr/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenryma@tencent.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/163] wifi: mt76: mt7925: Fix null-ptr-deref in mt7925_thermal_init()
Date: Tue, 15 Jul 2025 15:13:04 +0200
Message-ID: <20250715130813.507099782@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 03ee8f73801a8f46d83dfc2bf73fb9ffa5a21602 ]

devm_kasprintf() returns NULL on error. Currently, mt7925_thermal_init()
does not check for this case, which results in a NULL pointer
dereference.

Add NULL check after devm_kasprintf() to prevent this issue.

Fixes: 396e41a74a88 ("wifi: mt76: mt7925: support temperature sensor")
Signed-off-by: Henry Martin <bsdhenryma@tencent.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20250625124901.1839832-1-bsdhenryma@tencent.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/init.c b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
index 14553dcc61c57..02899320da5c1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
@@ -52,6 +52,8 @@ static int mt7925_thermal_init(struct mt792x_phy *phy)
 
 	name = devm_kasprintf(&wiphy->dev, GFP_KERNEL, "mt7925_%s",
 			      wiphy_name(wiphy));
+	if (!name)
+		return -ENOMEM;
 
 	hwmon = devm_hwmon_device_register_with_groups(&wiphy->dev, name, phy,
 						       mt7925_hwmon_groups);
-- 
2.39.5



