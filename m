Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A0846D093;
	Tue, 21 Jul 2026 18:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657577; cv=none; b=VSZifpFKhRmV1v/QKDDLWJkmzCGCUwSAnl6raBItO5JeHEKEXfSaGH2ZNLNw9y0w9vblKPnpYYoFYiDTmnzuigodiw+wV7miE9DNBx69BXUUWZiImJqbaMF3BtBFUGwZOxd42PWxVXcXsjJmJv8g+lqK0d9azEr5aZ8VBlWXgS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657577; c=relaxed/simple;
	bh=C9jXlBSq6Ha8FmIDvhAklBpdKYVuDhUQ6khvrrDhJUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l982kmqmc5o/Fcel+T/VFDdd17UJ6V+dEuZTFqbnu6j9l65C82UM/npwMF4XFApgKJPGgIvIFT2ESBYny9NaqZ6pG63J2i5ZACR3SfBsNI8WrpP5J9wI1gj3LlC1ytk/U0U+m8YbzV3iojCYfXRnNAmhiYZrrvgwaZso5sP3EJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O20/WGx/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O20/WGx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020961F000E9;
	Tue, 21 Jul 2026 18:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657576;
	bh=0l77YtAhtryqGCfc4vlYJ0Nh7PSnW0iXZsesL/fe2+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O20/WGx/FyVOYTFNzHNWxBirbShfNV7Hhs/czSrJyRNKROb3SDqi44aS/tJ4QbnNq
	 ZJB9CKzNssG1eT7eBKHaOGMfR8cv9s9WOw5jDuMLxMcymV3bRSEhyR3UvrQeqI8L3A
	 dtn/DlBt/XBGC2ulWPklzbQ7r7ct4E86N4A1PJ5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayen Yan <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0817/1611] net: airoha: fix foe_check_time allocation size
Date: Tue, 21 Jul 2026 17:15:33 +0200
Message-ID: <20260721152533.766711956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayen Yan <win847@gmail.com>

[ Upstream commit 5c121ee635680c93d7074becf14cfbaac140f80d ]

foe_check_time is declared as u16 pointer but was allocated with
only ppe_num_entries bytes instead of ppe_num_entries * sizeof(u16).

When airoha_ppe_foe_verify_entry() is called with hash >= ppe_num_entries/2,
it writes beyond the allocated buffer, causing heap buffer overflow and
potential kernel crash.

Fixes: 6d5b601d52a2 ("net: airoha: ppe: Dynamically allocate foe_check_time array in airoha_ppe struct")
Signed-off-by: Wayen Yan <win847@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/178161119471.2163752.14373384830691569758@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_ppe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 005128717a45c9..798839aa1010b8 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -1538,7 +1538,8 @@ int airoha_ppe_init(struct airoha_eth *eth)
 			return -ENOMEM;
 	}
 
-	ppe->foe_check_time = devm_kzalloc(eth->dev, ppe_num_entries,
+	ppe->foe_check_time = devm_kzalloc(eth->dev,
+					   ppe_num_entries * sizeof(*ppe->foe_check_time),
 					   GFP_KERNEL);
 	if (!ppe->foe_check_time)
 		return -ENOMEM;
-- 
2.53.0



