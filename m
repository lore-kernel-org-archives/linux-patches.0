Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C238F43C7C1;
	Mon, 17 Aug 2026 14:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978426; cv=none; b=eU40kM6YTIFm5XkmlTujMm2pwRyhDonRIVA8MtgSWGXT/Dg6lqS40dVmYA0NV0+lZyxtN6WSBy73w57Am3MmHdTZaTtn0GQOFklGJB6Jhpur/iNMj3GpBINwtgimfDQaEXXVZB66n2M50rij8CSXegi0kG3R+gFo1oFQx06m0/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978426; c=relaxed/simple;
	bh=AUjAD3BEBcxteYFT1rAErDmrpMycgS7/1MttnLQVsJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o5EQ2Ic64r2AY4eXssHDOk8Ohii8kWp/jjAk1l1Ccsu9lGcyF/XZ+dAF/+/KawTkXIXGEeE7smwAFI72XxePlrgDc4OcJh6QFWPRpg+7VjI9QKgWWurOBYT26fVi+bCwk4Fd3oHhHpw0/gB107OK9KGlvwxa3++p7YFlgwEEhNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUaz1Y1i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUaz1Y1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242251F000E9;
	Mon, 17 Aug 2026 14:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978424;
	bh=Bd3pudSG+NLNddTqxIIyQwv/C8lFXlxtVabp3upmvRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUaz1Y1i0HtjXONsHJXfeIFopPvtSoL1FoPffIz1qtu4SMT7xeLJlp4ltgI22zTtj
	 koivjou4iFfpnrx1jV9ms7ofVy4UFYID6y30KGGTDW7zIjzjFb2gs2Rfh4Rg/w8+PM
	 BN6oMBuWKxVLjVePs7Oxv5TFJPWNbyP7aZiFr95M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/156] net/sched: sch_cake: drop WARN_ON(1) for malformed packets in ACK filter
Date: Mon, 17 Aug 2026 15:32:45 +0200
Message-ID: <20260817132535.838167306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ce9ee43e9ee2b..4331097f813ec 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1282,7 +1282,6 @@ static struct sk_buff *cake_ack_filter(struct cake_sched_data *q,
 
 			seglen = ntohs(ipv6h_check->payload_len);
 		} else {
-			WARN_ON(1);  /* shouldn't happen */
 			continue;
 		}
 
-- 
2.53.0



