Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8576E1519AA;
	Wed,  5 Feb 2025 13:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763894; cv=none; b=hb0SEyPdT4+gDXkculnu2ISk7/tiD526wyotuDkn513CQvFcJihLX3Lt1IfyBfTPBT/bZnsxcgteCsyW0zFKiOK0FYVjjrRrwYgkmoXueAGtBPSqm4JoqE0bUfTC9Ptj6rK89gL842OKBRLrI7vEe0bbcuzlEx8wxNG/6Ib2PN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763894; c=relaxed/simple;
	bh=ZeEPFXpc2fOcVnrfvCD7cI6YrXAuxiXmYF91Dr6wZ5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5Y7zaxpoF1HhWOLHNXb2hgg5osjTH1ND149dBlfCd7o7VdEKekfRaC/zMfg2KzgM4xc9K2fQNLUjCZD5SxqVvcxEDA9FD5xkT6mWCBI6o6oy1J6LzBnO91zXKG/5y7rVLyaKtdosx8pJorzbulxEhsFOSRNJHKEa32smgjLlYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3Qw/YZ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3Qw/YZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EE1C4CED1;
	Wed,  5 Feb 2025 13:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763894;
	bh=ZeEPFXpc2fOcVnrfvCD7cI6YrXAuxiXmYF91Dr6wZ5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3Qw/YZ1C30wE+eSAiXYjdbKvqNnpULbPlF7PITOjEjYDCqm3NY5oTwwiWIj69F+C
	 5sBqNeR9Xzrv7b4mA4yfcC4+0LZG18TFgsqFh13NqRjHlz3hH5FMPiRq7LjzP9xS76
	 uQgKHcq5/B3W4kc0/nnE+aM6xwgIxqUyJMZnANhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Lo <michael.lo@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	David Ruth <druth@chromium.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/393] wifi: mt76: mt7921: fix using incorrect group cipher after disconnection.
Date: Wed,  5 Feb 2025 14:40:36 +0100
Message-ID: <20250205134424.768117885@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Lo <michael.lo@mediatek.com>

[ Upstream commit aa566ac6b7272e7ea5359cb682bdca36d2fc7e73 ]

To avoid incorrect cipher after disconnection, we should
do the key deletion process in this case.

Fixes: e6db67fa871d ("wifi: mt76: ignore key disable commands")
Signed-off-by: Michael Lo <michael.lo@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Tested-by: David Ruth <druth@chromium.org>
Reviewed-by: David Ruth <druth@chromium.org>
Link: https://patch.msgid.link/20240801024335.12981-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 6dec54431312a..31ef58e2a3d2a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -519,7 +519,13 @@ static int mt7921_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	} else {
 		if (idx == *wcid_keyidx)
 			*wcid_keyidx = -1;
-		goto out;
+
+		/* For security issue we don't trigger the key deletion when
+		 * reassociating. But we should trigger the deletion process
+		 * to avoid using incorrect cipher after disconnection,
+		 */
+		if (vif->type != NL80211_IFTYPE_STATION || vif->cfg.assoc)
+			goto out;
 	}
 
 	mt76_wcid_key_setup(&dev->mt76, wcid, key);
-- 
2.39.5



