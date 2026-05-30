Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334042F25E4;
	Sat, 30 May 2026 16:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158575; cv=none; b=aTKegS/buTMqCkBQFubX3rVlz24YweRsqe58yTyEiVCSF+TV6O3C4uIia6b4o6dvG0b+rqTvvmAnyD2gu6nT/OwPcC7uMT1iAkV3j/D/BHADUWW4lz5fzUMcFYxpHzf06zg2uUs6orD7CKbAXb3G2x93TdTGqdL+COoV0ZfjXKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158575; c=relaxed/simple;
	bh=ErBUAvBNMpFhdFMszEwgqVJXRt/CHqEkybEW1dfQBEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bj8xWh4MV1m0OdfxVkdyPEqxO6pa46PEYW4nKAzDI2on1i3FS8AOM1U+twZPnoSCU/MYtbwwkYC9B3+nL/9HI0zwPcAFxXrc0XM0iaq88UN/R1xviKs7/0/Gf/WGr/7UUTjUosO2FXVsjukWyFoAMCYM3mLOUWeCqzKtDOrjqA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rm/JxTx/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rm/JxTx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA1E1F00893;
	Sat, 30 May 2026 16:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158573;
	bh=07CYtraxm6jvclQbM2CiZRHMhea+JRkRR2MSiRn+zvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rm/JxTx/b8yuWrHzsv91/REVUNC5h/Hemes67u2QztOUG1dq34cpx7F5HJavnR1mQ
	 csdlDc+30Ccw9zn00ueqW0lF/uYWoDS1SgePGWuOAOYOB1liiNLNx0eaGuq3bpX47v
	 hoBA60n4LY73HILbScaqB6x3HDc1+VBGnwO+ArXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/969] ipv4: icmp: fix null-ptr-deref in icmp_build_probe()
Date: Sat, 30 May 2026 17:52:39 +0200
Message-ID: <20260530160301.398177204@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiqi Sun <sunyiqixm@gmail.com>

[ Upstream commit fde29fd9349327acc50d19a0b5f3d5a6c964dfd8 ]

ipv6_stub->ipv6_dev_find() may return ERR_PTR(-EAFNOSUPPORT) when the
IPv6 stack is not active (CONFIG_IPV6=m and not loaded), and passing
this error pointer to dev_hold() will cause a kernel crash with
null-ptr-deref.

Instead, silently discard the request. RFC 8335 does not appear to
define a specific response for the case where an IPv6 interface
identifier is syntactically valid but the implementation cannot perform
the lookup at runtime, and silently dropping the request may safer than
misreporting "No Such Interface".

Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
Link: https://patch.msgid.link/20260402070419.2291578-1-sunyiqixm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 309d22f2858cc..7a6e4853cf98d 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1130,6 +1130,13 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 			if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in6_addr))
 				goto send_mal_query;
 			dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
+			/*
+			 * If IPv6 identifier lookup is unavailable, silently
+			 * discard the request instead of misreporting NO_IF.
+			 */
+			if (IS_ERR(dev))
+				return false;
+
 			dev_hold(dev);
 			break;
 #endif
-- 
2.53.0



