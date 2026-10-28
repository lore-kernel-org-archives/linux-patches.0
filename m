Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215222;
	b=3C/T+miD0kNsgNuxx5JYXZmA9eWBG6WX3VW6qEMq8iDBiJtFSfwDBxXQ9RFHfcxT8e9h
	 aCovAKPUCh29SzmJ9mM+4TOTymXffmPJXz2q29ETtQNSbvetDe+EVd2lsU8EvAM0DspVN
	 5CumdDu8Kiyn67kICKJskcJHMtt+3k4RPxC4aQwXqUbrZDGDPdCH/FvsKhd+GO57QsB8O
	 GbPzAzx1gUdojYydSA7k4EFgLrbj0tjNugz1bETXkHmVeXUEZa3DZA3dqnpFWK3N/07Ck
	 siTZfC3eoeflkd+CHfy+Qh5/95v4R+XtRYGBa+0r/ECJwbSzN7/ceVvAKygqzR8Vtqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FBc5vqIyuFfXwtxjf8UBEtgi7dLe+NRzMDNk6aTHY7E=;
	b=JF248bsViS9knezfHZVJUt6B7jV/XZVkaIEloURK+ZfaurmVzrCc9vffP6mU7kNq1weW
	 PJG0hj/RKCuSu/veJTsZuvXtXg/LLx4Drp+VvsjDFurbO62c+JCDD9MYvH7/ox5guvP5y
	 4SdMErQuqZN7AKxNz+UZh+POhpAaKncJSnuGJ9tRn2n+91x4ZRZHgUVsdPPgT2NBt+IYY
	 VIoQQM00/dQvSMmLgXMW4nCUZ1PfIAdkOeDjDoHLgabAu/2d6Q+4J5AM8/XjCKYOF8iMA
	 ayTD+QHlDO8N8nnwk6T11UmB8ExtX+9+imdc82ZLdzSqNDNyNbNoXoqnsdEGTSlKN9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MvJquC9c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB35606A31A;
	Wed, 28 Oct 2026 19:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MvJquC9c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A911F01825;
	Wed, 28 Oct 2026 19:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215221;
	bh=FBc5vqIyuFfXwtxjf8UBEtgi7dLe+NRzMDNk6aTHY7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MvJquC9cjtBEsyjxol9fiboDoaKF4DWyw0tcgzQ64qplAlrVp3WgVNvDNnY/1KK60
	 nTHkEoltKUzmpBA3w6HMqMaFHv6JQH5q/Gc2AgA0EX4c+hrUwAXiOz/ixHLlGQx9mH
	 RbMV/LVXqnWIQc2jV2qgeYQouTN/7soOGFEttYx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1091/1887] sctp: validate embedded INIT chunk and address list lengths in cookie
Date: Wed, 28 Oct 2026 17:53:07 +0100
Message-ID: <20261028170524.234289312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 6f4c80a2a7e6d06753b89a578b710a2499a5e62b ]

sctp_unpack_cookie() only checked that the embedded INIT chunk length
did not exceed the remaining cookie payload, but did not ensure that the
INIT chunk is large enough to contain a complete INIT header.

A malformed COOKIE_ECHO can therefore carry a truncated INIT chunk whose
length field is smaller than sizeof(struct sctp_init_chunk).  Later,
sctp_process_init() accesses INIT parameters unconditionally, which may
lead to out-of-bounds reads.

In addition, raw_addr_list_len is not fully validated against the
remaining cookie payload. When cookie authentication is disabled, an
attacker can supply an oversized raw_addr_list_len and cause
sctp_raw_to_bind_addrs() to read beyond the end of the cookie. The
address parser also lacks sufficient bounds checks for parameter headers
and lengths, allowing malformed address parameters to trigger
out-of-bounds reads.

Fix this by:

- requiring the embedded INIT chunk length to be at least sizeof(struct
  sctp_init_chunk);
- validating that the INIT chunk and raw address list together fit
  within the cookie payload;
- verifying sufficient data exists for each address parameter header and
  payload before parsing it.

Note that sctp_verify_init() must be called after sctp_unpack_cookie()
and before sctp_process_init() when cookie authentication is disabled.
This will be addressed in a separate patch.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/75af23a89adf881a0895d511775e4770da367cbf.1780873427.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/bind_addr.c     | 11 ++++++++++-
 net/sctp/sm_make_chunk.c | 12 +++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index 6b95d3ba8fe1c..0947b276d1e08 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -275,6 +275,16 @@ int sctp_raw_to_bind_addrs(struct sctp_bind_addr *bp, __u8 *raw_addr_list,
 		param = (struct sctp_paramhdr *)raw_addr_list;
 		rawaddr = (union sctp_addr_param *)raw_addr_list;
 
+		if (addrs_len < sizeof(*param)) {
+			retval = -EINVAL;
+			goto out_err;
+		}
+		len = ntohs(param->length);
+		if (addrs_len < len) {
+			retval = -EINVAL;
+			goto out_err;
+		}
+
 		af = sctp_get_af_specific(param_type2af(param->type));
 		if (unlikely(!af) ||
 		    !af->from_addr_param(&addr, rawaddr, htons(port), 0)) {
@@ -291,7 +301,6 @@ int sctp_raw_to_bind_addrs(struct sctp_bind_addr *bp, __u8 *raw_addr_list,
 			goto out_err;
 
 next:
-		len = ntohs(param->length);
 		addrs_len -= len;
 		raw_addr_list += len;
 	}
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 649384ff0e547..742ba54755e8b 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1750,8 +1750,9 @@ struct sctp_association *sctp_unpack_cookie(
 	struct sk_buff *skb = chunk->skb;
 	struct sctp_cookie *bear_cookie;
 	__u8 *digest = ep->digest;
+	struct sctp_chunkhdr *ch;
+	unsigned int len, chlen;
 	enum sctp_scope scope;
-	unsigned int len;
 	ktime_t kt;
 
 	/* Header size is static data prior to the actual cookie, including
@@ -1779,6 +1780,15 @@ struct sctp_association *sctp_unpack_cookie(
 	cookie = chunk->subh.cookie_hdr;
 	bear_cookie = &cookie->c;
 
+	ch = (struct sctp_chunkhdr *)(bear_cookie + 1);
+	chlen = ntohs(ch->length);
+	if (chlen < sizeof(struct sctp_init_chunk))
+		goto malformed;
+	if (chlen > len - fixed_size)
+		goto malformed;
+	if (bear_cookie->raw_addr_list_len > len - fixed_size - chlen)
+		goto malformed;
+
 	if (!sctp_sk(ep->base.sk)->hmac)
 		goto no_hmac;
 
-- 
2.53.0



