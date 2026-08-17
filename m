Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9F63B42DC;
	Mon, 17 Aug 2026 14:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976329; cv=none; b=jtbvyjtBjoAiTVJyKhJ8kfR6aejOSMSoPt6LnZhSmsnuIAEa+OraIdguUGE+heaBnnjC5dm/PfFGe8BOE/QRGKtAUA+JongL2J9EQv4bhoZrjlTR+bNPsI3mKgrS+KGxvU6WtEVLvJFWR5R+6X4JyvRxIYBHB8f8PMIGdEOKNNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976329; c=relaxed/simple;
	bh=mPMFIAIJ+760oALxkQZKHCfBSwn4IgBiB2xNpECp7Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJnFMgu+RRv5U0WdST0Hl/DeGBwRGdxtf4f5hwK9L1efJMwCbtk6uWC4ZE7pW2slzTa+81pIh8hmqFjZtM4lhROZsds/6346fabpbrLHe5Oz99CtscVyQ3OeY9J4xL/GFjn1995fiUtC/qRoSzTwZHnj+9lHxKS4khI2qRaD7Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lpk3gElX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lpk3gElX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DB51F000E9;
	Mon, 17 Aug 2026 14:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976328;
	bh=gEfVSuBAvQz4ZNwZ778KduR0xLzlyrBoQ25BixvjBN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lpk3gElXAx8wEsLnAIQtLFdER6PnZDwW0C1NdYtm41SiBwTSIJFwM1slihWFyk7SP
	 NJMnxm13PLCOVlZmkH8NdnONKHNIuaUDc08jIVi3iuHIlYSK2be2r8vKoWpnEbWXbB
	 6AoGwLNecQEnwq/SlMYmJl2JJB3two6LlPidD3KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Linguaglossa <danielelinguaglossa@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 336/389] sctp: clear control chunk transport if it is being removed
Date: Mon, 17 Aug 2026 15:32:55 +0200
Message-ID: <20260817132551.964949977@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
index 86d86ec9d90aa..122f0a948430f 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -572,6 +572,10 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
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



