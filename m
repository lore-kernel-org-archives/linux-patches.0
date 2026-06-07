Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24ADD2D3A69;
	Sun,  7 Jun 2026 10:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828550; cv=none; b=N3qOvdCze01ftR/nmrgEQmhs4gbCQJjMvipYe0KDCBZtS462eIkghcvynB6ZnuwCy5Dg68xhBxjkKZadzAxelfN5/tX9s7OGhEUHkB/l6muHtmDelsywGeGwc2/Vuaj/oR3RzX5S83OBeQZJ+zQ+dYKv/HoJXh2v/J4eHRFNPIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828550; c=relaxed/simple;
	bh=saXkPIjeQfHl1vJwqmBFFC7NED6r500g+Jv+M9kJ0WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukYzmcYMUJDCGhDwf1JwbF6QExKFL+Li774vuw0aWg2/kdpca1stmzmpMjFlidyJctWhLL1h638ALHCxijvBctlvsJQ5ZZnFEdk/rQN3Z+6mV6wXillqkuaKApFb0oUt8B50y8Ug4hVn5FNb2SV0LzTfM8i77/Ojy1MFZvSU6PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLl99tbd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLl99tbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF7F1F00893;
	Sun,  7 Jun 2026 10:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828549;
	bh=UfWgzg7S3DHf2TSlUuPqIZR87fZ4mlYayz/2vlh5xmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLl99tbdtM2/gFJ+C6j2UAhqFL/2oi/TFqXtWNpGjUwzo+R7srxCF+QRvHNzKuNKW
	 BNg6btdISi5WyVCU15ye8ewhj4luwpRqSyp3PplrH5JXa42KTOOaRl1/ol1MBShQej
	 38rAy2LOD9jakYX5ixKByohKweELp8l9RzYe4l5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 147/307] Bluetooth: ISO: serialize iso_sock_clear_timer with socket lock
Date: Sun,  7 Jun 2026 11:59:04 +0200
Message-ID: <20260607095733.128694817@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
@@ -835,8 +835,8 @@ static void __iso_sock_close(struct sock
 /* Must be called on unlocked socket. */
 static void iso_sock_close(struct sock *sk)
 {
-	iso_sock_clear_timer(sk);
 	lock_sock(sk);
+	iso_sock_clear_timer(sk);
 	__iso_sock_close(sk);
 	release_sock(sk);
 	iso_sock_kill(sk);


