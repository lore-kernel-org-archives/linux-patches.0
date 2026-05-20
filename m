Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F81372EDE;
	Wed, 20 May 2026 16:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294591; cv=none; b=qCkcJGq1C4kiQyT4srKncV/Kds75ozjnkcWU1UwqsmNRQbLSe433rZYwezIwYrbyvxOSE6Y4V8OovDNZgFV0AgGVZTboWrtHD64DwNeva+fJcf8TtqCz5gcr1iAZAGSbOkucDZcWyI7TQP5SFHtWA2UxftbkiKsBNKIMA0KAs74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294591; c=relaxed/simple;
	bh=jra7mn1cUmgJTGLhR+uPnpzsxv9loQ/14dKmPkSffFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArzC+v3cqp57Q0RnvmmmbdFaFe63IZx2dx9gBQbcNeBuUS3VM3E40j+9FF17qacvp7rm23oaHjtq6ZjlAaemuNxra6PNYbbQm8xEwQrK411vy0n21WP53qQ20jjpemkqLfIUtYCjc2GKY7uUhxncRWjUVDYQL7IkzzWiCwTPpHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+xydlML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+xydlML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878C71F000E9;
	Wed, 20 May 2026 16:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294590;
	bh=f9PCnHcmM0ZEz42M7aEVUTWtG9KbgyD1d6yBZRyo9rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+xydlMLsjopsTHO3pGFtyTQxnT+QKSLUeAbwEcm8dWgHv2dj4lYG/m8yGRcxTPdj
	 VOo2bgQrWkSE27kM+NLA6RwxXuAfz5MyBShF5HMHdcMb5GSGFEdnivXqUcT/yCCxHY
	 O+G3iJflwuhw55S8aqdDjMHzNf3Xq2Lij6rTXohg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0098/1146] wifi: mt76: mt7996: Clear wcid pointer in mt7996_mac_sta_deinit_link()
Date: Wed, 20 May 2026 18:05:48 +0200
Message-ID: <20260520162150.564063566@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 88973240dc7c976dd320b36a9e6d925c9be083ae ]

Clear WCID pointer removing the sta link in mt7996_mac_sta_deinit_link
routine.

Fixes: dd82a9e02c054 ("wifi: mt76: mt7996: Rely on mt7996_sta_link in sta_add/sta_remove callbacks")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251205-mt76-txq-wicd-fix-v2-4-f19ba48af7c1@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 50ccfe3e10bad..6b98835269353 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1043,6 +1043,7 @@ void mt7996_mac_sta_deinit_link(struct mt7996_dev *dev,
 		list_del_init(&msta_link->rc_list);
 	spin_unlock_bh(&dev->mt76.sta_poll_lock);
 
+	rcu_assign_pointer(dev->mt76.wcid[msta_link->wcid.idx], NULL);
 	mt76_wcid_cleanup(&dev->mt76, &msta_link->wcid);
 	mt76_wcid_mask_clear(dev->mt76.wcid_mask, msta_link->wcid.idx);
 }
-- 
2.53.0



