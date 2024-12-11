Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5221E1BD9CE
	for <patches@lists.linux.dev>; Wed, 11 Dec 2024 04:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733891156; cv=none; b=Y3eMWhsysgplCgativpTl3Pm4kPXs7bmq1fxIE+cbdOr04nGc0CC02c3Aah7g7r1Z6J3T4lIn5YJ7zkbZg//GmIt9jjoepgLxFRKTZI+R5bDOcIrJPlHp1L3DG0vN9HGpMUdy67OngmMeGRkjFaqVGwdDooInDwLHu8blw7kaog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733891156; c=relaxed/simple;
	bh=Vguh8Ub6sx1uy9nijUTCAUEPmQbQzb+HrQ2XQt8q+Gs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VuMcXK9O/eTEyq2adGvP8MoJTwzwgqaBEGV2Y1GG+tBmdu2oTZ/Y0ECUvqoaaufWgvGaHiYoLjrOCkwqCr7GKdcCOhFqdk1tczf5Itb0cjISd3SfeKDzOUg9DbTUrXqfBUDBsA1GG8PHBqhXfpoZ/BwL7LIBVETBRz2E9tQ9YBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=bQG3Brv/; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="bQG3Brv/"
Received: from hwang4-ThinkPad-T14s-Gen-2a.. (unknown [120.85.107.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 034163F190;
	Wed, 11 Dec 2024 04:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1733891151;
	bh=iNLCcMJRW0KhVg2W0Lljb9GiTrWNZgviSspADUrbV2s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=bQG3Brv/RMcRtCLUEKxRKFASYMu+Hhac9q13qmUTpS7WTOzyIA8t15sMfz4pKG8KT
	 EvBGq378AggX03w3nwI/dT6AU5QqQ1rzQJFJiIIJX/Sl0rCzxWcEbtm7IHtJM8DpkM
	 OuYF+Lwwh98uhCAqw5WaUAQVao5zOPt2VVXXdc3cj54oDXzLKfesRjug+z8yhNFdae
	 iUdnM2MQxbBt6uLQTbBX0sHlT6sQ2mi2PXgQj4+zlR0szSayhB252WCilrUn4OgAwD
	 hNOsVOKm/3aam1PsDHwLLazKpbhxsZpEk0Zm9upUYok+X8d/aJ/1CHnTtRxr129hzH
	 InqOtDAi7Prmw==
From: Hui Wang <hui.wang@canonical.com>
To: stable@vger.kernel.org,
	patches@lists.linux.dev,
	gregkh@linuxfoundation.org,
	sashal@kernel.org
Cc: hvilleneuve@dimonoff.com,
	hui.wang@canonical.com
Subject: [stable-kernel][5.15.y][PATCH 0/5] Fix a regression on sc16is7xx
Date: Wed, 11 Dec 2024 12:25:39 +0800
Message-Id: <20241211042545.202482-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recently we found the fifo_read() and fifo_write() are broken in our
5.15 kernel after rebase to the latest 5.15.y, the 5.15.y integrated
the commit e635f652696e ("serial: sc16is7xx: convert from _raw_ to
_noinc_ regmap functions for FIFO"), but it forgot to integrate a
prerequisite commit 3837a0379533 ("serial: sc16is7xx: improve regmap
debugfs by using one regmap per port").

And about the prerequisite commit, there are also 4 commits to fix it,
So in total, I backported 5 patches to 5.15.y to fix this regression.

0002-xxx and 0004-xxx could be cleanly applied to 5.15.y, the remaining
3 patches need to resolve some conflict.

Hugo Villeneuve (5):
  serial: sc16is7xx: improve regmap debugfs by using one regmap per port
  serial: sc16is7xx: remove wasteful static buffer in
    sc16is7xx_regmap_name()
  serial: sc16is7xx: remove global regmap from struct sc16is7xx_port
  serial: sc16is7xx: remove unused line structure member
  serial: sc16is7xx: change EFR lock to operate on each channels

 drivers/tty/serial/sc16is7xx.c | 185 +++++++++++++++++++--------------
 1 file changed, 107 insertions(+), 78 deletions(-)

-- 
2.34.1

