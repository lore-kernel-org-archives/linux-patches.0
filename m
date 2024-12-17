Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B2A140E38;
	Tue, 17 Dec 2024 17:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456080; cv=none; b=fZU8wpZhzndX02oU1m4FgX874B6sFDZHfbZX8An5i1PkfWeRYvTw7RlbZ9cGCPmoNBZJ5zBVdK+xZvEhC8nGdxzyRIIkilbTGHlGbzaun22ciBg95t1e09AFplOR/HV9P/1uUoiMAJCiAv4LuyJbbHzS0tLcPbQmEUGl58s/uO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456080; c=relaxed/simple;
	bh=IdgjleOIflbg3bWX6r+nr9u3wUBpbCUSUVKyXrZLcfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFETbSTFmE/AKxz45xc8qoG6R+JP4tMVpjvcWS8jFNQ3BwqxVgCqVBiz7yNrqyXldI7Wjuq5amICyqSiHZs7WJv5QcmDL3YTDbGPXtBWRYNAhnkZQF9RWLf+D4Y4AzqHyE5Trg2Fb8FBdTqTMJi+ShSWsFIc6gxvTa9XF5i2RxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvAGh/QO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvAGh/QO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFE4C4CED3;
	Tue, 17 Dec 2024 17:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456080;
	bh=IdgjleOIflbg3bWX6r+nr9u3wUBpbCUSUVKyXrZLcfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvAGh/QOXnoduoGC3Oq9F53sl2zYZZLUB8oNTVx7QUJutafkp7j53fDH1ZPyYgcK3
	 1spG8ApKfjxYFYEU0mKZPfZcLvc+xubErXCCJHWVIX1tWiEYyp2RtDb7Je/8C2wDdK
	 4pl4WW0/sNM7rIecFd/5MA4zlCTUEp9aDVE4si40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/109] net: mscc: ocelot: fix memory leak on ocelot_port_add_txtstamp_skb()
Date: Tue, 17 Dec 2024 18:07:37 +0100
Message-ID: <20241217170535.585545353@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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
index cb32234a5bf1..3c22652879ac 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.c
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
@@ -692,8 +692,10 @@ int ocelot_port_txtstamp_request(struct ocelot *ocelot, int port,
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



