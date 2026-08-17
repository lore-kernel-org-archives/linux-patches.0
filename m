Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BFD3D7D70;
	Mon, 17 Aug 2026 15:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980260; cv=none; b=r78jx0wIPG8U54HXx2Bo8/551CRaybuHt8zvga3nfNzm3KUmOziSTVnotfk+DXOg7aUYY6DYQ2wjDhoggro8O1yFmhU6UwXahedSKgaIW/+nUmWzWFzdsQAeQtTpIW6U+Il5SeZnZj8xHwvrlufAzDXPAmQm0RJyVfXm/8mv5/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980260; c=relaxed/simple;
	bh=sRBm3mOZP9N9wibcN8P/TE16FEyeCQA1hsq6szXKXqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UorEC4a1BKskRBptcZA3Swi13yFtpTnYNbgVapXF1wVk0iohyWqBAZqyHL3aFCPlOiOIq8lDoQAQ4DF6YFrGDLJqnHYVmkse4paYCb5DvBu6P93ombmda8qHdwhXOc66U6cAfZnUnSMcZkBGjSMh0de/EFpdAGn+n6jgMetpgRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjrmauTk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjrmauTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCFA1F000E9;
	Mon, 17 Aug 2026 15:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980259;
	bh=0cd7GnZKO6nOj8EhUtaIAGg1eMv+/HC4okv4X3lIX1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjrmauTkO3EilMnghNVo5GccaznClh/quDWdDrzCiJK5RTD4rUPezpbwRL934Xu9R
	 6oMNoGjMNOtc6ndcG8BOYduHkm1upHbq/Bhb+ZgdhkqfDmLXQx0lHIS+ozVv9CFAZd
	 JkbxC85vmz+cBOfOUiBtfrDiMSd2Vb4RLOeHpZm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 511/609] net/sched: sch_cake: drop WARN_ON(1) for malformed packets in ACK filter
Date: Mon, 17 Aug 2026 15:33:27 +0200
Message-ID: <20260817132600.951216181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e210a676dc340..1c6f2c623939f 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1281,7 +1281,6 @@ static struct sk_buff *cake_ack_filter(struct cake_sched_data *q,
 
 			seglen = ntohs(ipv6h_check->payload_len);
 		} else {
-			WARN_ON(1);  /* shouldn't happen */
 			continue;
 		}
 
-- 
2.53.0



