Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B3F143C41;
	Tue, 23 Apr 2024 21:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908704; cv=none; b=B3gIEMSLdRV4gGbivuTkP+uFhpgOH303Iv+nNUAqFf+jhchS7QadtbYRQNEPwoPfxouRuZF24wqTGfmpDsdBj/ZD/dKDf2xIEcJiWC+gVXueAifPtO4HtAgR8QpucMjmz6p10zagSrpthpnXW71bCFY2P4rsfCVHGQLk/kFVELc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908704; c=relaxed/simple;
	bh=nzXLCl206iRdzUYra+XcDGDF9iMSC4clgmkZup6ZrK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRnSchvnKwi42f5e0qOf6qFQqIbte29STbeEiwIQRGcLqYo53/qRxHq0v+Q70FDaY/B5j/bB93y42FR/ayJlXu42YE0+nmoRUWMH6ImnXUA9I8xEJCkz6ZHkFs2SGLoQpSjWFpwO8ejeXvFBvtybs4/mG7o5jbA0Tatd3MgPr3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxsB1HHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxsB1HHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3B0C116B1;
	Tue, 23 Apr 2024 21:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908704;
	bh=nzXLCl206iRdzUYra+XcDGDF9iMSC4clgmkZup6ZrK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxsB1HHdxXHr4+zYsYYx5sD8vyuqAbsQ9abrZv2dx7xLw15ZXBFSRAOfr62e4UFKW
	 pVbox2qEKlP55T9W4eGQGyv5QhtdJsIK/OFdJpE0nfrQqE8IrnIV4e9Z8RhPoDlAqb
	 XNZ+TWqgiWnDlD+vhHQhVDSzSuXZLkO81kMg8m9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/141] usb: pci-quirks: Reduce the length of a spinlock section in usb_amd_find_chipset_info()
Date: Tue, 23 Apr 2024 14:38:47 -0700
Message-ID: <20240423213855.165849068@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c03ff66dc0e0cbad9ed0c29500843e1da8533118 ]

'info' is local to the function. There is no need to zeroing it within
a spin_lock section. Moreover, there is no need to explicitly initialize
the .need_pll_quirk field.

Initialize the structure when defined and remove the now useless memset().

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/08ee42fced6af6bd56892cd14f2464380ab071fa.1679600396.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/pci-quirks.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index ef08d68b97149..2665832f9addf 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -207,8 +207,7 @@ EXPORT_SYMBOL_GPL(sb800_prefetch);
 static void usb_amd_find_chipset_info(void)
 {
 	unsigned long flags;
-	struct amd_chipset_info info;
-	info.need_pll_quirk = false;
+	struct amd_chipset_info info = { };
 
 	spin_lock_irqsave(&amd_lock, flags);
 
@@ -218,7 +217,6 @@ static void usb_amd_find_chipset_info(void)
 		spin_unlock_irqrestore(&amd_lock, flags);
 		return;
 	}
-	memset(&info, 0, sizeof(info));
 	spin_unlock_irqrestore(&amd_lock, flags);
 
 	if (!amd_chipset_sb_type_init(&info)) {
-- 
2.43.0



