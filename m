Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAEC3BFAF7;
	Sat, 17 Oct 2026 17:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258958; cv=none; b=N5prBeO0k8LJ/0DSatWuXoTxad6Hz0RSmqIe8Adkvm7vOGTC51HwDMqSOM89WQ10usYFvJorMKabfWibdHnyswtGYSroVli4TJWW76MJHd1EmYeJXBbDDUNaqrieb5irQg/Ds8kdiNkur7/WIYp3WLw6h0OPFR0Shxg9GnY2hNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258958; c=relaxed/simple;
	bh=Mey6ipRdRgVGMlnu1kOIlJUsSPX2SWDLo8FLnOqAF2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTinOcKuW+vEi03qF/wQfxH5AgN2cyN9fucLCkMRmRg/imE5aYtTaLEJ80qKYrHmiovszJ47sFNLD5SCiknMx2XSRd1u6n5PEf6tkX78ngDABgVyRiUXpQpWalB3KC0ba+Bq9UPB2V9fS0RkNidITvw5ESAcLLWtdSJxuXolvGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Txt7AyH3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Txt7AyH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BCD1F000C4;
	Sat, 17 Oct 2026 17:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258957;
	bh=SzWSpLewsf38H6GQFjNeVPBMVzQV86lGwFzyw8ZagBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Txt7AyH37PLRb4gLz2ve0PNHJqdnpK+slC9r/CcMCYdsfplTBJMVCKzwCFsaFmsGa
	 N8Ukkrgrh3ZY32Xaqd+xt4odS4dtRgrZkWHK+hQ4VXQXN0CA6zrddk3UnWWrJA8Y4N
	 GkRyeRsAHqP9GcJdw3Zdb4H7TTH38ST+lvC0OEMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1018/1674] sctp: validate embedded INIT chunk and address list lengths in cookie
Date: Sat, 17 Oct 2026 17:54:50 +0200
Message-ID: <20261017160457.261521017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ec3a9363d22c6..73b5c0dba69fa 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1750,8 +1750,9 @@ struct sctp_association *sctp_unpack_cookie(
 	struct sk_buff *skb = chunk->skb;
 	struct sctp_cookie *bear_cookie;
 	__u8 *digest = ep->digest;
+	struct sctp_chunkhdr *ch;
 	enum sctp_scope scope;
-	unsigned int len;
+	unsigned int len, chlen;
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



