Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796021FF7C5;
	Tue, 12 Aug 2025 18:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023024; cv=none; b=QmSwrdiOd03Tgd109D0IUUhhmkBWlfQVuWaXBrCKs73rPotQ3uCyGtWz7iSbzgkqovMg+UuvGJDmZRQlsZ/AvdFBfrtPcT7XHDZcfJzzm5bn+6qRKn5f+bmkYhpLsHnWdHhPdWaIZ021kRhQohvRcM57BwsuDns/vEFm+rv8Etc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023024; c=relaxed/simple;
	bh=XKLWf/mSKfBx4hp27GrhebNR4bxh/CKdqqPitgdSN4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhF4EPlkuujkylGER3hdcXmcsEBzopWHOgo7jbfgRhoIHTSq5GSJkWSmswg0OEF3Jh/LAaGiI5uTgWn56zUNJGFJuxWPAwdMQL6LbDfo1rErsRSOsEhe3UiZrNTd5rS/zk9RndvohxR/dFyLUXIHiM2NXlO8uECDnm96MzI9boY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cs8KH+Gl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cs8KH+Gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD408C4CEF7;
	Tue, 12 Aug 2025 18:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023024;
	bh=XKLWf/mSKfBx4hp27GrhebNR4bxh/CKdqqPitgdSN4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cs8KH+Glu4XrDNltVXYUNxDhoR+t003g06OIiwNtLfuQBoeZR/HjiYLesn5yjNcLA
	 8t1hHtvuHfLNSO1kKeM1T+hVoRdI0j7zySben7VNFzhmhmwrU8iELof+1gz139W0RZ
	 iDwk1oF6x+gEHBHC9Qc3qg5z/lwKbzj77W4UV4ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quang Le <quanglex97@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 328/369] net/packet: fix a race in packet_set_ring() and packet_notifier()
Date: Tue, 12 Aug 2025 19:30:25 +0200
Message-ID: <20250812173029.052171172@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Quang Le <quanglex97@gmail.com>

commit 01d3c8417b9c1b884a8a981a3b886da556512f36 upstream.

When packet_set_ring() releases po->bind_lock, another thread can
run packet_notifier() and process an NETDEV_UP event.

This race and the fix are both similar to that of commit 15fe076edea7
("net/packet: fix a race in packet_bind() and packet_notifier()").

There too the packet_notifier NETDEV_UP event managed to run while a
po->bind_lock critical section had to be temporarily released. And
the fix was similarly to temporarily set po->num to zero to keep
the socket unhooked until the lock is retaken.

The po->bind_lock in packet_set_ring and packet_notifier precede the
introduction of git history.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Quang Le <quanglex97@gmail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250801175423.2970334-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4562,10 +4562,10 @@ static int packet_set_ring(struct sock *
 	spin_lock(&po->bind_lock);
 	was_running = packet_sock_flag(po, PACKET_SOCK_RUNNING);
 	num = po->num;
-	if (was_running) {
-		WRITE_ONCE(po->num, 0);
+	WRITE_ONCE(po->num, 0);
+	if (was_running)
 		__unregister_prot_hook(sk, false);
-	}
+
 	spin_unlock(&po->bind_lock);
 
 	synchronize_net();
@@ -4597,10 +4597,10 @@ static int packet_set_ring(struct sock *
 	mutex_unlock(&po->pg_vec_lock);
 
 	spin_lock(&po->bind_lock);
-	if (was_running) {
-		WRITE_ONCE(po->num, num);
+	WRITE_ONCE(po->num, num);
+	if (was_running)
 		register_prot_hook(sk);
-	}
+
 	spin_unlock(&po->bind_lock);
 	if (pg_vec && (po->tp_version > TPACKET_V2)) {
 		/* Because we don't support block-based V3 on tx-ring */


