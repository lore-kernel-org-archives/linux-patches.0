Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BAE81ACD;
	Fri,  9 Oct 2026 14:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555663; cv=none; b=RE3bFDJGmnoQo0lfTfkmog3RoBEcYnhdcBxNLrFUHlk9gYqgXV1/emwCMPc6NIc09xEv2EXSUzCrR0WGe7Gu3ibQGF9zau3N/SwaZpcacpF1LegCHZWpAz2IpbT3oROZ4SqG+QR50f6kQi6v/fz6WI470waXy3tVeZKrO+NHTLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555663; c=relaxed/simple;
	bh=njTWQYBDFeUEu6Tvtl85xdWYNfZmERQxsq54RVhQRRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDxG0jpWev3VfXddiOM3SXhDYzFuiD6FnGkDAsOSdud9eE7j6/T0TdyziBNJllmEZEuCSbE1ImxQrL9kc5Q6Qpb7Zm1i3UsV6QNvCf+fFrds7/eiAWjJnMbWMCeuYkT4eSDnPMKqV8JnpSpBVYNtuRykr2n+oEv696yUn4xXG+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZXgDIxE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZXgDIxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504131F00893;
	Fri,  9 Oct 2026 14:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555659;
	bh=2NuyFymJNzSPreFEfg2s8AGwu6JXGvF/cYWSAfhhI44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZXgDIxEPWoKWzAck9mInT6gQ4kces1BMsz1Bp+Lu/c9Zx01Erhfwi9SwhSLrcP1/
	 glAU7ZpdK4z5YuIlRVjIBLZxqFSzd4XcSdsENgWI6hg5iBmSOUVxQewQQuNGr5jcAT
	 hgo1QfUphZv5Pn2G/s60UaRGIReKhi9iXHTrYbnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/403] net: systemport: Fix buffer overflow in bcm_sysport_get_stats()
Date: Fri,  9 Oct 2026 16:07:36 +0200
Message-ID: <20261009140954.311006780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bc4e1f3b3752d..8bfcfbe696b26 100644
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



