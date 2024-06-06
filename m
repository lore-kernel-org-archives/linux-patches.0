Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210BB19CD15;
	Thu,  6 Jun 2024 14:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683442; cv=none; b=BF8MGQpUvZCVDD/8tYp0hOKR3Wy24ktvBRxj5DdUk5jiI6SAqzpWc0tR8Mi3toDVWMWD8dUmg08LctcFDpH2opCPa4i+nQjVck8CYG6eUnX4eYGNEFmLCgY4vMPVz3uYH7N3GdK8IEnpk01PX3EeaO0GKiAyqV36aavGiF3HXAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683442; c=relaxed/simple;
	bh=pw2h2HMhCGuI0WylZH27GZBbWzZ9k8HKyUhCNzun5yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+8zgOafzZ+BVSWqll84MRjMr9/7uNOk3LQ1Z+z+vMWd2fgk5sblZvKRlnr8O3zfHDeyfyAOMSfOXKT5FA6C9qaykKHLl1kx9KlZiXkB/KTAqRn0xJzXHJiLeYg+0bBVhBrR4KiiYLQ7XlfMFBR5N+VBLOBxWFiyY2dVnCQM3T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPorjUCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPorjUCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30EBC2BD10;
	Thu,  6 Jun 2024 14:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683442;
	bh=pw2h2HMhCGuI0WylZH27GZBbWzZ9k8HKyUhCNzun5yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPorjUCJwiQ0O4tEnZCGI4H7akxWAC4eYM0WJXY/eg/NbGShDxj564PRiSU/4CbGB
	 PSgE6PJIl4SJJjgXiCV1NQWC9WHcPwgfDaD+4/+a33/5U852bpybu/YTmZzQodCSuE
	 xW63Llnbr3oEBaifOZZ6tGGbMdMjuGhpiEYnVj0Y=
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
Subject: [PATCH 6.6 386/744] af_packet: do not call packet_read_pending() from tpacket_destruct_skb()
Date: Thu,  6 Jun 2024 16:00:58 +0200
Message-ID: <20240606131744.846127612@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index f017d7d33da39..ff1ddf544e179 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2528,8 +2528,7 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
 		ts = __packet_set_timestamp(po, ph, skb);
 		__packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
 
-		if (!packet_read_pending(&po->tx_ring))
-			complete(&po->skb_completion);
+		complete(&po->skb_completion);
 	}
 
 	sock_wfree(skb);
-- 
2.43.0



