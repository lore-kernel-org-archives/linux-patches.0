Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF7527781E;
	Tue, 12 Aug 2025 19:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025769; cv=none; b=Q9vy7jccR5WeJZlIzxy9uDOpY4wDJOVODnfB1UN0VCNew9k8Qq8Exb0kbCoCqmeSlC3N6pYGtomWmapjZ77jisHdC4pQXpBJgfL1tpwDFkEh0H/iF0sby0KSa3sRtMsuIxGeiACgecgjx4yVNH1OSwrIvu04uZlrH5zafHRDjKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025769; c=relaxed/simple;
	bh=Fs+H7Bkpiquy4adiXJFtho3vPDADIFz4+ZfsYwyWFcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ux3do1S9ffIW9lRWcsKNca9PtOWXc937YHJ289kUUIlHAW0rDLl/Uyqd4EaxkvjmcL7X9O2QDSV7d2HUNrogfbiSgNQmpmnUdXZo5Lx9YeAOj4yfrbTzUcsdeauUIs+WvYP3hOegZfbxuh5apHkGhPTqzcJvSJLUrZ/OXNqhwW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0ocMgDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0ocMgDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8D0C4CEF0;
	Tue, 12 Aug 2025 19:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025768;
	bh=Fs+H7Bkpiquy4adiXJFtho3vPDADIFz4+ZfsYwyWFcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0ocMgDdU7+ABUxx2raRv8hTYJvyrg3UiY1ly52yj2enPTkVwP4CAitX4iIn22K3K
	 7igfoOfYbRhRzwQAUwVBrcuFSB5jXbbkjpefq4GeFV6LYlqHlGKDko9k84//WSsj/2
	 O/J7dKTaBcCQf5Q/PZTjAyyWQ5s49/HhULZ3xx1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 138/480] wifi: mt76: mt7996: Fix secondary link lookup in mt7996_mcu_sta_mld_setup_tlv()
Date: Tue, 12 Aug 2025 19:45:46 +0200
Message-ID: <20250812174403.217365571@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit e8d7eef07199887161cd6f3c062406628781f8b6 ]

Use proper link_id value for secondary link lookup in
mt7996_mcu_sta_mld_setup_tlv routine.

Fixes: 00cef41d9d8f5 ("wifi: mt76: mt7996: Add mt7996_mcu_sta_mld_setup_tlv() and mt7996_mcu_sta_eht_mld_tlv()")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250704-mt7996-mlo-fixes-v1-2-356456c73f43@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 63dc6df20c3e..ce6e33d39d22 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2307,8 +2307,7 @@ mt7996_mcu_sta_mld_setup_tlv(struct mt7996_dev *dev, struct sk_buff *skb,
 
 	if (nlinks > 1) {
 		link_id = __ffs(links & ~BIT(msta->deflink_id));
-		msta_link = mt76_dereference(msta->link[msta->deflink_id],
-					     &dev->mt76);
+		msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
 		if (!msta_link)
 			return;
 	}
-- 
2.39.5



