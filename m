Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87072145B13;
	Thu, 11 Apr 2024 10:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832142; cv=none; b=Kxzmlc1liBwaMrpInPEYf91d7RBm1slWZY8MGWIsU+xtYIHTqQ+0uPYxPd9ITi3bOFSRhzq7Mljl3PEkcMHfciIcF5j2V/kah3awLGG9KPGVdr5GUWao0vXis6QhAjZr2WZvkUrIvwxmUyh65ziqPc444jVZSibp/Qz0nlvKr+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832142; c=relaxed/simple;
	bh=Ekn9Q18Mh0GL7rSLO+8O3L6xZOaoDf+0MnFUJC42qQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dM1ZzEKxHoxokQH1B8U14X5rY+Rlp7Q3QEgH0nLoflkJxFd6WcP0pkrG8MPP8K+qqBH96KpL7/OY7M9TStA1hXa8YCm8aduiivtD7QRvulodnERSaFxOL/8+pyAzkL0mKD88lnJ3efkBfBHyb49GzGx9gDKKs3qtOlEAJfNw+qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=by8AWf51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="by8AWf51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A81C433C7;
	Thu, 11 Apr 2024 10:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832142;
	bh=Ekn9Q18Mh0GL7rSLO+8O3L6xZOaoDf+0MnFUJC42qQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=by8AWf51gW25YGHJfnG72Ec2K2MfNtQXGoQAo+rUmD2w7WEsfA45Z+zd1CLHMOY90
	 rTLNJ2L7GeycEGW+Gk6KxwKBOXaqsVOIZECzUR3S78fiOTMU13yzxsGtl3PUFkPjtT
	 vJAmaD+Y20CqKQ86t1zNyBuwk9l12d1DpWzLTLBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 244/294] batman-adv: Return directly after a failed batadv_dat_select_candidates() in batadv_dat_forward_data()
Date: Thu, 11 Apr 2024 11:56:47 +0200
Message-ID: <20240411095442.916279340@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit ffc15626c861f811f9778914be004fcf43810a91 ]

The kfree() function was called in one case by
the batadv_dat_forward_data() function during error handling
even if the passed variable contained a null pointer.
This issue was detected by using the Coccinelle software.

* Thus return directly after a batadv_dat_select_candidates() call failed
  at the beginning.

* Delete the label “out” which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/distributed-arp-table.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index ddd3b4c70a516..b1cb6ecffceb9 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -687,7 +687,7 @@ static bool batadv_dat_forward_data(struct batadv_priv *bat_priv,
 
 	cand = batadv_dat_select_candidates(bat_priv, ip, vid);
 	if (!cand)
-		goto out;
+		return ret;
 
 	batadv_dbg(BATADV_DBG_DAT, bat_priv, "DHT_SEND for %pI4\n", &ip);
 
@@ -731,7 +731,6 @@ static bool batadv_dat_forward_data(struct batadv_priv *bat_priv,
 		batadv_orig_node_put(cand[i].orig_node);
 	}
 
-out:
 	kfree(cand);
 	return ret;
 }
-- 
2.43.0



