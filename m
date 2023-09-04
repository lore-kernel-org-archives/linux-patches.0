Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BB9C142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58625C433C8;
	Mon,  4 Sep 2023 18:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852348;
	bh=iGLHyLZBkxBt3+FiRquBElqIcfhvODeK04xP8Ocy5hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ya/7NjpHDZkozyJv4FvSEOzEg7YWiJQIR588m7myMOGtE5jVTmCUx8CieP1GsaFAn
	 1dBncUS/7uNx51RSHm2zjV6D4b42rSgbln1c32Gptcf+2VrLCtc/fF5/ABOOZ8rgSb
	 mofksxGWutyjkGLopa6npxbXuW7SKVeDoEXQn5yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Knox Chiou <knoxchiou@google.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.5 19/34] wifi: mt76: mt7921: do not support one stream on secondary antenna only
Date: Mon,  4 Sep 2023 19:30:06 +0100
Message-ID: <20230904182949.483719185@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>
References: <20230904182948.594404081@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deren Wu <deren.wu@mediatek.com>

commit d616d3680264beb9a9d2c4fc681064b06f447eeb upstream.

mt7921 support following antenna combiantions only.
* primary + secondary (2x2)
* primary only        (1x1)

Since we cannot work on secondary antenna only, return error if the
antenna bitmap is 0x2 in .set_antenna().

For example:
iw phy0 set antenna 3 3 /* valid */
iw phy0 set antenna 1 1 /* valid */
iw phy0 set antenna 2 2 /* invalid */

Cc: stable@vger.kernel.org
Fixes: e0f9fdda81bd ("mt76: mt7921: add ieee80211_ops")
Suggested-by: Knox Chiou <knoxchiou@google.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1363,7 +1363,7 @@ mt7921_set_antenna(struct ieee80211_hw *
 		return -EINVAL;
 
 	if ((BIT(hweight8(tx_ant)) - 1) != tx_ant)
-		tx_ant = BIT(ffs(tx_ant) - 1) - 1;
+		return -EINVAL;
 
 	mt7921_mutex_acquire(dev);
 


