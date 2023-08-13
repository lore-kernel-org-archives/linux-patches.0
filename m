Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8710E9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E1AC433C7;
	Sun, 13 Aug 2023 21:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961831;
	bh=wSjiUeOe2C19RHL0a2hc/ug1bWUNPjaSEfNG3RAtNEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+9EPctemBi2xP8rl3gcM92xU+u+dv2sAKT6lTR7e3PDsem05YgWYgQ2qlzVrs0fJ
	 ZtvA2VdLsjfuiPhHQ2PLzK1Cexu0eiHzJYRVk4hQfE3Z2OxThGGuJgNaRt5wX4VNIV
	 9TpFJbm4vteO9GydPVCSjKouG59P+rcA2Z+DeAmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jen Linkova <furry@google.com>,
	Lorenzo Colitti <lorenzo@google.com>,
	David Ahern <dsahern@gmail.com>,
	=?UTF-8?q?YOSHIFUJI=20Hideaki=20/=20=E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E?= <yoshfuji@linux-ipv6.org>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.4 015/206] ipv6: adjust ndisc_is_useropt() to also return true for PIO
Date: Sun, 13 Aug 2023 23:16:25 +0200
Message-ID: <20230813211725.410162417@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maciej Żenczykowski <maze@google.com>

commit 048c796beb6eb4fa3a5a647ee1c81f5c6f0f6a2a upstream.

The upcoming (and nearly finalized):
  https://datatracker.ietf.org/doc/draft-collink-6man-pio-pflag/
will update the IPv6 RA to include a new flag in the PIO field,
which will serve as a hint to perform DHCPv6-PD.

As we don't want DHCPv6 related logic inside the kernel, this piece of
information needs to be exposed to userspace.  The simplest option is to
simply expose the entire PIO through the already existing mechanism.

Even without this new flag, the already existing PIO R (router address)
flag (from RFC6275) cannot AFAICT be handled entirely in kernel,
and provides useful information that should be exposed to userspace
(the router's global address, for use by Mobile IPv6).

Also cc'ing stable@ for inclusion in LTS, as while technically this is
not quite a bugfix, and instead more of a feature, it is absolutely
trivial and the alternative is manually cherrypicking into all Android
Common Kernel trees - and I know Greg will ask for it to be sent in via
LTS instead...

Cc: Jen Linkova <furry@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>
Cc: stable@vger.kernel.org
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Link: https://lore.kernel.org/r/20230807102533.1147559-1-maze@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ndisc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -197,7 +197,8 @@ static struct nd_opt_hdr *ndisc_next_opt
 static inline int ndisc_is_useropt(const struct net_device *dev,
 				   struct nd_opt_hdr *opt)
 {
-	return opt->nd_opt_type == ND_OPT_RDNSS ||
+	return opt->nd_opt_type == ND_OPT_PREFIX_INFO ||
+		opt->nd_opt_type == ND_OPT_RDNSS ||
 		opt->nd_opt_type == ND_OPT_DNSSL ||
 		opt->nd_opt_type == ND_OPT_CAPTIVE_PORTAL ||
 		opt->nd_opt_type == ND_OPT_PREF64 ||


