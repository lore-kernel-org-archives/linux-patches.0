Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3979B168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1C2C433EF;
	Mon,  8 May 2023 09:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539441;
	bh=2mpnOqWxpEpI0cTAts/u0E+GMwSudv3Lxo6rRUfhOzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQPin/rtyK5PJKavFaC8V9T3vP4WcwhsYf0fPVcsl5NnWG2flANUb6ZUwAiyPoQYL
	 X2TLHGC8ILIX0Kk+LBiPJXyYa9F2pdgiY0drZOglEd7mUoFcKU3ohPToE2a3b6t8VH
	 WM8PVvPOHtoBGK8PAWbzhTJD07Onio7KF67OKhU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Liska <mliska@suse.cz>,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Chris Clayton <chris2553@googlemail.com>
Subject: [PATCH 6.1 018/611] wireguard: timers: cast enum limits members to int in prints
Date: Mon,  8 May 2023 11:37:40 +0200
Message-Id: <20230508094422.296626650@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit 2d4ee16d969c97996e80e4c9cb6de0acaff22c9f upstream.

Since gcc13, each member of an enum has the same type as the enum. And
that is inherited from its members. Provided "REKEY_AFTER_MESSAGES =
1ULL << 60", the named type is unsigned long.

This generates warnings with gcc-13:
  error: format '%d' expects argument of type 'int', but argument 6 has type 'long unsigned int'

Cast those particular enum members to int when printing them.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113
Cc: Martin Liska <mliska@suse.cz>
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://lore.kernel.org/all/20221213225208.3343692-2-Jason@zx2c4.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Chris Clayton <chris2553@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/timers.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/wireguard/timers.c
+++ b/drivers/net/wireguard/timers.c
@@ -46,7 +46,7 @@ static void wg_expired_retransmit_handsh
 	if (peer->timer_handshake_attempts > MAX_TIMER_HANDSHAKES) {
 		pr_debug("%s: Handshake for peer %llu (%pISpfsc) did not complete after %d attempts, giving up\n",
 			 peer->device->dev->name, peer->internal_id,
-			 &peer->endpoint.addr, MAX_TIMER_HANDSHAKES + 2);
+			 &peer->endpoint.addr, (int)MAX_TIMER_HANDSHAKES + 2);
 
 		del_timer(&peer->timer_send_keepalive);
 		/* We drop all packets without a keypair and don't try again,
@@ -64,7 +64,7 @@ static void wg_expired_retransmit_handsh
 		++peer->timer_handshake_attempts;
 		pr_debug("%s: Handshake for peer %llu (%pISpfsc) did not complete after %d seconds, retrying (try %d)\n",
 			 peer->device->dev->name, peer->internal_id,
-			 &peer->endpoint.addr, REKEY_TIMEOUT,
+			 &peer->endpoint.addr, (int)REKEY_TIMEOUT,
 			 peer->timer_handshake_attempts + 1);
 
 		/* We clear the endpoint address src address, in case this is
@@ -94,7 +94,7 @@ static void wg_expired_new_handshake(str
 
 	pr_debug("%s: Retrying handshake with peer %llu (%pISpfsc) because we stopped hearing back after %d seconds\n",
 		 peer->device->dev->name, peer->internal_id,
-		 &peer->endpoint.addr, KEEPALIVE_TIMEOUT + REKEY_TIMEOUT);
+		 &peer->endpoint.addr, (int)(KEEPALIVE_TIMEOUT + REKEY_TIMEOUT));
 	/* We clear the endpoint address src address, in case this is the cause
 	 * of trouble.
 	 */
@@ -126,7 +126,7 @@ static void wg_queued_expired_zero_key_m
 
 	pr_debug("%s: Zeroing out all keys for peer %llu (%pISpfsc), since we haven't received a new one in %d seconds\n",
 		 peer->device->dev->name, peer->internal_id,
-		 &peer->endpoint.addr, REJECT_AFTER_TIME * 3);
+		 &peer->endpoint.addr, (int)REJECT_AFTER_TIME * 3);
 	wg_noise_handshake_clear(&peer->handshake);
 	wg_noise_keypairs_clear(&peer->keypairs);
 	wg_peer_put(peer);


