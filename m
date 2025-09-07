Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A744315A;
	Sun,  7 Sep 2025 20:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277494; cv=none; b=JSRTy5pCyE9gvX38TvuP3f6an2pPXUU5nSh4On2U7oSmILtjKLEuGtB6VtbDBo/gJTYrzNa2FsZYbgkklJkAbaTg1aszqySEqqFT89pNagJACtmyv2GfnWeXCst3KmEix2o0JL28MB6vkvoSFr6JBocxfak8zsr5awPyh8E7/M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277494; c=relaxed/simple;
	bh=mcVjB8BrVO4KdZRqIMJ9K1i3Bpmi7aDOxAADN5v26cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhURiMU+tnbrAj7S1qHaeNRpMCRUVc8gkD4hCHfIgko9LoqNLaVqoM3JRtV5vM2FO2BPRyRQD5hallbcZK4QLI3tfaJy38uiOfMjM2vbEnNPj/n3sUpb9GLRa38BT7+UlFbrSDN5LwQesaMPhS4wWIwqWv1b1OkNScYyaruD/fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erb1lPzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erb1lPzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6008C4CEF0;
	Sun,  7 Sep 2025 20:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277494;
	bh=mcVjB8BrVO4KdZRqIMJ9K1i3Bpmi7aDOxAADN5v26cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erb1lPzV3rjPZgy7Leb7zG3QJ10VlMLF5doTNdRC4SJMLJ1TyzoVK8MCFdCz394sm
	 oyHi8dDFjUNkQGaesYmSvI/58bCTqLFb83S+sl7H02fv3/LWxfWD3wVmsj6gpHXYlJ
	 t7y3h78QObfjfiTyNBo4Mc72DoXvKXzrLT6htk0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 033/183] wifi: mt76: mt7925: fix locking in mt7925_change_vif_links()
Date: Sun,  7 Sep 2025 21:57:40 +0200
Message-ID: <20250907195616.560824959@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 5b001548dffce..328a06998c7b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2067,8 +2067,10 @@ mt7925_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
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



