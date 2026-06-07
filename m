Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3614071DA;
	Sun,  7 Jun 2026 10:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827540; cv=none; b=n9a1asrQRzjpc0syfXWuRaKZCJVv6wbjn2dPSpQrMTF6T3EApPSrUL2WHqeeAGWoOZaKhJv2zuRMTh9h0yhT9xY4dxUEQZne+lWWJ27Cb1Or4QiZ2e7YkODfdmamoIaMBaPx3pXxWyM1I7UMDZJ53Oy7uoD+2u5kYq35MuwJ0Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827540; c=relaxed/simple;
	bh=SK+Gn+zYckg+EQkW5gzi/vnuCbPzeBJAJpcBT7IlCk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfelgQRAfhdAxZ0oc38rZQ3PYwOthrcPH++DvcMqNsZfDBgdn4Ics2womQdwSepBNh4BOz5q4wrdWYBcstkquhAx6MpwfndYWsdFcdy3WKykfXrDAY1TjZFmGpw9hABaNY/T/1XZO+ewzRPsJWqJtpC9GL/yC9p+qLfHzGy2qnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnR0lwSd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnR0lwSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228321F00893;
	Sun,  7 Jun 2026 10:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827539;
	bh=vrZdYgcyjQwLZSetS+29B1G/SRvXciS5ZNB/kogFCk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gnR0lwSdvNyBMp6SxyjP+lZZgGS6/aMhr97qYEdO0vMOyeIOpBWJAUDxwQ9xoFui/
	 AOQJ4EIZ8aCmdNHzJtoMW77KyHA4xBf7nXBo2Y5GV1/OHQGgfg18SfHL9W/CnC6rq2
	 9RRyV6/vIFoGgdtfNoSK/JXamiyI96NJHkOKn3og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 077/332] ethtool: eeprom: add more safeties to EEPROM Netlink fallback
Date: Sun,  7 Jun 2026 11:57:26 +0200
Message-ID: <20260607095730.970757286@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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
index 03cb418a15823b..80af38a6c76acf 100644
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



