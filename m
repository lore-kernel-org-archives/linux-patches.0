Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04477449EC3;
	Tue, 16 Jun 2026 16:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628470; cv=none; b=aP24BQso6hVkyRnsjh7JQvWNdJrdmm/Bdk4NAodZSUm1wMLT/TK42oBCr37dFe7zZSFuHNHU+r7++F+vZBYgP+zyf0fYpiuNaPg3oDQJdD8yUnTSDHREN2A6aFN17cmaeUnpOOYVMDoIqlHX9iqXo4efb3vND4fz13MpGuiqreQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628470; c=relaxed/simple;
	bh=Nn4+LfHQ6DaeYZlJCnd5zmnMT/DvhHxTAYBFqu52wpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQQC7Vi1LcRUqTIyOYyvOecvhG+3MY3rawIyoe67KC+DqDoqj3wP8ypZsaV4m/aWS2Iwk6rGHG85XGpKR/30QEoyW67nwyX/rLjgL3SqHy6CZ0lj1ihBTYuMIMUUb02VJuA1KigKeW2ferBbsFdx0dAP7AwB1ULuBfcfb1IJDR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FunFqjF8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FunFqjF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D521F000E9;
	Tue, 16 Jun 2026 16:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628468;
	bh=Hn6puAYzvB4PACiNrYZSkpLQ78qFVI9rwiOV2mzNpXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FunFqjF8ZkvKS/TyYt+PuB1AqHtDViIFsua3WCzfVLtdrwTBfCNcu7IWdn2fyupCF
	 I0ia/Ir5yVjw/D4s0ThmverzowwlACGAz6eSaNdsbzHB/MRgwHNm/A9SKx40pwjH8r
	 bmZH72JG8RqXeeHcZ+qMQEiPBRREshrEZ7kP7bws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 101/452] Bluetooth: ISO: serialize iso_sock_clear_timer with socket lock
Date: Tue, 16 Jun 2026 20:25:28 +0530
Message-ID: <20260616145123.091353285@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

commit 4b5f8e608749b7e8fa386c6e4301cf9272595859 upstream.

iso_sock_close() calls iso_sock_clear_timer() before acquiring
lock_sock(sk).

iso_sock_clear_timer() reads iso_pi(sk)->conn twice without the
socket lock held:

    if (!iso_pi(sk)->conn)
        return;
    cancel_delayed_work(&iso_pi(sk)->conn->timeout_work);

Concurrently, iso_conn_del() executes under lock_sock(sk) and calls
iso_chan_del(), which sets iso_pi(sk)->conn to NULL and may result in
the final reference to the connection being dropped:

    CPU0                         CPU1
    ----                         ----
    iso_sock_clear_timer()
      if (conn != NULL) ...      lock_sock(sk)
                                   iso_chan_del()
                                   iso_pi(sk)->conn = NULL
      cancel_delayed_work(conn)  /* NULL deref or UAF */

iso_pi(sk)->conn is not stable across the unlock window, causing a
NULL pointer dereference or use-after-free.

Serialize iso_sock_clear_timer() with the socket lock by moving it
inside lock_sock()/release_sock(), matching the pattern used in
iso_conn_del() and all other call sites.

Fixes: ccf74f2390d60a2f9a75ef496d2564abb478f46a ("Bluetooth: Add BTPROTO_ISO socket type")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/iso.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -808,8 +808,8 @@ static void __iso_sock_close(struct sock
 /* Must be called on unlocked socket. */
 static void iso_sock_close(struct sock *sk)
 {
-	iso_sock_clear_timer(sk);
 	lock_sock(sk);
+	iso_sock_clear_timer(sk);
 	__iso_sock_close(sk);
 	release_sock(sk);
 	iso_sock_kill(sk);


