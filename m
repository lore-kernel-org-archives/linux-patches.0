Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705778;
	b=3RTg8sxZwLssdAmb6X3weTMLEZRv9WPmDLQDMCe+kgsywkFoW6qX06kygGPbka9YtawM
	 3WW3kyoMGr1YOXBDLiiJIgcb8UZissd9Df/4gXv20fLh/vt3W0zd3+8aeYlx2K37iCO3M
	 8QnfHlztFjrhpls1X8TpSqWQMH2bLxXZadiXd7BdD1dZOOBHYjGdzGDQ6Bp3mRuXR2MVj
	 nAcMaNqn/t2Hix7K9YsYxpTAK9kA6MQvjMFsz9h7tlgFeBDZum4FxjgdGE35HU7UjbkgL
	 qDwoBFXJT6mFbUJTa0ktQlGvRjpt8i1cIHmidkRDiZgzjliXQDAhozFHC+y2A1yTcqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J34EHfSk0El41+ALlThCStf/Cdor8uyz5rUN0hxcQbc=;
	b=0J84qGVoWX0s4PP6m+yx/89vYef0YrLmVmtxpCL6/Jqmr2m/8vj7SyQNfSgsp2OtOZcV
	 FWhcKu2N+pzp4w+e+Jd6PG0esVoJqNojAlChTyFAeP5oDQWocMOXTbdakSOFkmfo/XhUL
	 VueCHFDExKT3OYNkxGM6WVYoSxmdh5pmMuB1j4fbWoh8rG3QnQLsrfttCpAf29wf1OMtH
	 SagspfEekrLYWxwYEcYFvLjhmZryGYqdEmVvOwJ0IJD1ipb9oZ7GJwIxmdugNSITQw3N0
	 uOdMq0Zwc9owwOiai5JVoD2iuKkBQ7th8QTuhoZOmwLX3MUE7Z6d3ApLBjN+tSryQRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OwKIiNeI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F14606A326;
	Thu, 26 Nov 2026 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OwKIiNeI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF7F1F000EE;
	Thu, 26 Nov 2026 15:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705778;
	bh=J34EHfSk0El41+ALlThCStf/Cdor8uyz5rUN0hxcQbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwKIiNeIE2pqwyMjZktr4wfS+Yy2Vl7B2eE5En4xDUCPTKyWleP4WJEkBXpNblTZI
	 PNI55GRw9VLWVwm+3E0YjhTR2+iFdA3aY1/kZ4GPKXBv483cbln9e08gcRoaMlCg5B
	 MD+0bOH7eciPNkp/mMan9gTbL72O+H1SHphNc02s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 310/319] sctp: fix skb_over_panic when adding addresses with a pending delete of another family
Date: Thu, 26 Nov 2026 15:41:18 +0100
Message-ID: <20261126144013.755844135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2891,7 +2891,6 @@ struct sctp_chunk *sctp_make_asconf_upda
 	int addr_param_len = 0;
 	union sctp_addr *addr;
 	int totallen = 0, i;
-	int del_pickup = 0;
 	struct sctp_af *af;
 	void *addr_buf;
 
@@ -2906,16 +2905,21 @@ struct sctp_chunk *sctp_make_asconf_upda
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
@@ -2938,7 +2942,7 @@ struct sctp_chunk *sctp_make_asconf_upda
 
 		addr_buf += af->sockaddr_len;
 	}
-	if (flags == SCTP_PARAM_ADD_IP && del_pickup) {
+	if (flags == SCTP_PARAM_ADD_IP && asoc->asconf_addr_del_pending) {
 		addr = asoc->asconf_addr_del_pending;
 		af = sctp_get_af_specific(addr->v4.sin_family);
 		addr_param_len = af->to_addr_param(addr, &addr_param);


