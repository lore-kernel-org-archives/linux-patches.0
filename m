Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0E92AB22
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5221EC433CD;
	Wed, 20 Sep 2023 12:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211617;
	bh=hVo7nXbFCyzkdqmhI7p2LS1Fhh8nYPnJCsIDPmIyV+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dy+gI5gQTk0NwwhIUuLg9eqs8psflD+AlVoE4Uiha71DaKto57nsnVG9P0dxY44GG
	 kptEgkXkPXk782t2dywNbJrQPRn/RCxT/hGq2ro2hQX0s4FSbFK8IUtDNAkyuTU5NR
	 ESr3Sb4zVk5SR6gMVPkJn9yHSPPIcUOYZLn6EIio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Henrie <alexhenrie24@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 133/186] net: ipv6/addrconf: avoid integer underflow in ipv6_create_tempaddr
Date: Wed, 20 Sep 2023 13:30:36 +0200
Message-ID: <20230920112841.815328669@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Henrie <alexhenrie24@gmail.com>

[ Upstream commit f31867d0d9d82af757c1e0178b659438f4c1ea3c ]

The existing code incorrectly casted a negative value (the result of a
subtraction) to an unsigned value without checking. For example, if
/proc/sys/net/ipv6/conf/*/temp_prefered_lft was set to 1, the preferred
lifetime would jump to 4 billion seconds. On my machine and network the
shortest lifetime that avoided underflow was 3 seconds.

Fixes: 76506a986dc3 ("IPv6: fix DESYNC_FACTOR")
Signed-off-by: Alex Henrie <alexhenrie24@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 893b93cc5221a..288e270bd0176 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1283,7 +1283,7 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, struct inet6_ifaddr *i
 	 * idev->desync_factor if it's larger
 	 */
 	cnf_temp_preferred_lft = READ_ONCE(idev->cnf.temp_prefered_lft);
-	max_desync_factor = min_t(__u32,
+	max_desync_factor = min_t(long,
 				  idev->cnf.max_desync_factor,
 				  cnf_temp_preferred_lft - regen_advance);
 
-- 
2.40.1



