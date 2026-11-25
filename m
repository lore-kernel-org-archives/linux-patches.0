Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623364;
	b=loQD0CC5PxZJCFCUJaOjxs/5bqCqpiJl2hRcNrwIWGQNq2VFpqbLmbNf8A2A4v1FmSSq
	 HvmUrfOjRwSKIf+SArzgLJp+KA4yJhY/Ooal+lAh+ltPVeNmIItjjjTW6ZdeT9LtJKOnV
	 r8x5tDcZJNdsZykOd48LBz2+rxztO2iPocI89LSIvU5aTbGGDLBpp6ZrqsL7Aw1o7xuhL
	 KrIGAun29bog0j1dpxULzfK9ArEVy6QwMLOf+8aN20oeD0Ojd84hFnX/2JaD2E4W6ptTc
	 aI5m9Sl7/5UeUTIcoWhIX54/fWkaz8fvJS8fZZZecQEHCglgDppOq3qLGdbiNzrDMUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d3yKq4GlyOOSSbJkH159KQjalf/etPZOl3NRLnj985o=;
	b=zSatAS0W2lpGsCe8o9EBwDfHJaEMR2GTAEiRAj7c6L3ubQvzY3EY/t/NVVhO5pbir9ys
	 saaDMnfLSMvfPat7CFTl4nCxbMYrjr+qRb9OHzODtJCtSYhWMlwdctDoqD6pWUyTTyfnD
	 F6cxmK5EmVs8t0JQ3YcZd+wcH5gJUpC6qYB3wZgY+DH2xJex0RXY33Op90OSmNIM6c6O9
	 zCpmtphL076CoHEAIg/8jB2O0FTFU3aqlI+q20J+tdeMFFVrnMvekUv6MoXaqH2LRzifH
	 yqfToOkd1Ke74CRdYlrgYAGRXZ7qpZfa3+UG6oy3mCy7AO6ei7TFQDFSMk/pGgkSnrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RcKWQHaj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9210606A31E;
	Wed, 25 Nov 2026 16:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RcKWQHaj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056781F000C4;
	Wed, 25 Nov 2026 16:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623364;
	bh=d3yKq4GlyOOSSbJkH159KQjalf/etPZOl3NRLnj985o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RcKWQHajLedC6kdvmEWeKSSckqgohUKoRLyJLHJtpuumzEsnq+P7P5AeSCqLrKm/C
	 89W5d4m1gITJRrb+gUOX8xga3goTRVVPaQi3cs+9GFSjjVYWNxPfYzLCJqmBa4ulCu
	 V41sUp9/sUaHhNiii95gtLxz2GAvY067QHUP+2YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xin Long <lucien.xin@gmail.com>,
	Kyle Zeng <kylebot@openai.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 790/990] sctp: avoid requeueing pending control chunks
Date: Wed, 25 Nov 2026 15:35:57 +0100
Message-ID: <20261125143840.549440327@linuxfoundation.org>
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
@@ -1122,9 +1122,11 @@ enum sctp_disposition sctp_sf_send_recon
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
@@ -6194,9 +6196,11 @@ enum sctp_disposition sctp_sf_t4_timer_e
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


