Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDDD1C824B;
	Tue, 27 Aug 2024 14:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770555; cv=none; b=EziTv+LgkKSYiu3sfREe2OcxZouQhGEeo7RDr4gIIQfzJFrqgF0WOUMWkVZ7BWCuLvQo5QACurMuVy/GDmaK1C18o7SBU6LkTBFcoLbnaOJZdsMPtK8zRsbobzMRWRDx8XuacqfgP/bLNIH+wo+vE+h318ooiTIMBc2ZLnifVJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770555; c=relaxed/simple;
	bh=fn739rP3weeLsGsdEDnhWrSSiYk6+D9r9GiyiyLY7ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ld3xUiycr8tMSxLJhDkZs/FfxGDpRn9XstUIviJRIOSsZPFm2JCD3vmWUgiDmxt16bhHIXrX8f68/ADCnH+U36nnqZ5lnBqtchqG4EKc50lZFukwa85wIkoxTtdp0yWI/PDcK2jTV1z3nMLhYlETYueMhwX5TWpDxATRtRJ8+iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUZB/y9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUZB/y9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8A7C4FDE1;
	Tue, 27 Aug 2024 14:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770555;
	bh=fn739rP3weeLsGsdEDnhWrSSiYk6+D9r9GiyiyLY7ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUZB/y9de6qMBAC7FBPiOvUAk1Z/DFfbBXDKpzAWJ4mJtybD4aqR01rr1VBzwRvk1
	 phgV8VPzr5pfLSd+Ydtj9TDTZC/rEnrV1hrYlbEHp5ncEX391BtIlmIosDvEWDf8LC
	 p9qjZjFW804fUXgjjSiZimEyO9lGfICIPGoIZwMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Tluka <jtluka@redhat.com>,
	Jirka Hladky <jhladky@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Corinna Vinschen <vinschen@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 264/341] igb: cope with large MAX_SKB_FRAGS
Date: Tue, 27 Aug 2024 16:38:15 +0200
Message-ID: <20240827143853.453249887@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 8aba27c4a5020abdf60149239198297f88338a8d ]

Sabrina reports that the igb driver does not cope well with large
MAX_SKB_FRAG values: setting MAX_SKB_FRAG to 45 causes payload
corruption on TX.

An easy reproducer is to run ssh to connect to the machine.  With
MAX_SKB_FRAGS=17 it works, with MAX_SKB_FRAGS=45 it fails.  This has
been reported originally in
https://bugzilla.redhat.com/show_bug.cgi?id=2265320

The root cause of the issue is that the driver does not take into
account properly the (possibly large) shared info size when selecting
the ring layout, and will try to fit two packets inside the same 4K
page even when the 1st fraglist will trump over the 2nd head.

Address the issue by checking if 2K buffers are insufficient.

Fixes: 3948b05950fd ("net: introduce a config option to tweak MAX_SKB_FRAGS")
Reported-by: Jan Tluka <jtluka@redhat.com>
Reported-by: Jirka Hladky <jhladky@redhat.com>
Reported-by: Sabrina Dubroca <sd@queasysnail.net>
Tested-by: Sabrina Dubroca <sd@queasysnail.net>
Tested-by: Corinna Vinschen <vinschen@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Link: https://patch.msgid.link/20240816152034.1453285-1-vinschen@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 4431e7693d45f..8c8894ef33886 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4833,6 +4833,7 @@ static void igb_set_rx_buffer_len(struct igb_adapter *adapter,
 
 #if (PAGE_SIZE < 8192)
 	if (adapter->max_frame_size > IGB_MAX_FRAME_BUILD_SKB ||
+	    IGB_2K_TOO_SMALL_WITH_PADDING ||
 	    rd32(E1000_RCTL) & E1000_RCTL_SBP)
 		set_ring_uses_large_buffer(rx_ring);
 #endif
-- 
2.43.0



