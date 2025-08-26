Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71418286881;
	Tue, 26 Aug 2025 14:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217553; cv=none; b=sRhoU+RjTuzH4vOU1h0JA3/zrrJNBIcmrbJq9ofXGE3YMe0BhD7DmCYpkTmnCzOfNBSpX7TLy1MLD1G4LwfyLR6P+3Vo2mdABzZOk9QQZ13lVe9RsTFe9ilv44yIbsIWLyTltdf9ApEB9PKPCmBIL1lJYq6qBeCpaXx4BoYL9r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217553; c=relaxed/simple;
	bh=FWhZlrgXGoHPFLvx8ThJ05/LHYAscgoP3sztOeTYLEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxacvLbVr1BO/J4uAGdGeNb1RoFAABfyrzzRYMhVPnAVjtmdi2pfa5EHN+KR9KA31SYwAmRBPabKOKY8QsyXzunBRvK9d46xYK3m+AaQFXNt8T7d257OZlRN8ivqqHI8HxgiM6G1LV941luMevmwpUmjxZekcpRJucEElRw+NWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0BHEw6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0BHEw6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2785C19421;
	Tue, 26 Aug 2025 14:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217553;
	bh=FWhZlrgXGoHPFLvx8ThJ05/LHYAscgoP3sztOeTYLEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0BHEw6qEE8hTJdLOKzQ0yGrTAsygvMnB8jmU9ndC2UbwNVKZG1cAcVHLb/AH6Uqi
	 AUP7BruWaXpX7XiajpoQ1CuF7LIN/w89Bp3Jkd6QoKx3sYWOAMcYLbZGvtrythdQ++
	 8UTW24Kk/pZmm8WTLV6wwXjECCRFPce69pQ3NiO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quang Le <quanglex97@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 186/523] net/packet: fix a race in packet_set_ring() and packet_notifier()
Date: Tue, 26 Aug 2025 13:06:36 +0200
Message-ID: <20250826110929.041444478@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4514,10 +4514,10 @@ static int packet_set_ring(struct sock *
 	spin_lock(&po->bind_lock);
 	was_running = po->running;
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
@@ -4549,10 +4549,10 @@ static int packet_set_ring(struct sock *
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


