Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07338436360;
	Tue, 31 Mar 2026 16:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975094; cv=none; b=cjZpGT5OvHl5GPS+zlsPWLaU0CLFqntwJnC6WD91NDyRqoo00WqUANmBbxCMPpfaz9SU6c5Nj7USKUJlyw3yj3Zn03svuIfw8XtV+LmRC94OD3/EZDb+FfIz4mJTpl0rV50DqZnlZgWfV8LMFhsKouBKJeZXfuMz7pQUvj1AEZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975094; c=relaxed/simple;
	bh=ZuVdcd2RRPeLAx88reFwRQWkKfxftd9K6k+xAjIeKdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8mPQnAUhrb2CweW7Fum0x9rKYWyk0GMK9OZCJ9j3k74oeXGr+UNZAiysbROtnglv81EfAvLB9C8ujY0lCitHytkYrzL+4B9wO/9xRV+9IG/5kuO4M2Ddhflw1u1h45WjAwD1ugJ3l99+apakFYS1lH35+OL3iYjIcg4TXilDUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2pb4cKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2pb4cKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930FAC19423;
	Tue, 31 Mar 2026 16:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975093;
	bh=ZuVdcd2RRPeLAx88reFwRQWkKfxftd9K6k+xAjIeKdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2pb4cKFUPpp26oG/7Rh22w/o2DiRxfxc6VNyBfXGBVgPiiUHVINPweSLossBJKMp
	 YYlsg3HCkgQCCtUVV9BhgovdLeq0AjwS0JSaAw8pbkk0oOcinNsetredZRmCPKAgVP
	 AeF6gO46rbHfdK+GgwZ8RGvnv47OU+cv1y0A/n+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thangaraj Samynathan <thangaraj.s@microchip.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 129/342] net: lan743x: fix duplex configuration in mac_link_up
Date: Tue, 31 Mar 2026 18:19:22 +0200
Message-ID: <20260331161803.754197996@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thangaraj Samynathan <thangaraj.s@microchip.com>

[ Upstream commit 71399707876b93240f236f48b8062f3423a5fe97 ]

The driver does not explicitly configure the MAC duplex mode when
bringing the link up. As a result, the MAC may retain a stale duplex
setting from a previous link state, leading to duplex mismatches with
the link partner and degraded network performance.

Update lan743x_phylink_mac_link_up() to set or clear the MAC_CR_DPX_
bit according to the negotiated duplex mode.

This ensures the MAC configuration is consistent with the phylink
resolved state.

Fixes: a5f199a8d8a03 ("net: lan743x: Migrate phylib to phylink")
Signed-off-by: Thangaraj Samynathan <thangaraj.s@microchip.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20260323065345.144915-1-thangaraj.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index e4c542fc6c2b8..09d255e78f6cd 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3054,6 +3054,11 @@ static void lan743x_phylink_mac_link_up(struct phylink_config *config,
 	else if (speed == SPEED_100)
 		mac_cr |= MAC_CR_CFG_L_;
 
+	if (duplex == DUPLEX_FULL)
+		mac_cr |= MAC_CR_DPX_;
+	else
+		mac_cr &= ~MAC_CR_DPX_;
+
 	lan743x_csr_write(adapter, MAC_CR, mac_cr);
 
 	lan743x_ptp_update_latency(adapter, speed);
-- 
2.51.0



