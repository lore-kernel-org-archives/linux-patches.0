Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDC9279DC3;
	Sat, 12 Sep 2026 19:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241426; cv=none; b=PJ9heIw+xyn9d3VYh9RRky7w9fzw28WP5u6nlwJ7JP2EhaNBX2N5eN5eWsEwusU4cO0NXI/ign0uVWR1/ppDPdMLps3tYDJG/5Azllfem6kDb53BmG9zIzt1WAGWDCPU51odBDgx/jBEXNKfsOMkAXKJ/lWMNtc1Ifw6zxGmm2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241426; c=relaxed/simple;
	bh=ghQMAiwO0vHKmeB4juxOi1eF1B8MMCdW5hRL3+bfHw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DO6qbhZ/3lDB9uICxiFx5U/+n2ZYHvS7262ro3FAKgvK0w7lt39FvfpgkWfhO0HZrtAa7UWpOzeuqqVN+O3N22WiaSNWb/4Qb6iiwTDgEyzT4JwQwjRFG49Df8yabN6ocDqYCF8uPEW9rBHxDkBr5e8YXj5Fd3nsYr2tXiaA9+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xmr08Vdf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xmr08Vdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3153C1F000FF;
	Sat, 12 Sep 2026 19:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241424;
	bh=H5b4a3CcU622XXMJyZ9oiQ7ELywMZ9pL+GWQgjzzdos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xmr08Vdfpe4FLTPX+svNuHm0ZSgjPNS7CsBC7qZ81Rn2qNMfJKAVw8MyAUamGhiei
	 1wKAzc8RrdGt4m/hHxRUiPd8rZBR1hkkKoeyBSybzQ1O884wD+FpcV5IKX7Zzc8DbQ
	 6kFW2TDMo9q2OU4koodglzDjjFdxwoWPn31G2GRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Xin Long <lucien.xin@gmail.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 132/798] sctp: fix NULL deref on untransmitted RECONF completion
Date: Sat, 12 Sep 2026 08:56:00 +0200
Message-ID: <20260912065520.002843666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


