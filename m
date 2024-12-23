Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2F38827;
	Mon, 23 Dec 2024 16:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970648; cv=none; b=WKQ9inBsQk3j1jkdEyHdyLAP7PkmXdDPAUsoU4lTeotJS8VFKu8NdNxriWuGOuzLJwHtc18c1kyE/QvL2yq+HfT+cOJi/MbWzMqQp5gB66DC4tswQx13Z9Km7H2dWcn8jWX7TFrf++Xb7W4snEb5nfO7zM2tmWl9Gx46G0Bbyg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970648; c=relaxed/simple;
	bh=P9XUX55n61dDVlbD7z4ql4WPjAWzCaQPIG/C4yXWN40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2TkASjC9YUiklWQnX5mBUjFAQOlKwU2vTKuf87ierO64+pcnjRR30zdALQQbJjBfTREIytEGbCkhyEVTY7TAi0iZjM8xuQropGR1n2p5CNtP4f3Y4IUzkc4y0BRejUJN+a8ipwwIt/9824MGiOJ56a7iPguIrIUxtvJNYyReQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TL5Ce/fi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TL5Ce/fi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB2DC4CED4;
	Mon, 23 Dec 2024 16:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970647;
	bh=P9XUX55n61dDVlbD7z4ql4WPjAWzCaQPIG/C4yXWN40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TL5Ce/fim/EwvywNY5aL7GIIE5C6f+NNORNgz8I9mLF+/RLN5AvhD/Iz/xvC9luk5
	 p2bVEtoYCUH1p2PiF9pFMvMSLr4FC/w8ske5I3PcJP0w4/2qn5Ttfdm5yZsN4hgzy5
	 BzbpUlthXWNuj2D49Qw+tLrcNA9mYMpB0iFA1sLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 27/83] ionic: use ee->offset when returning sprom data
Date: Mon, 23 Dec 2024 16:59:06 +0100
Message-ID: <20241223155354.686769784@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit b096d62ba1323391b2db98b7704e2468cf3b1588 ]

Some calls into ionic_get_module_eeprom() don't use a single
full buffer size, but instead multiple calls with an offset.
Teach our driver to use the offset correctly so we can
respond appropriately to the caller.

Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20241212213157.12212-4-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index d7370fb60a16..928ef2933990 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -828,8 +828,8 @@ static int ionic_get_module_eeprom(struct net_device *netdev,
 	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
 
 	do {
-		memcpy(data, xcvr->sprom, len);
-		memcpy(tbuf, xcvr->sprom, len);
+		memcpy(data, &xcvr->sprom[ee->offset], len);
+		memcpy(tbuf, &xcvr->sprom[ee->offset], len);
 
 		/* Let's make sure we got a consistent copy */
 		if (!memcmp(data, tbuf, len))
-- 
2.39.5



