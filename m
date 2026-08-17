Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1880A43C7DE;
	Mon, 17 Aug 2026 13:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974098; cv=none; b=TDjmlZ/RFYM8xcvtE7Ct4DEsRDbbHdTjj9eUgypU0x1BRa3LejaAWT8RyQPz2cFRfh8nEYwMxt/msa7nzVOC9ibguqx9l0gKzby7apPKNlRAIU0oxrGJbSrN8C3wPZrd5lLDvGTtq24KQvZ/fX92EAuxtmhlwnBH/aRaHtPnNKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974098; c=relaxed/simple;
	bh=ed/sIMEQEeU6B4y04Tj0qOi+6Tka+KFDrNd6FXCHAG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q4jyxDoWrNFIm9I46HUZSJIgE2cmhT+8XOPdycmMfIVo1DLzWvcn1nJG5w5Z166+6k3Nq6PZ78KsX6tPDzI6eDkmf0wGE6I3fu1avnkb+SH0ZOhBeft/Ht3TM8BBT41YBSz1KrjksrcaYTDqy7OkeXl4D8MxZLRKwYaZs7ZeR+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDPH2PjQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDPH2PjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5F21F00AC4;
	Mon, 17 Aug 2026 13:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974094;
	bh=RLYGICK31TuO2Nf4LBIhVcR2iWN/J+gAtsqnSK6/zQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uDPH2PjQiL5vGra0QJcaIf8YhEmAH3f/cimMumrWg8LR6ODTE2GaU0yI81D1CK2QP
	 gkFnsu81a0c8Ahbk9GNRlqVCwyD7QnUnYQ+zK+5w/XHaq6NCc/pEZ9BQKTxrkGzK51
	 28OlE57Sqofsw2uEXZ6/pe8BMaLV2ots06da6Ki4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 080/271] net/sched: sch_cake: drop WARN_ON(1) for malformed packets in ACK filter
Date: Mon, 17 Aug 2026 15:30:05 +0200
Message-ID: <20260817132540.030207769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@toke.dk>

[ Upstream commit 2a33516f9ef59ad11844d4fc152f889449b5daf3 ]

The sch_cake ACK filter parses packets to find the TCP header and filter
duplicated ACKs if the flow is backlogged. The parsing code contains a
WARN_ON(1) which can be triggered by a malformed IP header in certain
cases. Depending on the system configuration, this leads either to
either spamming dmesg with warnings, or a panic if panic_on_warn is set.

The code already correctly skips the offending packet in the branch that
triggers the warning, so the WARN_ON itself doesn't really serve any
purpose. So just drop it altogether to avoid the inconvenient side
effects.

Fixes: 8b7138814f29 ("sch_cake: Add optional ACK filter")
Reported-by: Zhiling Zou <zhilinz@nebusec.ai>
Reported-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20260729191417.45665-1-toke@toke.dk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 8965fe252471c..755c42c32bcf3 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1287,7 +1287,6 @@ static struct sk_buff *cake_ack_filter(struct cake_sched_data *q,
 
 			seglen = ipv6_payload_len(skb, ipv6h_check);
 		} else {
-			WARN_ON(1);  /* shouldn't happen */
 			continue;
 		}
 
-- 
2.53.0



