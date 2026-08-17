Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8230442B3B;
	Mon, 17 Aug 2026 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980422; cv=none; b=L+/VRPwRIrSF2UwtXo3C7XOHN9e08uxjVTU1bZycqGYhsS/skLZgXXyd1PAd3xx+e90r8mpdW5uph+lWEJseds1JqVdA1HA2UuwXaW2mwWcnGsqFkCRG2l0/RLVqykt+OUbaCerUb5GnzWhOKbW3Lyn2XzDkCZFqsnbtxId3qg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980422; c=relaxed/simple;
	bh=XC/ffvHTMfDrWvJmh1N6hdhQe60ydsmkB7Dm9J1FyjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaTiNamkFcMjQ04Mwm2s+0XJsnFx9jzpDbtkCyotbqgkllB/V3p/9fKF7XR1O530C+nq9GeWJjWBqy7RDiPmoSrkR+dtcwR6NX5Y3cwCVenfr+wIvVWDcqV7IN4HuPn70GTYCryHiCY50HbsgSo9w49DSxR4v+1t9I/kxborbgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwyC1fqv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwyC1fqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEC11F000E9;
	Mon, 17 Aug 2026 15:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980421;
	bh=ikFxhBFxwMP4GPNWZj0zjv1SX5o2IAC4HzRfvu7+2t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SwyC1fqvlc+3xmjIWDbk8G4rc9yXsVlUAuKlJviHpbNoEFXVFEJNEV9mEiYh1YDxC
	 KAlW2TJPuHUtGh2TBJRcF0eJtaGpoU2d9I3PclHhGphW2g5xjYwqf2setnzmWzgcI3
	 nM4r9y4nk0aQxZruchTWDuCNpk8b/ziGWSzmtlFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Linguaglossa <danielelinguaglossa@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 530/609] sctp: clear control chunk transport if it is being removed
Date: Mon, 17 Aug 2026 15:33:46 +0200
Message-ID: <20260817132601.525708101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4dd36c8375507..4a79e855c85cd 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -575,6 +575,10 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
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



