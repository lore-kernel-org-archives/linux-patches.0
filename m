Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704615;
	b=THNsQMFCLGjXF8nKND+dkM/lgnN+W/+JuSRv+HnYQ8bIokV/8sbxyoXjR0bqdG4Z7FBR
	 y/biCuKveAUULJejA5+7e6Z+rir1ctJlYq4ate9xSuEPtql6hUj9iL+k6P8zhr8UE9+CT
	 v90/MvdSX2dshkiMYdu/IZblXtUQnsaB4Y9XQXeq2apIhVGQH8jgGeSLkrcVH/yLW8X2v
	 ZODM1y+dzqbmxRtM89JXYjFbEdnYUd1wEXGl28gkYVJTDPkn5e3wWKoSBP1vB4sUBD7fF
	 qTVkmILa2fwkhdtZzVdazP9Q5ik0GA+u6tgahCdD/ZiGfILBvIy0OhkX4xyjGzIq5+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qF1FVX/QxPY9ghUfVQ9K8wqiy6rOPDBv4hC6qIhNO/c=;
	b=lHbna89V2I2ZL7xXW+z4QWbZ658UqouPvUBDvqjh8FtOSfDip2cRfh6hdQV4Sh6+cgq+
	 /arAHr5RuQ92a2wg1DEcgQQqJOtJ39CkfX1Ex/mXkScr/Ra66HCIBSLSD/IJLrDwHIO3z
	 FtgDEFzFbZDQVlEv/FuAJOPxxLfGSNwr4TyUONR7PcUTgss4iAip5rMKGG8/dKnAey68h
	 JzDiCFY+5FixIWYA0CZD0S7wsSS4aVwzDV7oPpDPUrGeWWdhduDTJON8PextrKskRtRBC
	 M34NDy86YYVW1Vw5QfieGWEtmH+ZPSem/LAv1jgZwTIgDmwQexxaLloCwpg9Y8JVQ4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JYF9KD9j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0339606A31C;
	Thu, 26 Nov 2026 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JYF9KD9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A5E1F000C6;
	Thu, 26 Nov 2026 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704614;
	bh=qF1FVX/QxPY9ghUfVQ9K8wqiy6rOPDBv4hC6qIhNO/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYF9KD9j6RrGPYLo4qgfKenzWAgUe0IWKzbn/K1nBxSIUjn7aaH7tbC/4ULyWEzFg
	 4Q7eMelN/SDdsYqrSX8voHmTZH1oSlJOs6TMLbiK26VkWuWjqYtfvDDys5lE/ivwOW
	 11rS04dAfqNeJKhOhFkj1loP7TUVYbhoDePNzzoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xin Long <lucien.xin@gmail.com>,
	Kyle Zeng <kylebot@openai.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 183/265] sctp: avoid requeueing pending control chunks
Date: Thu, 26 Nov 2026 15:38:33 +0100
Message-ID: <20261126143618.022805142@linuxfoundation.org>
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
@@ -1093,9 +1093,11 @@ enum sctp_disposition sctp_sf_send_recon
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
@@ -6048,9 +6050,11 @@ enum sctp_disposition sctp_sf_t4_timer_e
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


