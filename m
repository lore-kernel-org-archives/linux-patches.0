Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C910A1B4137;
	Mon, 23 Dec 2024 16:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970317; cv=none; b=hUwwyZGzUbx/QHCi8lelW3Im6CtojB1W2a/2VLa+vb1O3Munpq9Eg6uzSWU9erwKJuhIiElYVtfQ/nqavjjwAI7vDoBrrn1Xl9i+Vf3Nhb8ipREK1H5jXDAWmFWQ/51Fke076KsLZIkM6xKgWF1F/Ab3K+R4HHDtWAL2OA5/4A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970317; c=relaxed/simple;
	bh=l2H2Su30oKKTde4jlFJdPnciDnIkjO2F4g3eig2APo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCPyOz5/zIuTfKoyxlwAw4aPL6CTpVkZWdZvYcyhAa7dY9k65u+eYBb1ouS4fK0l3Ba4u4z+mSTkzwIP1PIyq+eZj7K5ouA64rizNHt7Rg26VhCObO1KZuSx+sZ+AOfy02av4FMSddvsDBh8CXaW5ZLhw8GRYhS+uT4hqDtQEOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=037kO3Zk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="037kO3Zk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316EAC4CED4;
	Mon, 23 Dec 2024 16:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970317;
	bh=l2H2Su30oKKTde4jlFJdPnciDnIkjO2F4g3eig2APo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=037kO3ZkQp5jd7v0B6lrjZqc+FJBZGCc+tDGbvMxlmyXpT+TjIqzmfDnHk0DyLrPn
	 Zf9GYmnmEkjPTmg5L8zioBZBg1mdEh+bmvB6Pp7oxvkqxNm0HivDPDlNPnxms5yV4o
	 1hf0UiUMmV2gY5jKokeQtNFgaMIh6ZtQgQ3P1fOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/116] ionic: use ee->offset when returning sprom data
Date: Mon, 23 Dec 2024 16:58:38 +0100
Message-ID: <20241223155401.424836199@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 35829a2851fa..d76e63f57ff1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -945,8 +945,8 @@ static int ionic_get_module_eeprom(struct net_device *netdev,
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



