Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D929F1A6803;
	Tue, 16 Jun 2026 16:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628365; cv=none; b=pmY7t8L7uKSTZUpBnHpW4x0UKwLoDGYtXKsPsbauhI+Z8veVOONCSip9yiNu8AA/mOSVX3NG0dud6DCVnZ8P+iGXupdIqGwPv2ekba4ab/f3qVbLQozuoH57mB6S5nMz1gpNjuT1SwihIkckCUX92mnSWRAj7UmnsiyRoXj2gTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628365; c=relaxed/simple;
	bh=S5ldm1KKFykFvzyaqPfqHbVK/2gPP+7BRm3hQOtbWKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oh10VQe+CBd2qVE8sjRY+7wlRFn2wuum7wuPXJo8HJDhdrTq4ErggqvoY4be58S5Y39LQcA/S5AexphLu0FOHpS4po68nbOzXDXHTi2BbcH+zwsMq2tR33ffmVzRiyWPYwaWjn76ZuMZPEJIYS8c/hLsuM9BVJUTdF3biRpEmwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QokM/Cia; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QokM/Cia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE451F000E9;
	Tue, 16 Jun 2026 16:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628364;
	bh=KSXGU8r4XnO9cIqAJPNgaFABMbxs6yP+ZpEAmYQP+HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QokM/Ciat+GLNxeM3h9nzGGqISpf+DCar0qSNwzVy6FZaVq2lqNQCYtJQClQF/5yd
	 37w17OBUhYbe9U20iNUfytE2ET2dMCj1gyWf7NPSHMapATBAv696KaoH760AbVKYIq
	 zVP0FILw2zrJtzkjbx+T5uSLcNkWu26bzg35smcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/452] ethtool: eeprom: add more safeties to EEPROM Netlink fallback
Date: Tue, 16 Jun 2026 20:24:25 +0530
Message-ID: <20260616145119.941469082@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 67cfdd9210b99f260b3e0afeb9525e0acc7be31e ]

The Netlink fallback path for reading module EEPROM
(fallback_set_params()) validates that offset < eeprom_len,
but does not check that offset + length stays within eeprom_len.
The ioctl equivalent (ethtool_get_any_eeprom() in ioctl.c) has
always enforced both bounds:

  if (eeprom.offset + eeprom.len > total_len)
      return -EINVAL;

This could lead to surprises in both drivers and device FW.
Add the missing offset + length validation to fallback_set_params(),
mirroring the ioctl.

Similarly - ethtool core in general, and ethtool_get_any_eeprom()
in particular tries to zero-init all buffers passed to the drivers
to avoid any extra work of zeroing things out. eeprom_fallback()
uses a plain kmalloc(), change it to zalloc.

Fixes: 96d971e307cc ("ethtool: Add fallback to get_module_eeprom from netlink command")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260526153533.2779187-11-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/eeprom.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 15546f2a5e4583..4e864824b64d28 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -43,6 +43,9 @@ static int fallback_set_params(struct eeprom_req_info *request,
 	if (offset >= modinfo->eeprom_len)
 		return -EINVAL;
 
+	if (length > modinfo->eeprom_len - offset)
+		return -EINVAL;
+
 	eeprom->cmd = ETHTOOL_GMODULEEEPROM;
 	eeprom->len = length;
 	eeprom->offset = offset;
@@ -68,7 +71,7 @@ static int eeprom_fallback(struct eeprom_req_info *request,
 	if (err < 0)
 		return err;
 
-	data = kmalloc(eeprom.len, GFP_KERNEL);
+	data = kzalloc(eeprom.len, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 	err = ethtool_get_module_eeprom_call(dev, &eeprom, data);
-- 
2.53.0



