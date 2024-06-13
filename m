Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C7B1465BC;
	Thu, 13 Jun 2024 12:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280036; cv=none; b=LBO6Ub3HcgilBKXvRXoeLNj3Bz8syQV8j/szSrTgmiZ0wBL/OAGylYpUhARbLezCWhkA7qIIlaB6zVVqJXT3PPOPo3+DBqF0Htgb5VISsS6oe4etoR8sKzx8yg090f//uRyRQUb2OOmPrEXDFM68u3pKflli9pRPxgspQRE8sa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280036; c=relaxed/simple;
	bh=y322Da/Bq3Y5aElH9AUOBGGv5yYLZzRTeUQK14voAOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Er4xp7ynMoAKGrr0KQtT7DpNbtZkCCCm/peyCX3sKTvxfOzcMqXOyB1RsaVj8zqnX1BIQJxjD6o/EWec9d140R4rsk5LraCfggu4oOV2CD4U9gDUM0WeuP/fq1wYbv9CLgamfGMf8F+Gkh0oD3sGHc9NLkYLkNjYhbppEyt3G80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cW9G6J4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cW9G6J4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B14C2BBFC;
	Thu, 13 Jun 2024 12:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280035;
	bh=y322Da/Bq3Y5aElH9AUOBGGv5yYLZzRTeUQK14voAOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cW9G6J4VQtMfnt2XK6m4CD9RBQhiqv1AmCEzR1gbYHoudU1z7zPMvFUrOOvfMsEUZ
	 uyFZfXftyOFCUlgx0qheQwerOq0FoFLkBXYyL+Ag0hrGZEZ825KsQ+/DcLOB7rEHTm
	 j8Q+j0LLZtMycMjSH7pFU1f6np0CtqJS/GS6aa8U=
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
Subject: [PATCH 5.4 090/202] af_packet: do not call packet_read_pending() from tpacket_destruct_skb()
Date: Thu, 13 Jun 2024 13:33:08 +0200
Message-ID: <20240613113231.243155951@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9fc020fd7ecc1..1efa42b15c5b9 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2461,8 +2461,7 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
 		ts = __packet_set_timestamp(po, ph, skb);
 		__packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
 
-		if (!packet_read_pending(&po->tx_ring))
-			complete(&po->skb_completion);
+		complete(&po->skb_completion);
 	}
 
 	sock_wfree(skb);
-- 
2.43.0



