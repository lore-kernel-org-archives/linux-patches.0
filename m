Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64711DFD1;
	Sun,  1 Sep 2024 16:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209741; cv=none; b=nPf/O+cka8eNQAGu3m+/SObb+6zfDqeBw98/uaKXNGSK9Zw9T2wejq/wiY3sgQhsX5OkmXui/9cV3iguSB/Mhy9U5TrGs8wKbONCIwa9uo7b0IjDvX7g+Nrt+66Un3/o7+V/OySHrMDknvx7gRuJ0OM5tjk8pJOrdTKWZ1ue2ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209741; c=relaxed/simple;
	bh=YkKUTYJi/6BsHdKvr2udZTSP9E/0+SrGcrrYPUI0DNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KosxUa6eBcsgMq6R1qtyEvevPslVS/X4MqddYTqhwu/NPpfC8QmY5PwjqXhG4ysRP3p5D5akcRODhNuLKDoYwBZXFjeg/qwuxbInJ6INkXmWG82aud8/8j6XL7oXloXHehCPouhVUclL2Nys7M38CqYZdpxFl5+6Fz7q8zjIEq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=woxIwWQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="woxIwWQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57418C4CEC3;
	Sun,  1 Sep 2024 16:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209740;
	bh=YkKUTYJi/6BsHdKvr2udZTSP9E/0+SrGcrrYPUI0DNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=woxIwWQO5phI9YX+OVoY/3unl+0RfxLUmjPt+1VKukntTAgPxgtxePy/qyZTZphy7
	 voofhiAKLMQ7slFK46U906OIRANY8QFEWzZd5XZTLV0ooqVEZxEP0SURD/mEcO1xxr
	 1fEZVb57uKiASRBf59MmZBK8TcEhcViQ74t3owlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Huang <Joseph.Huang@garmin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/151] net: dsa: mv88e6xxx: Fix out-of-bound access
Date: Sun,  1 Sep 2024 18:17:39 +0200
Message-ID: <20240901160817.838265889@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Huang <Joseph.Huang@garmin.com>

[ Upstream commit 528876d867a23b5198022baf2e388052ca67c952 ]

If an ATU violation was caused by a CPU Load operation, the SPID could
be larger than DSA_MAX_PORTS (the size of mv88e6xxx_chip.ports[] array).

Fixes: 75c05a74e745 ("net: dsa: mv88e6xxx: Fix counting of ATU violations")
Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20240819235251.1331763-1-Joseph.Huang@garmin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/global1_atu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index 1a4781a44e0d7..79377ceb66af5 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -453,7 +453,8 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 		trace_mv88e6xxx_atu_full_violation(chip->dev, spid,
 						   entry.portvec, entry.mac,
 						   fid);
-		chip->ports[spid].atu_full_violation++;
+		if (spid < ARRAY_SIZE(chip->ports))
+			chip->ports[spid].atu_full_violation++;
 	}
 	mv88e6xxx_reg_unlock(chip);
 
-- 
2.43.0



