Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641FF7F48C;
	Tue, 14 May 2024 11:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686806; cv=none; b=l4wjcu7g5lvXLtxpb+fklAc5gSs1kXLXDxZfGH9zD3DJZGJuxQXdzoTtINIY4Ld+sg4DlMxLZTzdrbjkZdzfFPsUD6DOgUGj2AOc7IbTrzfWON+9HL5yrpRzsywy5iUdcINEuzK2kxtBb9Im7St7zttvh7OWXx1kOeFbwctXYf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686806; c=relaxed/simple;
	bh=5cbaMsLTpt6hyacAK0up/S/hRlYWBaKzIW6KKTL/ru0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYhq1nS/H61jmakFrbvO77of5N6qk1VmVuDvemUcqDNsk7QWYf1457AaUWaeu6nJLHKdZALc2dn21AnmlVyS+YwlqsSqQTiDnJ1by5aJCXEBw8krXt3qXmdFHMLv386co4cF4lsvWV/mTjOkYek4dhko4gKPEEA8SaL+EeFtNyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dr2GJRAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dr2GJRAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FC3C2BD10;
	Tue, 14 May 2024 11:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686806;
	bh=5cbaMsLTpt6hyacAK0up/S/hRlYWBaKzIW6KKTL/ru0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dr2GJRAHkcNAF2JW6ul2wFU3a1ZTULzzre+wOLxR2efPXBzfc0nYQudmKvOtBxi2p
	 6bopPsJ7MODiPLZmYMCeX8Z8zCM9rw6yqfwLs0/NJYRs6JiQN6EC8guYfDT4uxKLt6
	 mjSx6kMZx2hbmvGvF2LwesvvWwaHY3rXbbQsTPkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/63] ata: sata_gemini: Check clk_enable() result
Date: Tue, 14 May 2024 12:19:50 +0200
Message-ID: <20240514100949.117048580@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit e85006ae7430aef780cc4f0849692e266a102ec0 ]

The call to clk_enable() in gemini_sata_start_bridge() can fail.
Add a check to detect such failure.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_gemini.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/sata_gemini.c b/drivers/ata/sata_gemini.c
index 64b43943f6502..f7b4ed572ce02 100644
--- a/drivers/ata/sata_gemini.c
+++ b/drivers/ata/sata_gemini.c
@@ -200,7 +200,10 @@ int gemini_sata_start_bridge(struct sata_gemini *sg, unsigned int bridge)
 		pclk = sg->sata0_pclk;
 	else
 		pclk = sg->sata1_pclk;
-	clk_enable(pclk);
+	ret = clk_enable(pclk);
+	if (ret)
+		return ret;
+
 	msleep(10);
 
 	/* Do not keep clocking a bridge that is not online */
-- 
2.43.0



