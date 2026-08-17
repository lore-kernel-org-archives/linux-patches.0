Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18BD43802D;
	Mon, 17 Aug 2026 14:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977982; cv=none; b=E1vSIjjcRuNgkT+/ZL2XlnFi0m+MpK4sXPqlwhlTCVbZaxrLJnBWA8eA8QA+lry7Kk12TZMR43ZuSEXAn6ItUyXdrAaAyP7bE09laLf32uLZC/xgrhnb/tPCJcRJlD4JWlWaJAR6fTuFoP9hxPUuJGWWVzjjvqDCNJBdcqMgId8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977982; c=relaxed/simple;
	bh=JaguDEymoFtCK7UWqV1KlqwN3YHdCmUhvDWltBlDCIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYUuOdbXnKw4sKqyxCd5ue1Si1kh7vd1Fwxe8aD2hqKtFZ65dfsbkCcjjbxnKgGwmRPM8O2t/mTO4fb7UoASKPd0p1/fxiw0/He0panuI7owJBx4f+1GnKooefBme75kqBWdHttsSMxAYk4nkVZjcDofwE3896EhFCiWzirBW6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4FUleKV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4FUleKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059811F00A3A;
	Mon, 17 Aug 2026 14:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977981;
	bh=32ZywOErqoZ8o40YnF3htcwVuB0PZGoe6RfEGbfNTDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z4FUleKVoiQnDcDpEvkrYSyKzorehUl4jGJC+ArNinZsUpHh1kXKfgsAtt7Ri7iDm
	 /fwpeXvLFwUI8ximRNWaonmbYnHWbwoJjSgYixeGAdCJCnBHMAapI7c/Wtlj2D7uP8
	 yW52AjSbUIDbCRBV+sMjVix8/S8/pJiZIcAd7Ugk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Linguaglossa <danielelinguaglossa@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/181] sctp: clear control chunk transport if it is being removed
Date: Mon, 17 Aug 2026 15:32:34 +0200
Message-ID: <20260817132537.782607208@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit c9158ceaf27780ef64534ad72f44ffde3f8ccc49 ]

sctp_make_heartbeat_ack() caches the destination transport in
chunk->transport without taking a reference. When src_out_of_asoc_ok is
enabled, the HEARTBEAT ACK may remain queued on control_chunk_list instead
of being transmitted immediately.

If the peer transport is removed while the chunk is still queued,
sctp_assoc_rm_peer() drops the transport and schedules it for RCU freeing,
but only clears cached transport pointers in out_chunk_list.  The queued
control chunk therefore retains a dangling transport pointer.

Once an ASCONF_ACK clears the suppression and the queued control chunk is
transmitted, SCTP dereferences the stale transport pointer, leading to a
use-after-free.

Fix this by also clearing chunk->transport for queued control chunks in
control_chunk_list when removing the transport.

Fixes: 8a07eb0a50ae ("sctp: Add ASCONF operation on the single-homed host")
Reported-by: Daniele Linguaglossa <danielelinguaglossa@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/7e1168cb722132152a29d47e5eafaeac4a3bf6f3.1785943120.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/associola.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 44f06c5f1f256..ebdc48be47813 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -573,6 +573,10 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
 		if (ch->transport == peer)
 			ch->transport = NULL;
 
+	list_for_each_entry(ch, &asoc->outqueue.control_chunk_list, list)
+		if (ch->transport == peer)
+			ch->transport = NULL;
+
 	asoc->peer.transport_count--;
 
 	sctp_ulpevent_notify_peer_addr_change(peer, SCTP_ADDR_REMOVED, 0);
-- 
2.53.0



