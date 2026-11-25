Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624564;
	b=fKwUK++WUC1ADXHySsDvi4Zm5HEfCZQXeJEGi70/irHEwNbWgl18pQmXnVt35zdRqQY5
	 ufW+Zr7z4tA4Le2hbQFzkH0OamiWQN0veyUSbwuRom0PhX4IetrKjTrUfY49obL3Tdgj9
	 sq9Xb4hk51/dRZfSxV088SBRPH1QVYSjS9pHGvzpGtSkhPo+uuMSZe44zhNRmq4kE99Uu
	 OuMbJ3vTazLVmF8yfdxweL2YG8HNPurxpw3y1brPpMkXO69Sr1apcu099WTwXEiMaPALG
	 xuDl8as2qkDktvORrulC+cfYeByrwJ8ID1XnJO8kDv/EMS2GHWR8ciZ22/KXhAH5Ayg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8cklMt92i3TVWuiCdNHCmAWhYoNn66Nr7uk449/yvnQ=;
	b=4IKPmPNwb2ieQ9D3+TkLXlJZAcdDRIWmzbPyaI4U92ANG2kF7Iam8pEBoMBVeMknSCz8
	 sTnlUXlruItS0owBc6+5g1Lm2cTn4zwguOf8iZFFyqFGusIanaRja1sB8THAizEhz/Xe4
	 onBcV+jRr2QXYc5V+qMA8IFE5qlIZPWl2XJrZaS9CpYAUwpHQ9PazVPHMwFYqbfXZZ+V5
	 wVU4QLjPgmAZEH0F49xjr+kPXSvo0S0ufwkrc8vseJ/gJ0LEG6Ow6GrAyorU8z4h1ixl3
	 FrbplsQwX/pxP7bvQLDj5CNMU4dupOKsXd4dINY0AJykL06ALqh8Ab0AKMxTZubOMyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJEdTwWI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F1F606A334;
	Wed, 25 Nov 2026 16:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJEdTwWI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0FD1F000D8;
	Wed, 25 Nov 2026 16:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624563;
	bh=8cklMt92i3TVWuiCdNHCmAWhYoNn66Nr7uk449/yvnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJEdTwWIbTKKThAEZcU4FPVQcREEKbTgif441EjuqOr65DiZxuaYEKI2e++Nd9vsZ
	 k0H2qorrRF4kZ+9a6tkgnS9Gf8JYgqO9BGJEVzlWgh++6op77rp43T51QMKxl4S+O5
	 DhJ/C0EA2u3sFKGNGr8SAXRx+FUmMLvvM4JiubaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 235/816] netfilter: nf_conntrack_sip: fix OOB read in ct_sip_parse_transport()
Date: Wed, 25 Nov 2026 15:29:43 +0100
Message-ID: <20261125143854.647020908@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit 7af52bda65c0bbbf40894aa3df36ac1bb5697984 ]

ct_sip_parse_transport() compares the value of the "transport=" header
parameter against "TCP"/"UDP" with strncasecmp(..., 3), but it never
checks that the parsed value is at least 3 bytes long.

ct_sip_parse_param() returns matchlen = end - start, where end is the
next ';' or, when there is no ';', the end of the payload buffer
(limit = dptr + datalen).  If the "transport=" value is only 1 or 2
bytes long and runs exactly to the end of the payload (e.g. a REGISTER
request whose Contact header ends in ";transport=T" with no trailing
CRLF), matchlen is less than 3 while strncasecmp() still reads up to 3
bytes, reading 1-2 bytes past the end of the linearized skb data.

Add a matchlen check before the comparison, mirroring the
sdp_media_type() pattern a few lines below, so short values cannot reach
strncasecmp().

The bug was found by LLM-assisted manual review of the SIP helper's
parsers and confirmed with a userspace ASan harness built from the
verbatim parser functions, which reports a heap-buffer-overflow read of
size 2 in strncasecmp() called from ct_sip_parse_transport().

Fixes: ea45f12a2766d ("[NETFILTER]: nf_conntrack_sip: parse SIP headers properly")
Link: https://patch.msgid.link/20260815133104.50369-1-joasantonio108@gmail.com/
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_sip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 449a6e53feae4..12b8c7fcca640 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -707,9 +707,9 @@ static int ct_sip_parse_transport(struct nf_conn *ct, const char *dptr,
 
 	if (ct_sip_parse_param(ct, dptr, dataoff, datalen, "transport=",
 			       &matchoff, &matchlen)) {
-		if (!strncasecmp(dptr + matchoff, "TCP", strlen("TCP")))
+		if (matchlen >= 3 && !strncasecmp(dptr + matchoff, "TCP", 3))
 			*proto = IPPROTO_TCP;
-		else if (!strncasecmp(dptr + matchoff, "UDP", strlen("UDP")))
+		else if (matchlen >= 3 && !strncasecmp(dptr + matchoff, "UDP", 3))
 			*proto = IPPROTO_UDP;
 		else
 			return 0;
-- 
2.53.0



