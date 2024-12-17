Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3171F7568;
	Tue, 17 Dec 2024 17:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455823; cv=none; b=rh8ItI5/D5cKBzaajLxYS+680BLGwyFr5g7l3iJXPBadGhG2Yfh0kjoN9MRGY11+9+TbH+2zGzQ+JrmeCVFNNuEWca/drTIMNV6zs0Deg6Qm5m59o5HJrZ9TBR+/YbKbm26QB5slHelVyWGTsNqvu9Dycfs8rIF4JguaDp7++mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455823; c=relaxed/simple;
	bh=F5YCH1pXhqRNbsNepJwR9e/JxZdZqpxoWsp35FR7iaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wq+LiTXYadPWyTg96kR4nDU2Yx5GTs9ywdXdAKrhyLwfmHy3F9wNx5v3GM1MP8IjjofJMijfPyK3GMY1ZTaaEN2RmlKkrOI+7PpJDVUxJzpybkVXZdj6ru3FIRmeR9J4yMhMJjNk/OXjs5T1nc4t0XyavRAFIB7xVUp3nAbsTMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M49gNQd6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M49gNQd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C788EC4CED3;
	Tue, 17 Dec 2024 17:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455823;
	bh=F5YCH1pXhqRNbsNepJwR9e/JxZdZqpxoWsp35FR7iaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M49gNQd6S7VV9G9wYgz898E+MEy/45b3Oh+JuxdEfrMJBiNQ76bKEnRGAN0iYJDEH
	 2JMS0sH3TQbqP95C9oUpOSw6eMAPd1DufOlk9zBQ+/z8fHBRYuN98+KE3XQw2ZBUbR
	 ouH5jWdXJWPNnMn50AkuYtb8CGWyYhJbth8Sx5yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 44/76] net: mscc: ocelot: fix memory leak on ocelot_port_add_txtstamp_skb()
Date: Tue, 17 Dec 2024 18:07:24 +0100
Message-ID: <20241217170528.093336111@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



