Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2F213B2B4;
	Tue, 27 Feb 2024 13:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042382; cv=none; b=J9q9hBUiqG2jmD2iOsUydL1sIwdEXmM3SAzO5pKc7KsRs4R5xNydytXReyZGyhYpejiJTFu6VoYgiLhsQWa5CASEAznJXOVhM8Yyq/qAtcsNljebmm/Lh4+9khvq1BaoWGVj8GuwwgVoF5xQrr484k8ZENMs2h8lF1xjL/cIeVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042382; c=relaxed/simple;
	bh=42Qh1dH1ct0lZbvviezkLig1Fquw2JuXAWd1+7WWF5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuFjBTM67BfhIbyMBX9JKceNzjK+IZWYoPtV5wnfEU2zBJI0G6wdTMTLcEKxCBCB4HQS4DL3IelnnWYUkPEmOPf4yXu0HAMRJyl2p/AwVpberxx2wl/zlAnkb8BjtELFIL964CC8VKdCwIMUf70iJ6kaTJH1SkamvWDxCfPgtGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=od7E+jun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="od7E+jun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFD1C433C7;
	Tue, 27 Feb 2024 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042382;
	bh=42Qh1dH1ct0lZbvviezkLig1Fquw2JuXAWd1+7WWF5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=od7E+junAJJLbA6xwS4aRV9L9VYvECfqypV7Um/NtBQ7uta/HwSS4opao9JZ7904A
	 IZaq7CjHUG0GwQQ8cftVydU0Z/UXI1fioWYV7CwxvSIgE3rTl9D0RybqvcISq0Q9y8
	 6aURUIKUoOBD350/q0c/fSJgI7MeEWcFfOp+ktOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 248/299] net: bcmasp: Sanity check is off by one
Date: Tue, 27 Feb 2024 14:25:59 +0100
Message-ID: <20240227131633.710135255@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit f120e62e37f0af4c4cbe08e5a88ea60a6a17c858 ]

A sanity check for OOB write is off by one leading to a false positive
when the array is full.

Fixes: 9b90aca97f6d ("net: ethernet: bcmasp: fix possible OOB write in bcmasp_netfilt_get_all_active()")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.c b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
index 41a6098eb0c2f..4b6bf2764bef7 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
@@ -535,9 +535,6 @@ int bcmasp_netfilt_get_all_active(struct bcmasp_intf *intf, u32 *rule_locs,
 	int j = 0, i;
 
 	for (i = 0; i < NUM_NET_FILTERS; i++) {
-		if (j == *rule_cnt)
-			return -EMSGSIZE;
-
 		if (!priv->net_filters[i].claimed ||
 		    priv->net_filters[i].port != intf->port)
 			continue;
@@ -547,6 +544,9 @@ int bcmasp_netfilt_get_all_active(struct bcmasp_intf *intf, u32 *rule_locs,
 		    priv->net_filters[i - 1].wake_filter)
 			continue;
 
+		if (j == *rule_cnt)
+			return -EMSGSIZE;
+
 		rule_locs[j++] = priv->net_filters[i].fs.location;
 	}
 
-- 
2.43.0



