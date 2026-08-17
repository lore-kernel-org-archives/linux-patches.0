Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A05543FD02;
	Mon, 17 Aug 2026 13:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974628; cv=none; b=MXre8FfsWpyVk1ju2vOb8AWfluHaVideMOW0+EihNcAlD8ajPdKBVqQJTPHXYLtTLNLoImktEO9lslkTJl6jMM2TMw+ddjfmu1WeMyzCBtfj+Kjfr7jXS0gPaDM8n8ggGuGtzkITB1rN1ZyrckGU2J9NcKESgK4iezMSHwsIujw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974628; c=relaxed/simple;
	bh=wXp2iidzOQiVAwUzR3rECOkvMoGCln+gfszZYMO+9Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okZhxYfyGPhADIy5AqUpaEc7MC5FKLi0o/NPUn3czCqkyZmirDpNacZ4Z+tcgAgN6voHUmC5MQYMBbqYLNIxzasWL6HhiEjdx/brFkGagAG4BM9O4GDWDCfpvFxWDhRV2+8FO4gOb0G5svUo8Lmoj6RnNfysa3Q8AD/LwsjL6Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJfR15gh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJfR15gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F681F00A3A;
	Mon, 17 Aug 2026 13:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974623;
	bh=5Vc7iyIzFns84DkZq6rmrrc5PGDxn1r5eYChbAeQPmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJfR15gh/61qR8DH5Tkdxup1GHx5O04eJaYXQwpW4YqiH9oghg5FdpDyHBt2cZ6ck
	 mFxzpJm1PJCy/3tXxgmJZ/mY8PUM6N/CLichtO0Eqk2eP+OTg1yVpJYmX9z6YKshTm
	 xPOGaKPe/MSu/yTJepGqR5u2GPfT40r0NvCQkB74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 269/271] sctp: clear new_transport when removing a peer
Date: Mon, 17 Aug 2026 15:33:14 +0200
Message-ID: <20260817132547.776748215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qing Ming <a0yami@mailbox.org>

commit beb33f8ee1ca83acddb2a5ae80f3d22ec550b4c3 upstream.

sctp_process_asconf_param() stores a newly added peer transport in
asoc->new_transport. After all parameters in the ASCONF chunk have been
processed, sctp_sf_do_asconf() uses this pointer to send a HEARTBEAT to the
new transport.

An authenticated ASCONF from a remote SCTP peer can add a transport and
remove it again with a wildcard DEL-IP parameter in the same chunk. The
wildcard deletion preserves the transport on which the ASCONF arrived, but
removes the newly added transport through
sctp_assoc_del_nonprimary_peers(). The removal does not clear
asoc->new_transport, leaving it pointing to the removed transport.

sctp_sf_do_asconf() then creates a HEARTBEAT whose chunk->transport points
to the removed transport without holding a transport reference. During
local address replacement, src_out_of_asoc_ok keeps this HEARTBEAT on
control_chunk_list. After the transport is freed by RCU, a successful
ASCONF_ACK for the replacement address releases the queued HEARTBEAT and
sctp_outq_select_transport() reads the freed transport's state.

The issue was found during a static audit of SCTP objects. With an
authenticated peer, the reproducer triggered the same KASAN report in 2
of 2 unpatched runs on a KASAN-enabled netdev/main kernel:

  BUG: KASAN: slab-use-after-free in sctp_outq_select_transport
  Read of size 4 at addr ffff88800b9bd95c by task python3/197

  Call Trace:
   sctp_outq_select_transport+0x549/0x8b0 [sctp]
   sctp_outq_flush+0x306/0x2c60 [sctp]
   sctp_transport_immediate_rtx+0xaf/0x260 [sctp]
   sctp_process_asconf_ack+0xa48/0xf70 [sctp]

  Allocated by task 197:
   sctp_transport_new+0x68/0x650 [sctp]
   sctp_assoc_add_peer+0x258/0x12a0 [sctp]
   sctp_process_asconf+0x5e9/0x1090 [sctp]

  Last potentially related work creation:
   __call_rcu_common.constprop.0+0x77/0xb70
   sctp_assoc_del_nonprimary_peers+0x7c/0xd0 [sctp]
   sctp_process_asconf+0xd9c/0x1090 [sctp]

The first invalid access was a four-byte read of transport->state at
net/sctp/outqueue.c:833. The same reproducer completed the full
authenticated ASCONF and local-address replacement sequence with this
change without a KASAN report or oops.

Clear new_transport when its peer is removed, before it can be used to
create the HEARTBEAT.

Fixes: 6af29ccc223b ("sctp: Bundle HEAERTBEAT into ASCONF_ACK")
Cc: stable@vger.kernel.org
Signed-off-by: Qing Ming <a0yami@mailbox.org>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260811152803.5629-1-a0yami@mailbox.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/associola.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -543,6 +543,9 @@ void sctp_assoc_rm_peer(struct sctp_asso
 	    asoc->addip_last_asconf->transport == peer)
 		asoc->addip_last_asconf->transport = NULL;
 
+	if (asoc->new_transport == peer)
+		asoc->new_transport = NULL;
+
 	/* If we have something on the transmitted list, we have to
 	 * save it off.  The best place is the active path.
 	 */


