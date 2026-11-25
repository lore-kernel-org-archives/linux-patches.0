Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620688;
	b=vdcsVUZaIfKWMw61la9rQil85r9pDHpY+afpzh99o9BcyOyefFAHraxj4Bl3X+Y6iVb1
	 rJrNyBWhPeA8JufVpA0k/eE50+bddZmoIDD+o77COTCPUWWYHkYKYMWFzGZRO/K2lomrm
	 qiP6k1idD4GwTNtjzm8Ud+0FO3trPF/PK9BoqLisigfIU37orSGGB62iWTVQzXbKuG9sR
	 oypOuEFycAGf3P596naRJsxOjTOke0Uhexsyn9wUgo6mnQSxRODi649vQQAYS7cFUFNeh
	 hyHaoMPAEc8VKp7qelPASc2RsL9USNpmfALfS4NdZ8ue4+3WdLiK1s1eiacfgOT0QEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+mrSvsmUkv+vVhdlY3AieA6GsevkP15pePYDC3jaHFw=;
	b=0gegff3Eichh7qAPVfz3c02Ln6j58eIyi0rYbFQlcxP8kxZsQQ8Tuch69wybNb2r+ds6
	 iI1cqg+z/bHu26EkI/Z46Sgxdxlxgd5G8YDtyex8EOESpJHKQnflfvVDQ4jBgh/9nuu3H
	 IsjMdx/L+2EIWbJHirHoXHHgn0F0fij2/zwmqUlibBIHzVtPvcxX6Ss4oOmTRR02dvKIW
	 hBQFY9Yf0/h/vsrT1T9ZLKe8HxhgdW/ewfFLjiXfpHFVqcgjVKE/KirEyR3pUkft0Qxdk
	 DfV89akXeXclk5q8jb9RDGUECDkdNb/8mAEzS4qDqc5oKDTGxw0s4SCx5OWJR7lFgNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QOylX8IZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF0D606A323;
	Wed, 25 Nov 2026 15:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QOylX8IZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7313E1F000C4;
	Wed, 25 Nov 2026 15:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620688;
	bh=+mrSvsmUkv+vVhdlY3AieA6GsevkP15pePYDC3jaHFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QOylX8IZ+CkKpuWpQ2j2g1dlgUqRjclaOvy3QFZgn8X0W4Udoob8N9QRGkr2owkbd
	 hnTcECGxXsEXnGSjzlS6MnfwADoAKh6ynaIsz1uCef5V3Om9yRZojjwywhO32UympA
	 b/0TbQ8hsGYVKgzOloDsyRKcy+TkaA1cO26nfeWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 1000/1005] sctp: fix skb_over_panic when adding addresses with a pending delete of another family
Date: Wed, 25 Nov 2026 15:38:58 +0100
Message-ID: <20261125143845.078004348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2870,7 +2870,6 @@ struct sctp_chunk *sctp_make_asconf_upda
 	int addr_param_len = 0;
 	union sctp_addr *addr;
 	int totallen = 0, i;
-	int del_pickup = 0;
 	struct sctp_af *af;
 	void *addr_buf;
 
@@ -2885,16 +2884,21 @@ struct sctp_chunk *sctp_make_asconf_upda
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
@@ -2917,7 +2921,7 @@ struct sctp_chunk *sctp_make_asconf_upda
 
 		addr_buf += af->sockaddr_len;
 	}
-	if (flags == SCTP_PARAM_ADD_IP && del_pickup) {
+	if (flags == SCTP_PARAM_ADD_IP && asoc->asconf_addr_del_pending) {
 		addr = asoc->asconf_addr_del_pending;
 		af = sctp_get_af_specific(addr->v4.sin_family);
 		addr_param_len = af->to_addr_param(addr, &addr_param);


