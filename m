Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89B81F75BE;
	Tue, 17 Dec 2024 17:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456577; cv=none; b=Fg4fNxBQTBMJHnArIydrh93bBFEhj1b1XayTkmT++FtJa2upXq8dlqOE9MilJH02oGfMc6CsIYKA9+/CTN5LVRO6J05Y0PNvtHDHnUhRUjloUDD9tkgQg0ShcvBx5NePkmbOb0501v+UBYsuVO+ijSUPvYGiS2Q9LlhpVPyKn38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456577; c=relaxed/simple;
	bh=FTVKhDChdsx37kYpcFshKA45LHF/v9Lu9zRpa6H6SPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYmj+jf/66xJdDHTl0F+dnkLbL8/lmp7/ZoLitzgDg50SGeoAPa/ED0JMkbTaPWyhHTvtZ/3eladtILgzlhH0Vj+7YyYpezRKWwRaqtGKe0pes7vnmYHfya40BSCpQKlSYSC24N4xchk7EVbdXGdarCvbX0ViUVrhHV9l1ZmiT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fv7eP+D8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fv7eP+D8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343C1C4CED3;
	Tue, 17 Dec 2024 17:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456577;
	bh=FTVKhDChdsx37kYpcFshKA45LHF/v9Lu9zRpa6H6SPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fv7eP+D88gQPaXGayifSBCrfVP56OfgGqdq6kj3Ow2HmB2T6xYnDOwG8FSFNUoCup
	 ya9NAS5Tw8+25xX1d4nslYkAAV3eZjMTw4ynFeiFFtGvCzBb08O1JIMMNAlNfq77UZ
	 hUWnBhcxvIyO3kglYzb7tBB0Wb9uVvATStouAKGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/172] net: mscc: ocelot: fix memory leak on ocelot_port_add_txtstamp_skb()
Date: Tue, 17 Dec 2024 18:07:39 +0100
Message-ID: <20241217170550.597041646@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 4b01bec25bef62544228bce06db6a3afa5d3d6bb ]

If ocelot_port_add_txtstamp_skb() fails, for example due to a full PTP
timestamp FIFO, we must undo the skb_clone_sk() call with kfree_skb().
Otherwise, the reference to the skb clone is lost.

Fixes: 52849bcf0029 ("net: mscc: ocelot: avoid overflowing the PTP timestamp FIFO")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20241205145519.1236778-2-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_ptp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
index e172638b0601..db00a51a7430 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.c
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
@@ -688,8 +688,10 @@ int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
 			return -ENOMEM;
 
 		err = ocelot_port_add_txtstamp_skb(ocelot, port, *clone);
-		if (err)
+		if (err) {
+			kfree_skb(*clone);
 			return err;
+		}
 
 		OCELOT_SKB_CB(skb)->ptp_cmd = ptp_cmd;
 		OCELOT_SKB_CB(*clone)->ptp_class = ptp_class;
-- 
2.39.5



