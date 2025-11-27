Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A9E284B58;
	Thu, 27 Nov 2025 15:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255737; cv=none; b=VKbaNjwR3rxlTby3irLsvXqM9j2dIISRrSsLu9YNpD4k41DX7R5EDmhxoG0n2bGKUF6jGTUSwFLpYQG2wuAg/TknlBxLFQ2DdEA9C5Ma2PWGIaRcxy6AJWLGZd0T3fUywlVs2kcxYrULgzOjhc0+Lu1AdIO/SrLor5X9dlpjSLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255737; c=relaxed/simple;
	bh=zoB4XZ0XPS+vZK/AzPVLKpzNutgr5EwJcI/5p8iG18o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5OtBhzuHJ+Klmdb39+J5H6qwAPXtiIDzb4P9O6WhhyVZqZJwodaEDVgDGK3o1J0k8V4NQy6+taP3SVQvCcVxa+kQvcxhOpQfdUc6AGyv0YFaRgoScZ+9CzaRXI9UnXxRsoYeRoGTcG+SGE4+eZA/QDz+s/KrLhsWPxnsLPAxnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYlbAiEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYlbAiEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667CDC4CEF8;
	Thu, 27 Nov 2025 15:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255736;
	bh=zoB4XZ0XPS+vZK/AzPVLKpzNutgr5EwJcI/5p8iG18o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYlbAiEXP0mjm1i+SIDulStb4GcKuni8maMpnFu9epaPNP46st8MBiGokD8mDwySD
	 oW7rWipmhAgaLrnAK2QXkJEJBTtQ7QSC+IfvgZUJCYrv1Mm+aCue9vd1vafdeEHRQ1
	 vXClmtaphbYDNboTalHwlzQCZeKzJTt5N/FQA+Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 095/175] net: core: prevent NULL deref in generic_hwtstamp_ioctl_lower()
Date: Thu, 27 Nov 2025 15:45:48 +0100
Message-ID: <20251127144046.430656142@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaming Zhang <r772577952@gmail.com>

[ Upstream commit f796a8dec9beafcc0f6f0d3478ed685a15c5e062 ]

The ethtool tsconfig Netlink path can trigger a null pointer
dereference. A call chain such as:

  tsconfig_prepare_data() ->
  dev_get_hwtstamp_phylib() ->
  vlan_hwtstamp_get() ->
  generic_hwtstamp_get_lower() ->
  generic_hwtstamp_ioctl_lower()

results in generic_hwtstamp_ioctl_lower() being called with
kernel_cfg->ifr as NULL.

The generic_hwtstamp_ioctl_lower() function does not expect
a NULL ifr and dereferences it, leading to a system crash.

Fix this by adding a NULL check for kernel_cfg->ifr in
generic_hwtstamp_ioctl_lower(). If ifr is NULL, return -EINVAL.

Fixes: 6e9e2eed4f39 ("net: ethtool: Add support for tsconfig command to get/set hwtstamp config")
Closes: https://lore.kernel.org/cd6a7056-fa6d-43f8-b78a-f5e811247ba8@linux.dev
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20251111173652.749159-2-r772577952@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev_ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index ad54b12d4b4c8..8bb71a10dba09 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -443,6 +443,9 @@ static int generic_hwtstamp_ioctl_lower(struct net_device *dev, int cmd,
 	struct ifreq ifrr;
 	int err;
 
+	if (!kernel_cfg->ifr)
+		return -EINVAL;
+
 	strscpy_pad(ifrr.ifr_name, dev->name, IFNAMSIZ);
 	ifrr.ifr_ifru = kernel_cfg->ifr->ifr_ifru;
 
-- 
2.51.0



