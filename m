Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F1D4502F;
	Tue, 16 Jun 2026 17:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630621; cv=none; b=uHbwAxXdlrb2npJ7CdQG8N1BY5oLKEech4aZlfyUr9FHvKX3uf3bfCTqQWA5O+McMEkXItErZ6j1JFspOzVSjsBCtLww3PhhejQbYM10qYH/Znjo5GpcyGodshl4azS/a/UcZSgRJ4OZmS9YvLxMQmw7F7Gp2qNX3+ni2hrtgq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630621; c=relaxed/simple;
	bh=2yIqH+YF5azK4vMpIigkbNPtSD4HiLszae4QZLApmnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+SmeyCMg7dUICE8SuINmfSQL0GM0rpcKuxu4YA1V4cCDZIj+v4HY4T2z2gdTueuJc6oRlyPE11fGE4ab7NpYeg4c63EbwZCWFuDfQHT+dFzta7FFcZ4E7gXhFoB794Nk9jUvLZAKZIeWu8qvAChS43MTv8XefoK39kUWzJ1ct4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwN1ET/w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwN1ET/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5311F000E9;
	Tue, 16 Jun 2026 17:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630620;
	bh=XnOCpE3wdTrfArOyFdQmucbG1cGo8R1xptTmunlF2dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BwN1ET/wsVj2BdGdLywOz2e3dWeSNhRTHATWHyifagk2yF2ZhpvJMORD01Ib3w7vt
	 Qd+5lunWn4b29IcHvEaMPx6Ox5dJKno0ohoGEP5gR819Jf8LooloJ5ODbxRAlFGH+E
	 NwAIQgQ12BO4pLYYy+tsdygzSI72ZHjNcs755ZT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/522] ethtool: eeprom: add more safeties to EEPROM Netlink fallback
Date: Tue, 16 Jun 2026 20:22:58 +0530
Message-ID: <20260616145127.112310906@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 49c0a2a77f02de..6ce40f95d8aba5 100644
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
@@ -69,7 +72,7 @@ static int eeprom_fallback(struct eeprom_req_info *request,
 	if (err < 0)
 		return err;
 
-	data = kmalloc(eeprom.len, GFP_KERNEL);
+	data = kzalloc(eeprom.len, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 	err = ethtool_get_module_eeprom_call(dev, &eeprom, data);
-- 
2.53.0



