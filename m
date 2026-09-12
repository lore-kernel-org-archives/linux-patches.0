Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFAA2E06E4;
	Sat, 12 Sep 2026 12:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217732; cv=none; b=AKURmy/ln2HvgyXna2lhSVr1H8MMGhf7HPrs1U2GqdcIEXbxtqaSbRwK0nypquszwy5c9iSNpkt+4ARp5JPDVij3Mtt5Eex8Tf0Ik5GQ5A8mgfkhjK8nvRUxo4IZCk/gnjv64PEmPtMC13nwJ+YNtNgqSrK1gYS1yMTrkiiZF6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217732; c=relaxed/simple;
	bh=RNH+uYgex9UJQU49itmmSOcHRbVtg3vYyqZMnYQs4ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7C0rqnxerZ46ABsLadkaB9x7c3iHcX20Kvo+4Qg7SYooxbd4mAbxwQUvnELiwRzLqVMFJCS5OKF/tU19egds2VBtEcFHx7kVjCB2K4Maxu4bc80lS0TSnNFSAJWFfvdayvWRaOE6+RTy44Ufw/aTBmmAcb5OT2rEy+MfDt3Oao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=It0z4yrf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="It0z4yrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25641F000FF;
	Sat, 12 Sep 2026 12:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217730;
	bh=HdMi9GjWeGNeUAfagCzWowkAD4Sbwr8r3mVQqedIdfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=It0z4yrfa6wmtPrLDIt7kgm6UptBnv2gFQuwuq2WVrRKP9+m26ELVXBzt9QUajfUA
	 1XDVTQaW+98XvF+7/It4qrw++fcxgoUcgwkK6K5WGglxmn8J8JRWuUyo1PCOMgpyaL
	 sRCpu2HpVYXAGmnNBXhf5SyH/bN/BzkqtKbFFpQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0999/1376] iio: light: gp2ap002: re-enable irq if runtime suspend fails
Date: Sat, 12 Sep 2026 08:57:05 +0200
Message-ID: <20260912065629.831002068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil Gautam <nikhilgtr@gmail.com>

[ Upstream commit 5d89e7cbac40057f5241a0832a86ce0fe97e4818 ]

gp2ap002_runtime_suspend() disables the irq before writing OPMOD. If
the write fails, the callback returns an error with the irq still
disabled while the PM core marks the device active again.

re-enable the irq before returning the error so the irq state matches
the active state the PM core restores.

Fixes: 97d642e23037c ("iio: light: Add a driver for Sharp GP2AP002x00F")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/gp2ap002.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/light/gp2ap002.c b/drivers/iio/light/gp2ap002.c
index d82a4c93c9d16..e11aa1c7acf44 100644
--- a/drivers/iio/light/gp2ap002.c
+++ b/drivers/iio/light/gp2ap002.c
@@ -651,6 +651,7 @@ static int gp2ap002_runtime_suspend(struct device *dev)
 	/* Disable chip and IRQ, everything off */
 	ret = regmap_write(gp2ap002->map, GP2AP002_OPMOD, 0x00);
 	if (ret) {
+		enable_irq(gp2ap002->irq);
 		dev_err(gp2ap002->dev, "error setting up operation mode\n");
 		return ret;
 	}
-- 
2.53.0



