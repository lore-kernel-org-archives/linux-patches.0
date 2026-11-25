Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621639;
	b=HlfcxnljjFcHsibjZ/ygrkxnGh+hwY33svspVhNrUtunxlB4ud0sA+0lDyP3d4XqI7nB
	 PSjyr73Uo6nlwXkT5N8b4YDM9jJn11A4tPH9Ol6GF4oImERc44Nk0pLTEw6xJl8lfF8AH
	 6c2Y/e9VLoikyj2MExPBJcreG6Vnx8cMsZw/4pKVm3GD15kkm8EYBxV/d/fFBtS/nhiGr
	 dxbq2iNe41pSviM2zQG8N+8dgzelcQbIhsnC429doQnliQekk/hAMTxGFwHV0Esraog77
	 j5WsDfmhn+de/02Jm/ibYs8F5+7KT5aYZ0nE4+GciSzpQ3Lvw8m6jr19+r9y81Kj1QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QWe5z8ziWHwrzYVFUiR83tzX5lzJ0GICNhKT/n1wH/Q=;
	b=fmVP0rg2FXf1VGGxiIF2ZIGMYR70bDvmVaIC2W4qfw2N8bhx3iVgK2sJ2E19u0yBYPcw
	 KIPbVuWmabwuKHwJqd0unkx7uy7LVv0KJXE/gOsLS1o8x2jLwLaihSZAK1+am7PinvxSP
	 ynLUyY6BHhsciiu9slkKgGg96YXp57QrEXU4yuQeQqtI2KTlEa3T1yAAa6rAzXnz0tc/8
	 vdjHc5OttPQ1/VZhH3L0fxXhSXLhsz3411QGTSjtJsXh6ssYDwrNqVtap/O/QzJHAZKT5
	 Ni3GQpS35+pWUOz6XLHBTaLQZl6f7I8YAncN+rAI/zFIKCZhM3AZwxzpZCMANpApzfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bQ9OQ1ta;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897A1606A32E;
	Wed, 25 Nov 2026 15:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bQ9OQ1ta
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394F81F000C4;
	Wed, 25 Nov 2026 15:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621638;
	bh=QWe5z8ziWHwrzYVFUiR83tzX5lzJ0GICNhKT/n1wH/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQ9OQ1taJIlM2S0i/ZZk3f6v4Vj9b1hOoC0Svz6FGD805ZxiMjYN7grAjSSe5NR+Y
	 /xTsuJPnkf0AXiBlagf6oYSjZ6yOmZZb9WGKkyNuHNBh5Jy7+W5vsgSlRk5Xj88sf5
	 URJYoJTFmheVstpHoJI/C5AkFwezJRvrJiCz340A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 288/990] netfilter: nf_conntrack_sip: fix OOB read in ct_sip_parse_transport()
Date: Wed, 25 Nov 2026 15:27:35 +0100
Message-ID: <20261125143828.833793486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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



