Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A54E38F64D;
	Sat, 12 Sep 2026 18:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236888; cv=none; b=O95uVd54OGwF10O+c/EIVDbxadyHPbXQ5LdgDzSO6ceoZ6HQrFQBeB1MKlKrfQKyNpie1YpOb/LWtdXd1pYzNNyE2W1qU8cyS7Fne7eHlWLcFI0yhJYXllYJsWXbg4WMIpB5HKaXtUzuEeiNk2/Ha1j+Wef1kRCM2ydLNp3hLHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236888; c=relaxed/simple;
	bh=uEFPia6e1rfoM48lyvkAZBLnexL2E0BigLXiTnRgdww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kH1TPuhfq8Y3cE8oGzJ0TfJzrz26ACp+LCpb4Ax59PlZNrA3TruDHHlaYWKlLbV7ocW4IIDTdODSx4Zhr+a0mNBZm4cH4+hNgse3PV03ErLqvxKyGpFt5qFBWIoFmlMBQvLmAsDfReByyy4Xjqv2wdQgu8bVAW4YGb4KducHvQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EG7QoslD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EG7QoslD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C38C1F000FF;
	Sat, 12 Sep 2026 18:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789236887;
	bh=Ul6IA9Kwf3OUS8UlcZmGJUGW0t+vq8/vvhg+hi9PAWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EG7QoslDwP9/t60k0UCvAw29rOLuuJdS8JG5gxLASMgpINrk4ovvdSpIRHyc9Tvi3
	 bcL/h/zmPoc8MpJofk77aun1mVW782Py5mVBs+zsjm6n39zp891DHj5HaSqDSrX00H
	 EJqHb6z2invxmjvhlE6ONR0AsQfue6c1EaSnAyps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Xin Long <lucien.xin@gmail.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 147/935] sctp: fix NULL deref on untransmitted RECONF completion
Date: Sat, 12 Sep 2026 08:52:57 +0200
Message-ID: <20260912065530.192716909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit 2db9bfa3e27bdea15e05ea70b56bad3d21e570ec upstream.

sctp_process_strreset_outreq(), sctp_process_strreset_addstrm_out() and
sctp_process_strreset_resp() complete a pending stream reconfiguration
request by stopping the reconf timer on the transport it was sent on:

	t = asoc->strreset_chunk->transport;
	if (timer_delete(&t->reconf_timer))
		sctp_transport_put(t);

chunk->transport is assigned by __sctp_packet_append_chunk() when the
chunk is appended to an outbound packet, and sctp_outq_flush_ctrl() arms
the reconf timer at that same point. A request already published in
asoc->strreset_chunk but not yet transmitted has neither, so completing
it dereferences NULL.

Two ways to get there. sctp_send_asconf_del_ip() sets
asoc->src_out_of_asoc_ok without sending anything when the address being
removed is the association's last one, and sctp_outq_flush_ctrl() then
leaves every non-ASCONF control chunk queued; as only
sctp_process_asconf_ack() clears that flag, it persists. An unprivileged
process that removes such an address and then asks for a stream reset
panics the kernel from softirq. A peer needs neither ASCONF nor local
help: sctp_cmd_interpreter() uncorks the outqueue only once the whole
packet has been processed, so a reply built while walking a RECONF chunk
stays untransmitted for the rest of that walk, and one RECONF chunk
carrying [Incoming SSN Reset Request, Outgoing SSN Reset Request,
Response] -- or two RECONF chunks in one packet -- reaches the same
dereference.

  KASAN: null-ptr-deref in range [0x00000000000001e8-0x00000000000001ef]
  RIP: 0010:timer_delete+0x67/0x110
  Call Trace:
   <IRQ>
   sctp_process_strreset_addstrm_out (net/sctp/stream.c:832)
   sctp_sf_do_reconf (net/sctp/sm_statefuns.c:4212)
   sctp_do_sm (net/sctp/sm_sideeffect.c:1172)
   sctp_assoc_bh_rcv (net/sctp/associola.c:1044)
   sctp_rcv (net/sctp/input.c:243)
   ip_local_deliver (net/ipv4/ip_input.c:262)
   process_backlog (net/core/dev.c:6680)
   </IRQ>

A response can only acknowledge a request that was actually sent, so do
not match asoc->strreset_chunk while chunk->transport is NULL. Guarding
the lookup covers all three completion sites.

Fixes: 810544764536 ("sctp: implement receiver-side procedures for the Outgoing SSN Reset Request Parameter")
Cc: stable@vger.kernel.org
Reported-by: Xiang Mei <xmei5@asu.edu>
Suggested-by: Xin Long <lucien.xin@gmail.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260823172857.896146-2-bestswngs@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/stream.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -488,7 +488,7 @@ static struct sctp_paramhdr *sctp_chunk_
 	struct sctp_reconf_chunk *hdr;
 	union sctp_params param;
 
-	if (!chunk)
+	if (!chunk || !chunk->transport)
 		return NULL;
 
 	hdr = (struct sctp_reconf_chunk *)chunk->chunk_hdr;


