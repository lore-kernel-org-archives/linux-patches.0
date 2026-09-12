Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0161C47ACFF;
	Sat, 12 Sep 2026 12:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217161; cv=none; b=qLJ6Z1PRaniK/BPtr9FQhKx3p2B953d6lt5t4Ynzai8VzLSGDUAtLVhbrtcP2MnR4Rc38h/ludGwZ44rd/8jhUT2iEDviXIcJRGiYVUQY8/WPsnN/O2RwNRPm3Oe0c2xJnsK0EsPCb/qjtTWkJINQ1+JUG4xDujNSbNdrWNRMOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217161; c=relaxed/simple;
	bh=obgGrrRVUFyohD1wtPk0WFXAgC7iOjrdnNBg+ZZQSzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TU27rqfqsy1EPh/r2n9HhD95T7T5miX0WcthDk+A6VCpA9SSQyz432b9jLi+UGp3jl2gLAIKWrBqFshIVX/0FiBceSPL0hgeyRa0yMRodT6IWSP+H/avFNet94HYBPFOZ62KxQ90hLr7Winacf5YzpaM1sTvk1AP2ejYIOlsAfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UU07nUFG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UU07nUFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2CB1F000FF;
	Sat, 12 Sep 2026 12:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217159;
	bh=GkPi3SJI1UQNSIFbvnJto+tramdtN0wd/YshdBcc2MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UU07nUFGruO4o4zjvjKo4dXCjh+DyKyAAZj8v8gmrWH3vBNxD+Jf+/COIXxhChfoa
	 9ptoiMsAHJVXCzdA/eoHV0XBq9zyRfUFXaBmfQudELBbbX0dBbFO/qXMF8f7X3wEnr
	 juFlV0o2loLpGpcSJt/+aTXJnvlCt2pkYtDp71/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0840/1376] wifi: mt76: mt7915: fix ext PHY use-after-free on register error path
Date: Sat, 12 Sep 2026 08:54:26 +0200
Message-ID: <20260912065626.270653635@linuxfoundation.org>
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

[ Upstream commit 15b960014f24dce5388d4a2e7274e6490cb3c421 ]

After mt7915_register_ext_phy() succeeded, a failure of the main PHY
mt7915_init_debugfs() or mt7915_coredump_register() unwound through
free_phy2, which called ieee80211_free_hw() on the ext PHY hw while it
was still registered with mac80211, since mt76_unregister_device() only
unregisters the main hw. Unregister the ext PHY (thermal + phy + hw)
first and skip the redundant free.

Fixes: 7b8e1ae886e4 ("mt76: mt7915: rework hardware/phy initialization")
Link: https://patch.msgid.link/20260727150434.1778520-3-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index b2220ff7d6758..96871012bed3b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1253,14 +1253,19 @@ int mt7915_register_device(struct mt7915_dev *dev)
 
 	ret = mt7915_init_debugfs(&dev->phy);
 	if (ret)
-		goto unreg_thermal;
+		goto unreg_ext_phy;
 
 	ret = mt7915_coredump_register(dev);
 	if (ret)
-		goto unreg_thermal;
+		goto unreg_ext_phy;
 
 	return 0;
 
+unreg_ext_phy:
+	if (phy2) {
+		mt7915_unregister_ext_phy(dev);
+		phy2 = NULL;
+	}
 unreg_thermal:
 	mt7915_unregister_thermal(&dev->phy);
 unreg_dev:
-- 
2.53.0



