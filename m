Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A34D2080F4
	for <patches@lists.linux.dev>; Tue, 10 Dec 2024 11:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733830309; cv=none; b=TB/o4Dj5tdsHKpl7kuA/iYyY0H45ab5DBPQaSf7k6pwkR75Z01mQUIh4Yz+MBZqrdIL/KB1Kpg+clEAkPncSr9s4HH39aW3/klP6WWOGjUT6UYbjZ5z7BNQnzBWBiCxy7iy/Eg0b6GMT9vIkt7NSdhBRkP7d4F1I07cfQ1n+82Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733830309; c=relaxed/simple;
	bh=cZ4sSOoGilGIPjML17LHic3HXreLrdsE7CJXpdJ3Wn8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lP8JdmE2FV4+rOpIByTAxYchRmsXEY3/ixVvBGtb/Uow4jjPd/R1IX6cyzd7CtNv5+0kPAF6vfzojOd1X2NnhM+Zys7FZKL5hPo5CUjGXHrvApv5nddnG+JguSbS1Zpk0b9JoONAaowMn4ZtgcjN/GgNRgNrNrrQtykslvyAUrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=SWLjclN5; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="SWLjclN5"
Received: from hwang4-ThinkPad-T14s-Gen-2a.. (unknown [120.85.107.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id D1B9A3F783;
	Tue, 10 Dec 2024 11:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1733830299;
	bh=qQ8en6fa7o9vYDJDzDILW8HVhQyOc7wmasOfhV+YsFM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=SWLjclN5JUw1ll+49u6Hyk24/lSGsMUHPBMmlmgp0cxU5+mEjnX/e+FxVlXzb6YgN
	 n7P+RGoVLKkaQMAV2Q1Pu3Xy0UDFIV8P/A7r5RUiH9jR510etbcGochJo8fhxCDiQU
	 X0YGvexzJxL5TmJ1vFNjLV27EcutSAePlxNjrVcjiBvOhcUgmnimeLjXMfEtFOaQFc
	 7+VjbxFyKrVsyi3feBKpemSYBWRbOzgL1/N8KqugvWc10U70OTw10hDesEkmEA/8Lp
	 EciPIvjhNsa+2yaWJdWUnaRKggiphmIrNasF+DIYL+SW8IZLugV2v+KyAkQ7YaJhku
	 0X4WPpEFlg6KQ==
From: Hui Wang <hui.wang@canonical.com>
To: stable@vger.kernel.org,
	patches@lists.linux.dev,
	gregkh@linuxfoundation.org,
	sashal@kernel.org
Cc: hvilleneuve@dimonoff.com,
	hui.wang@canonical.com
Subject: [stble-kernel][5.15.y][5.10.y][PATCH v2] serial: sc16is7xx: the reg needs to shift in regmap_noinc
Date: Tue, 10 Dec 2024 19:31:26 +0800
Message-Id: <20241210113126.46056-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recently we found the fifo_read() and fifo_write() are broken in our
5.15 and 5.4 kernels after cherry-pick the commit e635f652696e
("serial: sc16is7xx: convert from _raw_ to _noinc_ regmap functions
for FIFO"), that is because the reg needs to shift if we don't
cherry-pick a prerequisite commit 3837a0379533 ("serial: sc16is7xx:
improve regmap debugfs by using one regmap per port").

It is hard to backport the prerequisite commit to 5.15.y and 5.10.y
due to the significant conflict. To be safe, here fix it by shifting
the reg as regmap_volatile() does.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
in the V2:
 add Cc:
 fix a typo on prerequisite
 add explanation for not backporting the prerequisite patch to 5.15.y and 5.10.y

 drivers/tty/serial/sc16is7xx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index d274a847c6ab..87e34099f369 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -487,7 +487,14 @@ static bool sc16is7xx_regmap_precious(struct device *dev, unsigned int reg)
 
 static bool sc16is7xx_regmap_noinc(struct device *dev, unsigned int reg)
 {
-	return reg == SC16IS7XX_RHR_REG;
+	switch (reg >> SC16IS7XX_REG_SHIFT) {
+	case SC16IS7XX_RHR_REG:
+		return true;
+	default:
+		break;
+	}
+
+	return false;
 }
 
 /*
-- 
2.34.1

