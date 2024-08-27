Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E001C6F56;
	Tue, 27 Aug 2024 15:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771935; cv=none; b=YGvi7HlmTQxEbRtGkLZdwSEwpPfjL1gt46aUR5rnJmOsTnClrlHFrXNXOXFe+aRI6z8vGpnOlazkARRIU6zNwgay+CzPIr3dOiLkdQ4wg8gx3oOZl9MdEIKzsodBOfhB5xepz7Uj05jTATogUID1rqF3a18cY0qfgKP/srbJvIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771935; c=relaxed/simple;
	bh=UW6THs8ZwpTU6s1K5lDfEMI35inB5dAQIoNnoY5GaoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abiMwm5GaUxqDEX5My14+5ArsCy9zBYUdWA02R5dBJMz6IuhGsy2rxv6PoegF8gCSe5/aUlIxYO0LAgxe3STQ2bGkUYiknYugBq9jnkcBmn1Z32UDyjY5aKdbdT5WUm42t8shlfpJb/1Rm1lN1DmjBBYYbt3RixMk+6oZNcAxyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dn89lj4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dn89lj4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8944CC61067;
	Tue, 27 Aug 2024 15:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771935;
	bh=UW6THs8ZwpTU6s1K5lDfEMI35inB5dAQIoNnoY5GaoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dn89lj4vhjoN/vIbgUpQL8A5Axm9IWO9YMRWy5Yuqdx3nBL2jdvgdJi3lqMpgnOs9
	 pA+HJMDonaRKVSyL/MoFsaFcJ+SQE4yN7vIiY6sAsIL044CpbAY1tLMfk0Voe4DtEy
	 b9rq/HvW4kKz1hBIcQ/XbS70wVpUTrUPAWJXfRnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/321] wifi: cfg80211: move A-MSDU check in ieee80211_data_to_8023_exthdr
Date: Tue, 27 Aug 2024 16:36:11 +0200
Message-ID: <20240827143840.636374629@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 0f690e6b4dcd7243e2805a76981b252c2d4bdce6 ]

When parsing the outer A-MSDU header, don't check for inner bridge tunnel
or RFC1042 headers. This is handled by ieee80211_amsdu_to_8023s already.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230213100855.34315-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 9ad797485692 ("wifi: cfg80211: check A-MSDU format more carefully")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 1665320d22146..4680e65460c85 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -631,8 +631,9 @@ int ieee80211_data_to_8023_exthdr(struct sk_buff *skb, struct ethhdr *ehdr,
 		break;
 	}
 
-	if (likely(skb_copy_bits(skb, hdrlen, &payload, sizeof(payload)) == 0 &&
-	           ((!is_amsdu && ether_addr_equal(payload.hdr, rfc1042_header) &&
+	if (likely(!is_amsdu &&
+		   skb_copy_bits(skb, hdrlen, &payload, sizeof(payload)) == 0 &&
+	           ((ether_addr_equal(payload.hdr, rfc1042_header) &&
 		     payload.proto != htons(ETH_P_AARP) &&
 		     payload.proto != htons(ETH_P_IPX)) ||
 		    ether_addr_equal(payload.hdr, bridge_tunnel_header)))) {
-- 
2.43.0



