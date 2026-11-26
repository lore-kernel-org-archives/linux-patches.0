Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704822;
	b=B52CeUFzEnOtzVWRj1h824Fc7KNn2tHe0pG5h145Lpxd9M3bVpV1J1QL+ARxOhngJhs0
	 eWbgTUajMoZjbM6iyLYn/kvTDXnyDl90P4hoV9eNxhpRpmgViTAiEcyDeh/0vigtkqtjQ
	 toFZEX+4eQ1DSG896pco8iALmQPiSdqbt+Z5Mx0lC9gvrAbY7U/WzV6tt4exA51Y7JpXa
	 WUi9Sq1DnZYDyH3vipYuE5pj7R78bFEu9Q3Xja0NL6UFQzxyeg5UDC9WJP3xKXmuJiOrN
	 bsRpy2C1dDUJj1wfsSP6F/dSQ3Vm+ELtJIdYTx0He6CdKPGo9zBIvPxF7FqZBjFNt6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P3g8Coh6pS0QnvTWZseBK6YLaRvVll5wT3wKmrGQ82Y=;
	b=1jWrIYfhUmeR5Mh8IJfGH9uKHeZZK9KluzEKqBsMahGrJh7MaBjoT/Bn9XgDwb/4z09g
	 DlYckG6R7My4Jq6KxvjS7Yl2utDRB6xERmLkqrIIl8fbfttYvRu0X7jxH5ZzpqYgH2DJp
	 xx9neGiCYuAq47VW/hX6Zsi3VfRUxVtC1n1ioQhn2BtAqskPJxrCi43hfkGTz4pPPA/sR
	 1OuHY3dwCQdfpTPobU1btZdDvLMXQg672OEJG7MV4R1I2J1JNf8J1+VCB7eNubH1vwee0
	 +hOn/wa8rT9jd7Dcg8Qw1SQP3+duzOqJPgm1DeHrNDQTRKAbpvUA+bRcrzqS7hN1B8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=knYGx6dN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCF1606A331;
	Thu, 26 Nov 2026 14:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=knYGx6dN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA191F000C4;
	Thu, 26 Nov 2026 14:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704822;
	bh=P3g8Coh6pS0QnvTWZseBK6YLaRvVll5wT3wKmrGQ82Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=knYGx6dNKKVI+dK70tm5xHXJgE1Dtzfn00OkGGn2p3Ka1x6u1x1gmKhrSwAJ2M4La
	 8NgIHYM4H80zynWmV4dNm2AGMtv4mb6BGuuoQyNw7QaFRj5nsavhjZXadmukEb5hL9
	 A6wspdrUOYXqlURgdbSXnS7DgD7E2iTPg27+SS2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 255/265] sctp: fix skb_over_panic when adding addresses with a pending delete of another family
Date: Thu, 26 Nov 2026 15:39:45 +0100
Message-ID: <20261126143623.096154437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2845,7 +2845,6 @@ struct sctp_chunk *sctp_make_asconf_upda
 	int addr_param_len = 0;
 	union sctp_addr *addr;
 	int totallen = 0, i;
-	int del_pickup = 0;
 	struct sctp_af *af;
 	void *addr_buf;
 
@@ -2860,16 +2859,21 @@ struct sctp_chunk *sctp_make_asconf_upda
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
@@ -2892,7 +2896,7 @@ struct sctp_chunk *sctp_make_asconf_upda
 
 		addr_buf += af->sockaddr_len;
 	}
-	if (flags == SCTP_PARAM_ADD_IP && del_pickup) {
+	if (flags == SCTP_PARAM_ADD_IP && asoc->asconf_addr_del_pending) {
 		addr = asoc->asconf_addr_del_pending;
 		af = sctp_get_af_specific(addr->v4.sin_family);
 		addr_param_len = af->to_addr_param(addr, &addr_param);


