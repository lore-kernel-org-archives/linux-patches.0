Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907DB4E3242;
	Fri,  9 Oct 2026 14:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556099; cv=none; b=EOPEA/DKRlEqxPaKGxJt1kmo+j5I5DrvI+ZM7xYlntFhABgq1JwvjMMvD1MreVT5boxbEKoNKsmjP2eHiuHZcM09WvAnCt5dmCcEPWTorv6SWtWy6Mu/8Rb10iXiFpGgHxDE6Nlypl1MHTepF0wod4Qe0UlXyJROTDgkWI8xGg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556099; c=relaxed/simple;
	bh=7MD24cFrvD4uMAWyWww80/lI+9p8IU/r40Wx9DPizk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWsqUZOYgt4kyKwmKH0ATMe03JIS5VLQNU1k+vjHO7IkCDyZxag//3F0qES88FmJP+SNWHy6R10VL6hVZMCgUIPB+yLI/k4G+cPXwM72/EobjvW2p5Nc21W74FN18NlLVmxfgYXEw/smeRq2pQVpL2/FdgfJoMbA/uNZTeHH1pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bq4lEiWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bq4lEiWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDE11F000FF;
	Fri,  9 Oct 2026 14:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556098;
	bh=+g7sTPNw0SkOV7t1VhvbQVde5DI1X7a7GLsQFCaB+co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bq4lEiWqMycrlOH40jT2h9X8Igp/akTWb194a1cfs3Y9AP9CgEjVG1shgVmq7lFyo
	 lLdgWbfSF7cKCmG6lviiQI5yzIKEIE2nEuTvb1S33ZzTqcRGqnjXJELAEqiYs1hRiC
	 SxuZ5rCK5kgmgGztyk+dAyEHUcx8Hm+sbzCssyGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 120/428] net: systemport: Fix buffer overflow in bcm_sysport_get_stats()
Date: Fri,  9 Oct 2026 16:07:37 +0200
Message-ID: <20261009140948.829169262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit eb7b84af0ec5c71b4920e999611b466b3784496c ]

When running on SYSTEMPORT Lite, certain statistics are unsupported and
skipped during bcm_sysport_get_stats(). The variable 'j' tracks the
compacted index into the destination data buffer, whereas 'i' iterates
over all elements in bcm_sysport_gstrings_stats.

Because the buffer allocated by ethtool is sized only according to
bcm_sysport_get_sset_count(), storing values at data[i] instead of
data[j] writes past the allocated array bounds, leading to memory
corruption.

Fix this by writing to data[j] instead of data[i].

Fixes: 10377ba7673d ("net: systemport: Support 64bit statistics")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260922232440.598918-2-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 4d06c6ba66418..db627cd15fb7a 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -482,10 +482,10 @@ static void bcm_sysport_get_stats(struct net_device *dev,
 		    s->type == BCM_SYSPORT_STAT_NETDEV64) {
 			do {
 				start = u64_stats_fetch_begin(syncp);
-				data[i] = *(u64 *)p;
+				data[j] = *(u64 *)p;
 			} while (u64_stats_fetch_retry(syncp, start));
 		} else
-			data[i] = *(u32 *)p;
+			data[j] = *(u32 *)p;
 		j++;
 	}
 
-- 
2.53.0



