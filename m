Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057565;
	b=xTqMNoXn1iAto6TS1RkOnLRxBZCPnBjk+fuwToUuAWvXV3diOWqq7WKYmZmNuaKXV6qs
	 PMMLGOVLq1tBSzoE+AIIRGA//QQtIUB+MO0tZRskSnNixHTL6hAYgFmF+xb+unRohpRu7
	 eOttZnidu8/kI+u2QlICG8YppnnV5NPeBY2qJ3GZ/v9POJexA405YRhgb7v//HougBlEZ
	 w7gf1dZkZ7brFlMKfFN0/UNGamB3BrYwNzZCMr5lx+t8c/Au5pVoMnf9MQDPPOSCVlo2M
	 eDtHozvZefLjSOvUc5pCj0E8u/HZhvPRa8v4ru86JZuMBAwXv2YDNMBvm0UD8Ona4zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fnXu+Msx5+QM+tD+LVYzRYzVCMB3MH+UUcqYmjPb+NM=;
	b=ovUhdD30cvAOO6/yYveasG17iKrNXpsAGFJkvwqWLEiCC9tGK8IDasByT/7iUr/9paD3
	 R6dYgwXm+MTXS68vbnh5lDZWKCXJ9I0xvXMxIvJ3HHH40lDecpaZfi1QBKuLwZ+qf3kXW
	 DDav8MYCeSMTNF1aqRwQvOCZdDvZnDpzIp+1ErNsW4B5GBvuzn908AWurE8HFmmX2YKUK
	 arOt5Tyixz9E7wUmtnHp0ImBGdaf+4sLJe1twJax0egVpGdqXsTA2OhHMr13AG9X7IbQv
	 tSfDjzEW5847J0JmluoqHYVIrfxGakQv70S4RzNHOm/RCGioFZg7qKjIZcYnuour6ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W9kW8c9k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E88B60A2612;
	Thu, 19 Nov 2026 03:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W9kW8c9k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D0A1F000C5;
	Thu, 19 Nov 2026 03:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057565;
	bh=fnXu+Msx5+QM+tD+LVYzRYzVCMB3MH+UUcqYmjPb+NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9kW8c9k30/Mbk7wIu2zFUv0C/nsAQMTNnShNUoR9tykuuPOtDBCEBYUHsQvhpbMK
	 L9n8rjEvcA6NWzdyiVY5UZctM2aEXD3Vr5OH2BSb4Yh5hhJys25uoXgiJVtUVqH2pd
	 azrt4bU8X/pi4HcJDCUCJRMP/csE2cw6ZUHx39UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Tatas <michail.tatas@gmail.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0174/1848] ipmi: Fix leak in __ipmi_bmc_register
Date: Wed, 18 Nov 2026 15:36:52 +0100
Message-ID: <20261118145918.839988300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michail Tatas <michail.tatas@gmail.com>

[ Upstream commit 18e633dd9674c8bf118ea8583bb5a531edc2728a ]

In case that ida_alloc(&ipmi_bmc_ida,...) succeeds and then
platform_device_register() fails, ipmi_bmc_ida is leaked.
Fix by freeing the error path

Signed-off-by: Michail Tatas <michail.tatas@gmail.com>
Message-ID: <anUK_HOy_pCgvsBm@michalis-linux>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 031b61b0d9c7d..3fa8ccd344cc5 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3140,6 +3140,7 @@ static int __ipmi_bmc_register(struct ipmi_smi *intf,
 	list_del(&intf->bmc_link);
 	mutex_unlock(&bmc->dyn_mutex);
 	intf->bmc = &intf->tmp_bmc;
+	ida_free(&ipmi_bmc_ida, bmc->pdev.id);
 	put_device(&bmc->pdev.dev);
 	goto out;
 }
-- 
2.53.0



