Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A0A4ABBA9;
	Wed, 30 Sep 2026 19:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797104; cv=none; b=CsLJoqN0KFUCaEjgMGr6UXjecztQQgeHZyRAUs2MuA7rj8Ld5DFrNXyJUBfQ5m0iL7sdaypw2qX4VnUJ+ukuCx0kApWT5ALnqAUOZVwpWEmEtHFoXMJ94qYKaZrOZ60xlA074wjDsaRuyJNrHQhSZH1g7rEbkQ2qrue70xAoye8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797104; c=relaxed/simple;
	bh=QfWpWqWkIOwIvnFwfN4usnQYcsXpRRSLHFOHio8WN1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O79/mA83jRVpKw0mPqrt7up7AxXk2je0rpMiwq5W+SbsyYSwUNgRrGiIT9soUYB0QLcqzrdhvxTN9+8HSGL6jMzt23XjeGHrWVuVRa6VzI6ixke3nSf8lxHr0UXNxT+spd3Z232HdT32VABlH0c4GSFUm+YsbjAL/ewbYPsNzwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzGldbdx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzGldbdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DAC1F00898;
	Wed, 30 Sep 2026 19:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797102;
	bh=/yZvzUTUtQxmK8ofavwqC+VaVqxZx1loIK5OXHwBzjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xzGldbdxNsC7JC6ZXfaTa6+CbogWvgv1aDju1kRSFg4pTANepHLyHtH7Jm5pnl2DK
	 17ONJB0IbRIyGT1ALYEinpA3PFjo1luUCOi1PHdlv7/+LRin573DQIQ3XPGILdgo/J
	 8r5wbbYjjFZVh/aGEOJVC7a6UTs2dtz3U+K7k2ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1093/1193] sctp: discard the rest of the packet on a stale-cookie error
Date: Wed, 30 Sep 2026 17:29:37 +0200
Message-ID: <20260930152458.517152669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aohan Mei <henrymei@tencent.com>

commit 4498467a8af06cfa3d71cb04bd7c4170dec8f449 upstream.

When an association is in COOKIE-ECHOED state and the peer sends a
bundled [ERROR(Stale Cookie)][DATA] packet from one of its non-primary
addresses, processing the ERROR chunk takes the non-fatal stale-cookie
retry path sctp_sf_do_5_2_6_stale(), which queues
SCTP_CMD_DEL_NON_PRIMARY while keeping the association alive.
sctp_cmd_del_non_primary() removes every non-primary transport -
including the very transport this packet arrived on, which is still
referenced by the receive lookup and shared by all chunks of the
packet via chunk->transport.

sctp_assoc_rm_peer() does redirect asoc->peer.last_data_from away from
the removed transport, but right afterwards the bundled DATA chunk
makes sctp_assoc_bh_rcv() re-register
asoc->peer.last_data_from = chunk->transport unconditionally, undoing
the redirection with the just-removed transport.

Once the packet is done, the receive reference is dropped and the
transport is RCU-freed, while the surviving association keeps the
dangling last_data_from.  A later FWD-TSN (or the delayed SACK timer)
makes sctp_gen_sack() dereference it (->param_flags and friends), and
sctp_make_sack()/sctp_outq_select_transport() may write to the freed
object and link it into the live transport list.  This is a
use-after-free triggerable by any malicious SCTP peer (or a local
unprivileged user acting as one) with no capabilities required:

  BUG: KASAN: slab-use-after-free in sctp_do_sm+0x498a/0x5660
  Read of size 4 at addr ffff88800e1e356c by task poc/115
  Call Trace: sctp_do_sm <- sctp_assoc_bh_rcv <- sctp_inq_push <-
              sctp_rcv <- ip_protocol_deliver_rcu <- ip_rcv
  Allocated: sctp_transport_new <- sctp_assoc_add_peer <-
             sctp_process_init (INIT-ACK processing)
  Freed: kfree <- sctp_transport_destroy_rcu <- rcu_core
         (call_rcu queued by sctp_transport_put at end of sctp_rcv)
  The buggy address is located 364 bytes inside of freed 1024-byte
  region [ffff88800e1e3400, ffff88800e1e3800), cache kmalloc-1k

Note that commit 03a9d10ecf71 ("sctp: drop a chunk if its transport
was removed") only covers the window between the receive lookup and
the chunk processing (e.g. an ASCONF DEL-IP racing the socket backlog);
here the transport is removed *while* the packet is being processed,
by an earlier chunk of the same packet, so the drop in sctp_inq_push()
does not reach this path.  Verified with the bundled [ERROR(Stale
Cookie)][DATA] + FWD-TSN reproducer: the KASAN report above still
fires with that commit applied, and is gone with this patch on top.

Fix it by discarding the rest of the packet on this path, as suggested
by Xin.  After the stale-cookie ERROR has sent the association back to
COOKIE-WAIT and removed the non-primary transports, the remaining
chunks of the packet can only run against the restarted handshake
while referencing the removed arrival transport through
chunk->transport: besides the last_data_from registration above,
sctp_cmd_setup_t2() and the sctp_make_*() reply builders would also
copy that pointer into association-lifetime state that
sctp_assoc_rm_peer() has already sanitized.  Let the peer retransmit
them, in line with what sctp_inq_push() does for chunks whose
transport was removed before processing.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Xin Long <lucien.xin@gmail.com>
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Signed-off-by: Aohan Mei <henrymei@tencent.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260921093707.1432184-1-ljp1205831794@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_statefuns.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2623,6 +2623,8 @@ static enum sctp_disposition sctp_sf_do_
 
 	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(reply));
 
+	sctp_add_cmd_sf(commands, SCTP_CMD_DISCARD_PACKET, SCTP_NULL());
+
 	return SCTP_DISPOSITION_CONSUME;
 
 nomem:


