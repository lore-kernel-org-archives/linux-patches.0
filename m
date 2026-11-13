Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590275;
	b=kH4GaWvL036BnPbEtQX0enaWDWPFGpKz9APoO5sDRVGRlqktidyt9vcCjahQIZKyEHCL
	 2fjSvBeEQARlEU9N8Ms2021k2s9L59fiZNyKrTHS6CNDN9UHhZnYaZQztz9yj1RTXL79N
	 k/Em6+T3Ejjh6A1VgpmO1bSjrRTTAQ2vNvBBavmIOkQC3s+cQ3PIPGuy0t8Fb2dMBN9rI
	 Js05cPqBOK4ER5iERSfgonQMxHUI39210mK2AYfScq40+GHoc6HcG9+KtYXOFap0dvOIJ
	 4JEl/Lnr733yPcU4m8idicMyOujGTmTfe8bHzLA0hn9nAirNDdYUeQmnGLHZAX5SJxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=akt4s72ZpPIKsH2WLqNtV15h5ZiFb/dXjpAzcPGzkeE=;
	b=tFHKCzbvPIlha1wtdBYQUIyRPvTxvGiPhDAc7YHR4AaTW+UhiV6Z5muETeIzT5YLmCnO
	 2ERVkuzKN+6DQ0ba3DJZQ/s48/FmCI9pTQujzt9oagNjPnZHvCtCCoFnOP7qljDqi6AlU
	 Hh8oSbGk5FWMLuRiwj8W+n6FjjSJKYLtbtp+aC24xycYYOFLsd5687PDOWddOaeI+9Pt1
	 vfDCE/A+fHMehLgV2BMebViXG/1DzHGgZn0X+mLiGOvTrTUfY917WoG+SVw6zX74xMTKJ
	 Zi2OzDithd04HLnvQYW2wt7UlBf4NPLLsNukCGKDh31gWTYCfma2P0USataif/B31LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XpheU5vr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C03606B20E;
	Fri, 13 Nov 2026 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XpheU5vr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1ED31F000C4;
	Fri, 13 Nov 2026 17:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590275;
	bh=akt4s72ZpPIKsH2WLqNtV15h5ZiFb/dXjpAzcPGzkeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XpheU5vrdAMv6ky1unydYh0Cx++4tzY+5bXX+ILIaEmtUeSgYnlpCyuYBrTcahbul
	 p7Pf67Q7/QiGjWfHqUQnSLB166aluhNkuG7mmtXR2dXG1l0WlnWBqIsA34HuumtNTM
	 s4djHvhn3xCDOudkvYVYGWeDbvCYoGqShaqMcsyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 265/686] cipso: fix optlen corruption in cipso_v4_delopt()
Date: Fri, 13 Nov 2026 10:46:38 -0500
Message-ID: <20261113153830.005092149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qihang <q.h.hack.winter@gmail.com>

[ Upstream commit 1f1f8e8c5176234fa31858cd25f2e9b88aac0a45 ]

cipso_v4_delopt() recomputes the option length by walking the option
buffer after the CIPSO option has been moved out.  The walk then reads
the stale bytes at the tail of the buffer as option data, and a crafted
setsockopt(IP_OPTIONS) buffer can make it treat one of them as an option
length, increasing opt->opt.optlen beyond the valid option data.

The corrupted length stays on the socket and is later used as the copy
length by getsockopt(IP_OPTIONS) and by the udp/raw/ping sendmsg paths,
where it exceeds the size of the buffers they copy into.

Compute the new length from the intact options before the move and
subtract the CIPSO length, and fill the padding with IPOPT_END.

Assisted-by: LLM
Fixes: 014ab19a69c32 ("selinux: Set socket NetLabel based on connection endpoint")
Cc: stable@vger.kernel.org
Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/cipso_ipv4.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index e741f0a47afbd..793c556c206d7 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -2014,6 +2014,10 @@ static int cipso_v4_delopt(struct ip_options_rcu __rcu **opt_ptr)
 		cipso_ptr = &opt->opt.__data[cipso_off];
 		cipso_len = cipso_ptr[1];
 
+		optlen_new = cipso_v4_get_actual_opt_len(opt->opt.__data,
+							 opt->opt.optlen);
+		optlen_new -= cipso_len;
+
 		if (opt->opt.srr > opt->opt.cipso)
 			opt->opt.srr -= cipso_len;
 		if (opt->opt.rr > opt->opt.cipso)
@@ -2027,11 +2031,12 @@ static int cipso_v4_delopt(struct ip_options_rcu __rcu **opt_ptr)
 		memmove(cipso_ptr, cipso_ptr + cipso_len,
 			opt->opt.optlen - cipso_off - cipso_len);
 
-		optlen_new = cipso_v4_get_actual_opt_len(opt->opt.__data,
-							 opt->opt.optlen);
 		hdr_delta = opt->opt.optlen;
 		opt->opt.optlen = (optlen_new + 3) & ~3;
 		hdr_delta -= opt->opt.optlen;
+
+		memset(&opt->opt.__data[optlen_new], IPOPT_END,
+		       opt->opt.optlen - optlen_new);
 	} else {
 		/* only the cipso option was present on the socket so we can
 		 * remove the entire option struct */
-- 
2.53.0



