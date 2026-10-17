Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497863B6BFE;
	Sat, 17 Oct 2026 17:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256494; cv=none; b=olm3vBglpLmGEnTUzTO933RO5rNWtL4jtugYjF5hRoElW5Wn5urwOYXH0ukTacVFnYJPHTnEMu/JFhtuL04ETPq+ya+bAhpcSXIU+BzldQgOkKrTw2owOeCIXsVtu2RMDEegLjxtlQDiid3dBHyMgZPmSHErh/699bTNqQeWJg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256494; c=relaxed/simple;
	bh=EzVKbSB8m8hl41RBNxaTi36UtnhFQckvfA78roOATNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6eXBUd4uaj8AGtnJFIJeHErCKDzH8nxP9eDxd15/IaI/1Cb2Duhdgxf0HqzytepCO42rbgcxlSkEtT642UXJzvplCm3cLpU1NAO0JI1UPRYEZu0fInRq/DoJHEFYSJxRak2cJJt+pzY/WZ28XmpCasMDig6YITXgfItlLBCbvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZz11VBM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZz11VBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6158A1F000C4;
	Sat, 17 Oct 2026 17:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256492;
	bh=I3CSheoYqYuijSNJxZh294pWFN1WU2zHZxIY1s1E2+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZz11VBM3cf6GSCAn8Xg/cF6RSCbOhc3ojVBc3REET2Lkj8xvJxj8IPJP3getHpp2
	 RSsJEW27V5lWMMhcLrCZT2C5RoBuv5Jxs9A05jrh3ezaz7K7tbHoYEAe0AtmkvS8a+
	 jP0TNqeA+jnOIKOoMgkQGXyCHaahqN3gE21Mke/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0211/1674] net: systemport: Fix buffer overflow in bcm_sysport_get_stats()
Date: Sat, 17 Oct 2026 17:41:23 +0200
Message-ID: <20261017160436.565019538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 23cc2d85994e4..b48e2dfb7d70e 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -516,10 +516,10 @@ static void bcm_sysport_get_stats(struct net_device *dev,
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



