Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A911D8DEA;
	Tue, 15 Oct 2024 11:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993561; cv=none; b=iXzb1R/Zc47XAM7ufSxpVo+DW781GFB6g7GqVONvE1hAyVeBOIho1qXPM1XcT4NvA55LkI87/gt72RunwVrsNnQvvwORSh3Ew/y1KoiI9ZlxprkyeJSTtG4cTFoppB1VNBFuqVV4Cc77AqQUTTVuI4P6MhNlxWEYvvA8I1FMjHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993561; c=relaxed/simple;
	bh=GbIR1UsvOY5uy8Dzce1XKaINA4i7vHF+pMXb8Ox780E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dt/bFv/w2TcA8TnwzJUhaJELDYXpTP4F+PrC61HAAd49VCHdJp80J+R1GNqM9ff7T+mdgRcgPixZKkeU93xkyH4NYDOxlrV66J53xtcCZDG440Mih1Ec8WdVvsyZ5iQw6PL+jAYzqswv4So2UHwqgMkuLloxZs2D+EogXpap/0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUI6JLMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUI6JLMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3E5C4CEC6;
	Tue, 15 Oct 2024 11:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993561;
	bh=GbIR1UsvOY5uy8Dzce1XKaINA4i7vHF+pMXb8Ox780E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUI6JLMlluKpTj8mfwC0FNvXQBjpzKTDMdPzKxd+qqyODxFSW3MmBMvMfiSgIuRKG
	 TvjxYXhfspPHSAcx4IoFLZuopVShAg9TV/vJdmelkGtVJPzPAIleQbelcxTapIl6za
	 XSm5vcuAUtGneO6QeMDV1TvZbTruAvj3Lj+STQ9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Dhruva Gole <d-gole@ti.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 447/691] power: reset: brcmstb: Do not go into infinite loop if reset fails
Date: Tue, 15 Oct 2024 13:26:35 +0200
Message-ID: <20241015112458.089760405@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Davis <afd@ti.com>

[ Upstream commit cf8c39b00e982fa506b16f9d76657838c09150cb ]

There may be other backup reset methods available, do not halt
here so that other reset methods can be tried.

Signed-off-by: Andrew Davis <afd@ti.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20240610142836.168603-5-afd@ti.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/brcmstb-reboot.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/power/reset/brcmstb-reboot.c b/drivers/power/reset/brcmstb-reboot.c
index 884b53c483c09..9f8b9e5cad93a 100644
--- a/drivers/power/reset/brcmstb-reboot.c
+++ b/drivers/power/reset/brcmstb-reboot.c
@@ -72,9 +72,6 @@ static int brcmstb_restart_handler(struct notifier_block *this,
 		return NOTIFY_DONE;
 	}
 
-	while (1)
-		;
-
 	return NOTIFY_DONE;
 }
 
-- 
2.43.0



