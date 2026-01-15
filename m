Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70113ACA65;
	Thu, 15 Jan 2026 17:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497670; cv=none; b=mQltq5RW+FaXpOR6NAwcLI8CzsyUtWX96RE5w61z2weRbhzi/4N5EX88SpcmmkjR5ImWhCqtVAEjuif0FuGnkG07VfVKnz7lNlaRpw27tw648e1y7zUpJran5WRsp46ZeUo2YAWJUKbyLj3+cg/iEL8CWqyk5r+gAVr5f8ROvw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497670; c=relaxed/simple;
	bh=xhmtJSPw2hDrZbsLOTt6dkOS268yeMxog4JZ0MoqsR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtyDCE9eHEvUtpPOIqXHaC7HQv4zovDyc8NjVAhwJRQwpd0DqopR5rm/5fclEKcsXxkANTUdYMjX+Tt5tnX7CVlSboKz+yxTPny2kTUy+BM49+zMDxkPJeAkjRewgyXVqzdd6IfKbUT0r7I854WuL7pwxU45PFovqWmwTQ2ID/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbLj9Yiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbLj9Yiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32451C116D0;
	Thu, 15 Jan 2026 17:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497670;
	bh=xhmtJSPw2hDrZbsLOTt6dkOS268yeMxog4JZ0MoqsR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbLj9Yiq4vQsbKSLrctu4Y+EWfzX1Qiz/Qd+gF22Lr83SE0T+UgOXuNyqXVralEGn
	 0NWdd6NkMQzW01bWih+0TuxNfz1f2kcrBhnp9NrykABwywrNEr6gHoQusbd2Qs5Ffo
	 xosbq8ejZkqHkhn42th3lHbHReQzsF/uNy42vQ1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/554] net: stmmac: fix rx limit check in stmmac_rx_zc()
Date: Thu, 15 Jan 2026 17:43:47 +0100
Message-ID: <20260115164252.095648166@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alexey Kodanev <aleksei.kodanev@bell-sw.com>

[ Upstream commit 8048168df56e225c94e50b04cb7b0514135d7a1c ]

The extra "count >= limit" check in stmmac_rx_zc() is redundant and
has no effect because the value of "count" doesn't change after the
while condition at this point.

However, it can change after "read_again:" label:

        while (count < limit) {
            ...

            if (count >= limit)
                break;
    read_again:
            ...
            /* XSK pool expects RX frame 1:1 mapped to XSK buffer */
            if (likely(status & rx_not_ls)) {
                xsk_buff_free(buf->xdp);
                buf->xdp = NULL;
                dirty++;
                count++;
                goto read_again;
            }
            ...

This patch addresses the same issue previously resolved in stmmac_rx()
by commit fa02de9e7588 ("net: stmmac: fix rx budget limit check").
The fix is the same: move the check after the label to ensure that it
bounds the goto loop.

Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20251126104327.175590-1-aleksei.kodanev@bell-sw.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 973c60e013344..e056b512c1277 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4983,10 +4983,10 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			len = 0;
 		}
 
+read_again:
 		if (count >= limit)
 			break;
 
-read_again:
 		buf1_len = 0;
 		entry = next_entry;
 		buf = &rx_q->buf_pool[entry];
-- 
2.51.0



