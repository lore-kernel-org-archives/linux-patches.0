Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C756751B167;
	Wed, 30 Sep 2026 17:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789352; cv=none; b=tWVQqeIALnoow2V9OOyy10ZgGgS1O+5tZwkQPUuKFElMNqWeldimQRZ82CNh+1vzBKHi4CT3wRGLd2qwvqN/M0kROi6YuW8FSbPYS4LOQj1o1WOEnDI82/kFfCwvR0W+fzPBlhCHs6ORVL8daHu8nwmZxVuBP+J/0K/DYFEbU1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789352; c=relaxed/simple;
	bh=T38Z0wC0ESkLz4MQlSoFY8QA/tWxIGZCi3hdnM/PW8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XO5ZovNIxr8eRWbF0bIY5XIB9WnzgQgw2teo7WEehQOCB3vIFrUGQsktG5tuPXOzKARjrR0FrXUu//UqHP5LsohJlQA9lSSdUu/VDvm6Ho7lu+pjIajLvne3Ec3Cq13mxfoHCDbHwqgT6wxJ86EIkvn6a+D1tujfkqDTeeex800=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcICJFuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcICJFuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3234D1F000FF;
	Wed, 30 Sep 2026 17:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789351;
	bh=KAJJIYUnwp07joxcq1NoA8i9bhtcQSbqJWn1kjgPJic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NcICJFufzWLguym4WwCULUMG2j0tUqh1pqTxmfmZZ1BQqGi2atnCKNlRpXLC/YZNY
	 GeSTUV06066shrZIjSXOkZ+mXiIxR1CgKF9u/WWHb4hVcyFkoOjMzD7XmngjVfbre5
	 j4OTuikY3RyXr9BBzn4bLhGrpK82uDj6miwlx7dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	bridge@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 445/877] bridge: check llc_mac_hdr_init() return value in br_send_bpdu()
Date: Wed, 30 Sep 2026 17:22:36 +0200
Message-ID: <20260930152424.284742218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ac704ff08e511c87643799c385f55ecd69b85e03 ]

If llc_mac_hdr_init() fails (for instance if the port device type does
not support LLC or dev_hard_header() fails), br_send_bpdu() should drop
the skb instead of resetting the mac header to the LLC payload and
transmitting a malformed frame.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Closes: https://lore.kernel.org/netdev/179022851638.2160803.1808206741379444999@kernel.org/
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: bridge@lists.linux.dev
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260924082951.1599377-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_stp_bpdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index 7895489ac6fe7..e44e448b1157b 100644
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -52,7 +52,10 @@ static void br_send_bpdu(struct net_bridge_port *p,
 			    LLC_SAP_BSPAN, LLC_PDU_CMD);
 	llc_pdu_init_as_ui_cmd(skb);
 
-	llc_mac_hdr_init(skb, p->dev->dev_addr, p->br->group_addr);
+	if (llc_mac_hdr_init(skb, p->dev->dev_addr, p->br->group_addr)) {
+		kfree_skb(skb);
+		return;
+	}
 
 	skb_reset_mac_header(skb);
 
-- 
2.53.0



