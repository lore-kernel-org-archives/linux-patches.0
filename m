Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB47380;
	Tue, 23 Jan 2024 02:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975747; cv=none; b=cOEOdYXRm52ZJInEDhPsWbPSA4/LBVGmkB/ziAecKjIF9SsgNmaefWYJl8HTLQUOHitQI6f0XmliUHyaHWs0Te8pmcoIKIrDpw4DJhGEY3uksmupY433B8LR1CfUU9zeGADW7a6wxzJ5b/0gXWuxRddO759AoFyEOmaEa0jDGc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975747; c=relaxed/simple;
	bh=BHQhFvi6Z14u7q1CVYFQ94J/rotwdabJ9Jre3PRkSmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6eLZGjfHWvksXVWNwwypAnPeyFPCnaBdq3lBxC1avHYEDYsOS946mYjKOSd/71qiAaVvgd6SfNQwTIAWpdHKijymxGEbXYCxM7Qr5OUBb5N0WLAKh+kCbUOU4AX8tIWbpYMvyeTijKYgW9MnvNOv4hsnbkgzuPRi+Xdn+N+s8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oubv/w0V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oubv/w0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB59C433F1;
	Tue, 23 Jan 2024 02:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975747;
	bh=BHQhFvi6Z14u7q1CVYFQ94J/rotwdabJ9Jre3PRkSmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oubv/w0VxYcDpHtveyKfKh3qOkDv2d08TiIhQEWTaAH4yROJ10n0+y8B1mlu8ypbZ
	 yddQ83DXcFDObSZxeBVf6xXTOchSHcpOi+ou0dii3L1DuhHvf4n0MjwxaXAtxl9bAp
	 nLmIrD/p3tFNnmFeOo4Su+Kp2uoqyg2WDTsZ9qT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Florian Westphal <fw@strlen.de>,
	Peter Krystad <peter.krystad@linux.intel.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang.tang@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 532/583] mptcp: mptcp_parse_option() fix for MPTCPOPT_MP_JOIN
Date: Mon, 22 Jan 2024 15:59:43 -0800
Message-ID: <20240122235828.391050578@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

[ Upstream commit 89e23277f9c16df6f9f9c1a1a07f8f132339c15c ]

mptcp_parse_option() currently sets OPTIONS_MPTCP_MPJ, for the three
possible cases handled for MPTCPOPT_MP_JOIN option.

OPTIONS_MPTCP_MPJ is the combination of three flags:
- OPTION_MPTCP_MPJ_SYN
- OPTION_MPTCP_MPJ_SYNACK
- OPTION_MPTCP_MPJ_ACK

This is a problem, because backup, join_id, token, nonce and/or hmac fields
could be left uninitialized in some cases.

Distinguish the three cases, as following patches will need this step.

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Peter Krystad <peter.krystad@linux.intel.com>
Cc: Matthieu Baerts <matttbe@kernel.org>
Cc: Mat Martineau <martineau@kernel.org>
Cc: Geliang Tang <geliang.tang@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20240111194917.4044654-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index c53914012d01..d2527d189a79 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -123,8 +123,8 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		break;
 
 	case MPTCPOPT_MP_JOIN:
-		mp_opt->suboptions |= OPTIONS_MPTCP_MPJ;
 		if (opsize == TCPOLEN_MPTCP_MPJ_SYN) {
+			mp_opt->suboptions |= OPTION_MPTCP_MPJ_SYN;
 			mp_opt->backup = *ptr++ & MPTCPOPT_BACKUP;
 			mp_opt->join_id = *ptr++;
 			mp_opt->token = get_unaligned_be32(ptr);
@@ -135,6 +135,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 				 mp_opt->backup, mp_opt->join_id,
 				 mp_opt->token, mp_opt->nonce);
 		} else if (opsize == TCPOLEN_MPTCP_MPJ_SYNACK) {
+			mp_opt->suboptions |= OPTION_MPTCP_MPJ_SYNACK;
 			mp_opt->backup = *ptr++ & MPTCPOPT_BACKUP;
 			mp_opt->join_id = *ptr++;
 			mp_opt->thmac = get_unaligned_be64(ptr);
@@ -145,11 +146,10 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 				 mp_opt->backup, mp_opt->join_id,
 				 mp_opt->thmac, mp_opt->nonce);
 		} else if (opsize == TCPOLEN_MPTCP_MPJ_ACK) {
+			mp_opt->suboptions |= OPTION_MPTCP_MPJ_ACK;
 			ptr += 2;
 			memcpy(mp_opt->hmac, ptr, MPTCPOPT_HMAC_LEN);
 			pr_debug("MP_JOIN hmac");
-		} else {
-			mp_opt->suboptions &= ~OPTIONS_MPTCP_MPJ;
 		}
 		break;
 
-- 
2.43.0



