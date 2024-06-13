Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773312F5A;
	Thu, 13 Jun 2024 12:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282135; cv=none; b=k88qXjTqDWSVWFdCAdKgOdBdBCXNiJGxaHSTYSFimTzQlau+UyZrMYluxkhOenUeMjAmqU2YjFNzRUGmQe2WvlVZCF9UwUrqD+ziUfB6wwtf39HHbDeOc+yCM4QNHgbpH/uzRH9vtFgFl3p1f1NgOebEg8wfwrUS5Ttsh3xwfMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282135; c=relaxed/simple;
	bh=Of27dt5brfdNzlBdhhW2OyiG0eZV8rYd2SpMiVcAayo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjwqPt6sKy5Bw0M8UtY19DMJAGOi3VKuxx0+SBAh0ggdiXJ8yOQdv1YKyVcgew6sTLOrLr+1ifvnESV4X7qro9pbgoZYcTttcFUFCNdjFnBAnKNZVDmyrWg+wFhG5g+gBA2IeIBVNKxqf+VHoefj/fcZ1vQwhL5BeouR56XllAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHJbhkW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHJbhkW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33ABC2BBFC;
	Thu, 13 Jun 2024 12:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282135;
	bh=Of27dt5brfdNzlBdhhW2OyiG0eZV8rYd2SpMiVcAayo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHJbhkW7RwCOLM2T7UxAl8niOTMLw0uJKEajDf5kQMhEgpIpsIxtVnqPcj8yZ1Mba
	 NJhLjZjSQk6cM0HxcruLtMvACpRzbxxQJ7c0MaICYBy70Kvw1PcbrWMfpmiByd7fSh
	 YNDZi/iG7aUB3fD1mHNCSfDDuQ6UVoSIpDf6Om20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 174/402] af_packet: do not call packet_read_pending() from tpacket_destruct_skb()
Date: Thu, 13 Jun 2024 13:32:11 +0200
Message-ID: <20240613113308.931363515@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 581073f626e387d3e7eed55c48c8495584ead7ba ]

trafgen performance considerably sank on hosts with many cores
after the blamed commit.

packet_read_pending() is very expensive, and calling it
in af_packet fast path defeats Daniel intent in commit
b013840810c2 ("packet: use percpu mmap tx frame pending refcount")

tpacket_destruct_skb() makes room for one packet, we can immediately
wakeup a producer, no need to completely drain the tx ring.

Fixes: 89ed5b519004 ("af_packet: Block execution of tasks waiting for transmit to complete in AF_PACKET")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20240515163358.4105915-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index cffa217fb3063..0ab3b09f863ba 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2490,8 +2490,7 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
 		ts = __packet_set_timestamp(po, ph, skb);
 		__packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
 
-		if (!packet_read_pending(&po->tx_ring))
-			complete(&po->skb_completion);
+		complete(&po->skb_completion);
 	}
 
 	sock_wfree(skb);
-- 
2.43.0



