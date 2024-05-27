Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7E361FDF;
	Mon, 27 May 2024 19:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838718; cv=none; b=LBbksxzSuAbDm9FvqL+yBlbdEfZvOvXJ4S9OYJyIfpA7FPbj2AH5nGYmBJ9+0l3i3GezScP6f2pnOSzPdYhj3AVcQQYY7kuY5jJtF2cb0ShXQ5E9o9EZjuaeWnV2aFF+1mAHXvd5nRVaJtPBrmp/NlXd0DGRbOB83ERYulcyhQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838718; c=relaxed/simple;
	bh=qOKT+d++txsEunqUw1nMQsZa2Bfcivzd5zP8msWjZRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZmgqaGboHaLlUF1ZG5tNFWREnOOcemx22WtVVHhK1hHCCcbqEf+TOGl+SKqo2+XTWwJvFZG8cQVtpju/MAP0ASDz+7vWr05+FY6j4LKvlcs3BoKvv96+oIOA8gC9SXRjvHg8ZLlpclC/FHP75gHxYsZ+/l7EuX/PIcNRgVQ1ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNQMXmWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNQMXmWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98139C2BBFC;
	Mon, 27 May 2024 19:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838717;
	bh=qOKT+d++txsEunqUw1nMQsZa2Bfcivzd5zP8msWjZRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNQMXmWjJeQEzR6H7DuTp4A/LlgU44FYS8GC6+/tfCzNjjmCY2dYPkJetGkdcpYL1
	 yUJULpSnEe0wJQyuSiuQNQfZQM0crqL+LvBYPmUfTBMdi5tZ4BBl7/tBJjHikpMffT
	 LmfEU60ILMXgaXrc8SLULrLaSsGRClaoJFuqkIe8=
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
Subject: [PATCH 6.8 481/493] af_packet: do not call packet_read_pending() from tpacket_destruct_skb()
Date: Mon, 27 May 2024 20:58:03 +0200
Message-ID: <20240527185645.880770291@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index e6a8701a38dbe..91c9dc0108a2d 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2522,8 +2522,7 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
 		ts = __packet_set_timestamp(po, ph, skb);
 		__packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
 
-		if (!packet_read_pending(&po->tx_ring))
-			complete(&po->skb_completion);
+		complete(&po->skb_completion);
 	}
 
 	sock_wfree(skb);
-- 
2.43.0



