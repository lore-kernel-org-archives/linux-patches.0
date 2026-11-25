Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623797;
	b=NyJADdZaeJ6zsQcxVSDZrZSPBq2oaqnmgreBHcMGkdihcKDRnTKwQWTBVKvG1XMo+z7C
	 fqqFtj8e1fzycUkBzm2NYVyOUkUZ3UQb7sU5ikj8jmzFMjlRBCuDYM9OLOvVTqZVODSDx
	 a+zOQw4HiUAA1qn0FuI9Os7NVDOteHgPLf7Q1+4d9UDupJYvXXrsj00mIqguJ6uv3zb53
	 MdRw6l6Vb75nywususuBfablFoPwVUXL71ojsHKczRWvHxtyCIqQjjaU4hC2nB4F0GuNV
	 uX3ryzoM63ZYFtvi4GPNnk0X7MguKXzKTXq1/RSgGisBw/l6wzp4nU4lSpXOUwQypPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EGAy+jtvaMdz6r+VaolasRkPAjVKzBfVz4q35xYjYB8=;
	b=kTIjJTgluaSYkQRE2gY6sfJQ68lGDfy8o+tmvyQO25nqoyQ64gpOQ2yIXEE8KPDEhuJo
	 WLjGuzdMSsfHbwUz2ghxXbfcBrypjnzbF6kfqQmk5bxe9qTokbf8fPXTRZ+1PLoyjixxt
	 Yz5Fx89bkFGj3/VyYEpnqvLInwVV6c1INuytdXAgix8M7QOciyPXxpbx8UJoghY361bBB
	 pOaXkyDyjbqQsV5lks3DBDLgc/zI6dJCpxxE2aTryfA7U7jQjnyfjRFoDIH97zKnB/Vvn
	 lPF1FzQ07cR+/DZrGWBOCQzRv9lrhHIpBKwsAhJkBwci9MFdlResGPJMHHST2j8NIFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rZ4oj3aQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C1B606A33C;
	Wed, 25 Nov 2026 16:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rZ4oj3aQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58ECB1F000D0;
	Wed, 25 Nov 2026 16:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623796;
	bh=EGAy+jtvaMdz6r+VaolasRkPAjVKzBfVz4q35xYjYB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rZ4oj3aQ2nHf4k6RNRa+o+TxjygRFuCcCAXE2Y/KSw85fsXc72fSoXbcUrMm1B+en
	 gkUyxKju1migLUECTwXB51rmuu58z8hcfpt+u5hU3R0nBu10RtvuY15qHh19Ulweu8
	 hJVJbkd5I9C1HL7VsxohY53lGF5mI0ZgQG3A6D1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 972/990] sctp: fix skb_over_panic when adding addresses with a pending delete of another family
Date: Wed, 25 Nov 2026 15:38:59 +0100
Message-ID: <20261125143844.752161512@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

commit ce09d8c13a15fe881d0a04c91979dcdf45ed9543 upstream.

sctp_make_asconf_update_ip() accounts for a pending DEL_IP
parameter by reusing the length of the address being added. The
write-back side instead serializes the pending address itself,
with its own address family. If the pending delete is IPv6
(20-byte parameter) while the added addresses are IPv4 (8-byte),
the chunk is allocated 12 bytes short and sctp_addto_chunk()
writes past the end of the skb. E.g. on mainline (05441d697f7f):

    skbuff: skb_over_panic: text:ffffffff84859c77 len:392 put:20
        tail:0x188 end:0x180 dev:<NULL>
    kernel BUG at net/core/skbuff.c:215!
    CPU: 0 UID: 1000 PID: 379 Comm: poc_sctp
    Call Trace:
     skb_panic
     skb_put
     sctp_addto_chunk
     sctp_make_asconf_update_ip
     sctp_send_asconf_add_ip
     sctp_setsockopt_bindx
     __x64_sys_setsockopt

Requires addip enabled on the endpoint (net.sctp.addip_enable=1).

Account for the pending delete with its own address family, as the
write-back side already does.

This issue was discovered by an LLM code scanner.

Cc: stable@vger.kernel.org
Fixes: 8a07eb0a50ae ("sctp: Add ASCONF operation on the single-homed host")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20261111082313.1606366-1-bsdhenrymartin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_make_chunk.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2867,7 +2867,6 @@ struct sctp_chunk *sctp_make_asconf_upda
 	int addr_param_len = 0;
 	union sctp_addr *addr;
 	int totallen = 0, i;
-	int del_pickup = 0;
 	struct sctp_af *af;
 	void *addr_buf;
 
@@ -2882,16 +2881,21 @@ struct sctp_chunk *sctp_make_asconf_upda
 		totallen += addr_param_len;
 
 		addr_buf += af->sockaddr_len;
-		if (asoc->asconf_addr_del_pending && !del_pickup) {
-			/* reuse the parameter length from the same scope one */
-			totallen += paramlen;
-			totallen += addr_param_len;
-			del_pickup = 1;
-
-			pr_debug("%s: picked same-scope del_pending addr, "
-				 "totallen for all addresses is %d\n",
-				 __func__, totallen);
-		}
+	}
+
+	if (asoc->asconf_addr_del_pending) {
+		/* The DEL_IP parameter is serialized from the pending address
+		 * itself below; account for its own address family, which may
+		 * differ from the added ones.
+		 */
+		addr = asoc->asconf_addr_del_pending;
+		af = sctp_get_af_specific(addr->v4.sin_family);
+		totallen += paramlen;
+		totallen += af->to_addr_param(addr, &addr_param);
+
+		pr_debug("%s: picked del_pending addr, "
+			 "totallen for all addresses is %d\n",
+			 __func__, totallen);
 	}
 
 	/* Create an asconf chunk with the required length. */
@@ -2914,7 +2918,7 @@ struct sctp_chunk *sctp_make_asconf_upda
 
 		addr_buf += af->sockaddr_len;
 	}
-	if (flags == SCTP_PARAM_ADD_IP && del_pickup) {
+	if (flags == SCTP_PARAM_ADD_IP && asoc->asconf_addr_del_pending) {
 		addr = asoc->asconf_addr_del_pending;
 		af = sctp_get_af_specific(addr->v4.sin_family);
 		addr_param_len = af->to_addr_param(addr, &addr_param);


