Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591085;
	b=eCxYYzq3iQ5UClYPKvq750ETHkvhbqkDts2pAnjawLr43TiLxyeDXWykWJfDStEALZtd
	 s53+ljHSOU8sOGTD0fGRnUTKmi9+ofMSuwGaUiKQiVSttqBVb9xjlYMlKvJQ25FYIGyiR
	 K7qrNJTf4KNdtlp+cEsVQfFvxYOT88wXJLTuEHYYhGv0TraT0knsh9EN2AbHDXNDg1G2+
	 QFFIv64Gj3pkCCCEb1UIGwRzHXT0z+vOBjwH7OJBOgeKbFPTA1k2HtOIefVHzx3BCvPBZ
	 RwdpJncTbyR073JPAkcmk9nuY0ya7QlA41QYRssKRqbRTGk6NBxVFqUhhz4y4dSHDwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iHiBRRPkJmmvOSNXy7zVGG0/PfBmKXBO4RnKDcqISA0=;
	b=tm5Vj7TOoFBAXOr1Pz0MFaUw75FW6T3Ft576tL74MfbUlCEb9eTLq9zyuLoJ2UHnXYHe
	 rUf2gO+JdPjZuQufM6IaWPv6fTj1xqTRFgPq5uDZ+wC7DSi12yLj6DzSY5Rs07dO1SAYz
	 smmJ7fUEyjukPGbLmiDVUu0WrHtuzIe979ohm0soFhwsooImQcIPJ8Csv3TZPE1M/IGSP
	 hju20BII5IIIvNj/pzVv1fYEDoQLjS2Wri6Wa68kPBLSHEJFwerLbKG/S4YS0M4dAP3xE
	 8aMQvCD7h26DNkL1lyOwaXPzObViZVAWbusroe8IaK1uubhPtZEkYFS4NHMcosb8C1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHNiAaA3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4122A606B36A;
	Fri, 13 Nov 2026 17:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHNiAaA3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05B81F000C6;
	Fri, 13 Nov 2026 17:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591085;
	bh=iHiBRRPkJmmvOSNXy7zVGG0/PfBmKXBO4RnKDcqISA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHNiAaA3gykXwhwBgZjnJtJC4oC7vC6Rd/GOgc/+ItQvCwl7hukfEfttSqmOGgjC5
	 cjxfER/8M2UAruBVh7c1l1fvG0MYnJyMQEbzFeIWMuiNeYDAXHwVhIyqzOvq8fXMkw
	 6yAm+M5vR8Nb9AdsqHHulNUQV5VjDlMw/u/0C/iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 239/670] cipso: fix optlen corruption in cipso_v4_delopt()
Date: Fri, 13 Nov 2026 10:46:43 -0500
Message-ID: <20261113153819.951145694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 53fcb2089cde2..019c16d6d6955 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -2015,6 +2015,10 @@ static int cipso_v4_delopt(struct ip_options_rcu __rcu **opt_ptr)
 		cipso_ptr = &opt->opt.__data[cipso_off];
 		cipso_len = cipso_ptr[1];
 
+		optlen_new = cipso_v4_get_actual_opt_len(opt->opt.__data,
+							 opt->opt.optlen);
+		optlen_new -= cipso_len;
+
 		if (opt->opt.srr > opt->opt.cipso)
 			opt->opt.srr -= cipso_len;
 		if (opt->opt.rr > opt->opt.cipso)
@@ -2028,11 +2032,12 @@ static int cipso_v4_delopt(struct ip_options_rcu __rcu **opt_ptr)
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



