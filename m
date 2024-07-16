Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCE8CA40;
	Tue, 16 Jul 2024 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144089; cv=none; b=lG6FI824r/4iVE/wXWhB13AXGCxXViOTZ6ffsZgezWI+eNInXLvErAPUjgrWtgZqF6dXAvdIudSUrhTaFp+isUq6DERMEmeIchmoTXVwxjRiQ8e8iPI/Ap7y0ne9XJ4lgrZsmS0Gjb0ocNJkElcZXhBtTfXsRK/KyiKeCx3tEmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144089; c=relaxed/simple;
	bh=m8OjAEK6M4LMpp0ajU74RrPHHmFstYAdgOjVYbuzoTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PM5PVQn7V2iK20IPp2ApblEQaHrAi/cTY+rpDYqBrIfI56IUDyhfRxnwxww+KDP3JAXijksB4K/hZueFm92vuvqlQ4eYUR4NEbEeG6MuXTHlX4UqHdGSpuYv+xZxdaBtT3SY3KC3NhJYyW7bfRxHA2jSzZxDosd2t3V4HxvSZVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYDrINVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYDrINVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B88AC116B1;
	Tue, 16 Jul 2024 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144089;
	bh=m8OjAEK6M4LMpp0ajU74RrPHHmFstYAdgOjVYbuzoTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYDrINVU0zugJtTBipldYTXpllSflxHuWNuoSV79CgicRNQgdrvR1PH6GIduDRpOh
	 D3hGyKG1UTPtaclTHEKMGX6vyyFNEqaktew98K2hioisHuL/8pLJA/fXlPii0zu2F9
	 8XyyDoaredBx1Fhc1CAMojE8A5At9rP8STfJNldU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/66] tcp_metrics: validate source addr length
Date: Tue, 16 Jul 2024 17:30:59 +0200
Message-ID: <20240716152739.086766985@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 66be40e622e177316ae81717aa30057ba9e61dff ]

I don't see anything checking that TCP_METRICS_ATTR_SADDR_IPV4
is at least 4 bytes long, and the policy doesn't have an entry
for this attribute at all (neither does it for IPv6 but v6 is
manually validated).

Reviewed-by: Eric Dumazet <edumazet@google.com>
Fixes: 3e7013ddf55a ("tcp: metrics: Allow selective get/del of tcp-metrics based on src IP")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_metrics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 60619b1f4acdc..1bfbb8f8e0b7c 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -624,6 +624,7 @@ static const struct nla_policy tcp_metrics_nl_policy[TCP_METRICS_ATTR_MAX + 1] =
 	[TCP_METRICS_ATTR_ADDR_IPV4]	= { .type = NLA_U32, },
 	[TCP_METRICS_ATTR_ADDR_IPV6]	= { .type = NLA_BINARY,
 					    .len = sizeof(struct in6_addr), },
+	[TCP_METRICS_ATTR_SADDR_IPV4]	= { .type = NLA_U32, },
 	/* Following attributes are not received for GET/DEL,
 	 * we keep them for reference
 	 */
-- 
2.43.0



