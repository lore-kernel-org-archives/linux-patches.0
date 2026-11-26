Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705646;
	b=gWIhCDhdO5a5sOCTYCXqzRvdOA//0L9dnByDgxl7B3H7XAtM+x1OM1O6QcmVlpXZS5EV
	 x4+ID5N4GwbdY84/b4gB+vcvKF2XBp87U43NkDAnV776mUGLXKZ4TKTdvXCRn3a8SZjGP
	 ivCCStMTvLyQkhWUmtY1j1XH/FUH5ZXvCQT/08O8CgdveVPXNGpLHhfohN0LZSHwljnf6
	 HoVvmdwBOTybwXvhPuNZbRsB+E2i3Otl8yWQxPBHkl/EOFfZ8Hm/BthYjIP0k6dEp3WNa
	 pWSL4atFk1oTXpUXeyveo6o2VR1+wI91G1pvR2cT6hm9qLmgl3CBN0GlR4yrfjNKBrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q4ostGw/GaXqFjMAFzylD0WmXSRH4AYxFKSRSe5gggI=;
	b=UW/3po4V2EXNaagww2SLqpBwwBXpYW+xV53nsJcUwRkvKgzbmjBs4gCPVDn3DMkKKKo/
	 pX+WRSVNBF/SIG2n9W7TVWxoGR5EMApeijRlQ9qq5OMoMsUjeO2bfWASvFnBeypfLGJtg
	 oRpfbNB01aHNFfgH9Ymefvd4Q/mX1BAbMRBfI8Wlek5eW2vfUak4VTI4zUvnubE0FenvQ
	 4urfhMpMeJh83p1guIq+51a9XIEA/rcv4/Z+O2VX34px1FJ0pBdgI0AMG6APBr8ub9y2i
	 Dej7cYcucoe26X1dG7eYaH81qAFW5DsGQgR/I6WO9etM0Xo1+9twUUbp9ZAfhsBXRVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t7j/ppcc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE576606A31E;
	Thu, 26 Nov 2026 15:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t7j/ppcc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372E91F000C6;
	Thu, 26 Nov 2026 15:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705646;
	bh=q4ostGw/GaXqFjMAFzylD0WmXSRH4AYxFKSRSe5gggI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t7j/ppccvKpmpPiyrtxMN1tJIrLJE2b6kngmtz43hcHEWT6eekoMUJeZ7297EBF0P
	 av4xcH6urnOpam2555ObsTumcjkkd5CKNEdrQpWZ3G0ASGhMbcsjOS042hvxL0BC/t
	 gGEMcyI7ZGOq0+js+0PO1M9QKn/6lnZkd+m3PjHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xin Long <lucien.xin@gmail.com>,
	Kyle Zeng <kylebot@openai.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 223/319] sctp: avoid requeueing pending control chunks
Date: Thu, 26 Nov 2026 15:39:51 +0100
Message-ID: <20261126144011.781791957@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

commit 665b4149e91b781a71bce8637c3a4d7d64dba05f upstream.

The T4 and RE-CONFIG timeout handlers take a reference to their cached
control chunk and submit it through SCTP_CMD_REPLY. A previous
transmission can still be on the control outqueue when output is corked
or suppressed, or when sctp_packet_transmit_chunk() could not append the
chunk.

sctp_outq_tail() then adds the same list node a second time. Re-adding a
non-tail entry can corrupt the list without being caught by the
insertion-time list checks. A subsequent flush or association teardown
can access an already freed chunk. The ASCONF path is reproducible by an
unprivileged SCTP socket owner in a user/network namespace, with KASAN
reporting a use-after-free in __sctp_outq_teardown().

Check sctp_chunk_pending() in both timeout handlers before taking the
extra reference and issuing SCTP_CMD_REPLY. If the chunk is already
linked, leave the existing entry for normal output processing. Keep
the remaining timer and error-handling commands unchanged. This also
covers RE-CONFIG retransmission after sctp_assoc_rm_peer() moves the
request to another transport and starts its timer.

The issue was found by an LLM.

Fixes: 2e3216cd54b1 ("sctp: Follow security requirement of responding with 1 packet")
Fixes: 7b9438de0cd4 ("sctp: add stream reconf timer")
Cc: stable@kernel.org
Suggested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20261107030532.32310-1-kylebot@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_statefuns.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1100,9 +1100,11 @@ enum sctp_disposition sctp_sf_send_recon
 		return SCTP_DISPOSITION_DELETE_TCB;
 	}
 
-	sctp_chunk_hold(asoc->strreset_chunk);
-	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
-			SCTP_CHUNK(asoc->strreset_chunk));
+	if (!sctp_chunk_pending(asoc->strreset_chunk)) {
+		sctp_chunk_hold(asoc->strreset_chunk);
+		sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
+				SCTP_CHUNK(asoc->strreset_chunk));
+	}
 	sctp_add_cmd_sf(commands, SCTP_CMD_STRIKE, SCTP_TRANSPORT(transport));
 
 	return SCTP_DISPOSITION_CONSUME;
@@ -6147,9 +6149,11 @@ enum sctp_disposition sctp_sf_t4_timer_e
 	 * chunk, it MUST be the same (including its serial number) as the last
 	 * ASCONF sent.
 	 */
-	sctp_chunk_hold(asoc->addip_last_asconf);
-	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
-			SCTP_CHUNK(asoc->addip_last_asconf));
+	if (!sctp_chunk_pending(asoc->addip_last_asconf)) {
+		sctp_chunk_hold(asoc->addip_last_asconf);
+		sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
+				SCTP_CHUNK(asoc->addip_last_asconf));
+	}
 
 	/* ADDIP 4.1 B5) Restart the T-4 RTO timer. Note that if a different
 	 * destination is selected, then the RTO used will be that of the new


