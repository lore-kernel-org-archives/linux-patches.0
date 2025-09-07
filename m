Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E416415C158;
	Sun,  7 Sep 2025 20:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277089; cv=none; b=ny0S3gVY806ueHUGILD6g4qw0VbNyuq12iy/rGrgv3i5YRqH7DkH4bHcm9whiEFED+ad9kw0brqg5QEN8SFh52hE649OjFafbdXxWd8xs4SChYmluhfHEK+bqj7pkjsB3VlKrtsPkpgmNDj2xQYnn0kWkobDHqgFuD4mV7IqAww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277089; c=relaxed/simple;
	bh=q/n2zbc0T8Tl26mKO4Wx0hFbiN/yR1BWudg2Qrw4LTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqSb0Uw0MyPwnogas81WAX4poODj7cwajzBnWNzbKBz1Ht+B0w3NmY/zNZ9RFgUVFTuYhc4rCeLCWxxFIBfb7AwfH+9rAuJ3wdL3zntopKNFU1qZImsIolHzXCixVOmrhg0M0BBzXHfn49J+15MkXLPHaqTXTzbTOEAk9Hs/XRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCLGe2wY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCLGe2wY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5BDC4CEF0;
	Sun,  7 Sep 2025 20:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277088;
	bh=q/n2zbc0T8Tl26mKO4Wx0hFbiN/yR1BWudg2Qrw4LTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCLGe2wY0ss/grcxab4/Q68QhSOwsnmqmtegjTeZWp5hEo19Nd84jB1lxVFnGEHCG
	 lO6cfhaP7svCtTs60QO9m1/g7s0sqVVitFQy5Psifl+2rphjhgjAHP0ZpqUEbI1mj/
	 o1gT3igP09qtg5+ii8kx3jwxt/ELlMhU5X6r/KTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/175] wifi: mt76: mt7925: fix locking in mt7925_change_vif_links()
Date: Sun,  7 Sep 2025 21:57:10 +0200
Message-ID: <20250907195615.685491435@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 9f15701370ec15fbf1f6a1cbbf584b0018d036b5 ]

&dev->mt76.mutex lock is taken using mt792x_mutex_acquire(dev) but not
released in one of the error paths, add the unlock to fix it.

Fixes: 5cd0bd815c8a ("wifi: mt76: mt7925: fix NULL deref check in mt7925_change_vif_links")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202503031055.3ZRqxhAl-lkp@intel.com/
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://patch.msgid.link/20250727140416.1153406-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index a635b223dab18..53831e1e00424 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2005,8 +2005,10 @@ mt7925_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 					     GFP_KERNEL);
 			mlink = devm_kzalloc(dev->mt76.dev, sizeof(*mlink),
 					     GFP_KERNEL);
-			if (!mconf || !mlink)
+			if (!mconf || !mlink) {
+				mt792x_mutex_release(dev);
 				return -ENOMEM;
+			}
 		}
 
 		mconfs[link_id] = mconf;
-- 
2.50.1



