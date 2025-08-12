Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9A72CA9;
	Tue, 12 Aug 2025 18:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025034; cv=none; b=SSOjWBGtFW2Q6mQuYOOo3vR+QmlcKLO2Zr3vUOCN7M8oYf5J/+TNNERh8kDzYH8srELxqY5VMglKiai57jGr7O5QrwWs/I+ipHi6uuAlPl1h54TnGKVdY4a56rTFUA86xZsaIi5eqLpVQfmdlV0n9csGASTcm87510DByCUK6nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025034; c=relaxed/simple;
	bh=b9+oosu0rJTT/oVgHLgO0nqtZhhf4oBGTsJiDnXyKrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTaSzxJuJI9Rnun5otvSUsk1njkqKAW/irM+4bnDp/HdM7ctYjAG2Lqkfubm5xEG/dKRdWB/dOu1cR9qSwIInOT8uT2HKhDdwydVck9Creg3dEPNdARGfJzms+0Erq7pIHslp6PLvm1OFQ4ShcEpr1Eh1AwRoLf327jdmTxTPec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqZTgQ0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqZTgQ0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DB5C4CEF0;
	Tue, 12 Aug 2025 18:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025034;
	bh=b9+oosu0rJTT/oVgHLgO0nqtZhhf4oBGTsJiDnXyKrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqZTgQ0FnQO7FWe0Xxe2NH0aGf6pXfRwubRZJcC0/89DEH7Jw0og3MKbx3om+VbEt
	 fSxGbnYkhmHZ+fCEM/d7fjHsw2ro4uRTX6gG1TSmGVDSXMs54qQ5D6KAPsSMyOdqNZ
	 Q2EUJ8Cf5rDM5pkgyqULXjW9heFYwyT1I0OD9Reo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 550/627] eth: fbnic: Lock the tx_dropped update
Date: Tue, 12 Aug 2025 19:34:05 +0200
Message-ID: <20250812173452.830381221@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohsin Bashir <mohsin.bashr@gmail.com>

[ Upstream commit 53abd9c86fd086d8448ceec4e9ffbd65b6c17a37 ]

Wrap copying of drop stats on TX path from fbd->hw_stats by the
hw_stats_lock. Currently, it is being performed outside the lock and
another thread accessing fbd->hw_stats can lead to inconsistencies.

Fixes: 5f8bd2ce8269 ("eth: fbnic: add support for TMI stats")
Signed-off-by: Mohsin Bashir <mohsin.bashr@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250802024636.679317-3-mohsin.bashr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
index 76c0167319af..553bd8b8bb05 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
@@ -423,10 +423,12 @@ static void fbnic_get_stats64(struct net_device *dev,
 	tx_dropped = stats->dropped;
 
 	/* Record drops from Tx HW Datapath */
+	spin_lock(&fbd->hw_stats_lock);
 	tx_dropped += fbd->hw_stats.tmi.drop.frames.value +
 		      fbd->hw_stats.tti.cm_drop.frames.value +
 		      fbd->hw_stats.tti.frame_drop.frames.value +
 		      fbd->hw_stats.tti.tbi_drop.frames.value;
+	spin_unlock(&fbd->hw_stats_lock);
 
 	stats64->tx_bytes = tx_bytes;
 	stats64->tx_packets = tx_packets;
-- 
2.39.5



