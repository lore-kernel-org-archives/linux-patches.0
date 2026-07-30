Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2526A449B2B;
	Thu, 30 Jul 2026 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427890; cv=none; b=dFlLSTMGyf8zv7fg3jPU3tRWZvT273Zla3+GUruGnneUSBPMgj1JDeBNNvp5NMEbXO13a95ElYNASHPml4NpDkcWwSnns9QW9g3VGjyCY6UafcI7uTmeWTx9m5LX4ojyOqKbTssspHqk8vortt8wYbjWlFFgTIa7Arf6MYM2OeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427890; c=relaxed/simple;
	bh=If/e3+GV/UYU0JKUM8kg9D+8ZNbz5sSRH2hbMqjnLbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlJUvWd+Gyfub3U10S+rCNxcZtOo0dAdWeeFo7DzDsZ7H/GaWehZq3Q6WA9uarI3MEU63KWFRDRvxaE9kWSFVmAvJU3A4bPPRtuVMtd36x+wl1QD51iyXLpoUfVyC52ZvYSLOUjNfl3G3AcXFN+LOH7D+6rNQ/0qBqwDaVUgQqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sej+aYLu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sej+aYLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6551F000E9;
	Thu, 30 Jul 2026 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427889;
	bh=9qhrisVVtqRlMBGN4dbrgSCTNhLbAXHZthvqCjroeZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sej+aYLuuxWeRPX57awiANNCwYhlC5Q70m9fupJqygcFlMcDgYdErjv/wjfnnRaPO
	 +tj6LjdnnmJlwGgyar6UN+REAdrQEfJwe/zGsNStTCmkuaoE6FzdlBB8kWO1O+JZBr
	 XggzemGD/M5XqBlfGbOb442k+Ya8jP//wqp96jb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Martin Schiller <ms@dev.tdt.de>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 322/484] net/x25: fix use-after-free in x25_kill_by_neigh()
Date: Thu, 30 Jul 2026 16:13:39 +0200
Message-ID: <20260730141430.481128013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: David Lee <david.lee@trailofbits.com>

commit 5499e0602d2faafd42c580d25f615903c3fbe11b upstream.

x25_kill_by_neigh() walks the global X.25 socket list looking for sockets
attached to a terminating neighbour. x25_list_lock protects list membership
while the lookup is in progress, but it does not pin a socket's lifetime
after the lock is dropped.

The function currently drops x25_list_lock before calling lock_sock(s). A
concurrent close can run x25_release(), remove the same socket from
x25_list, and drop the last socket reference in that window. The neighbour
teardown path can then lock or inspect a freed struct sock/struct x25_sock.

Take sock_hold(s) while x25_list_lock still proves that the list entry is
live, then drop the temporary reference after the socket has been locked,
rechecked, and released. Recheck x25_sk(s)->neighbour after lock_sock(),
because another path may have disconnected the socket before this path
acquired the socket lock. Restart the list walk after each disconnect
because the list lock was dropped and the previous iterator state may no
longer be valid.

A QEMU/KASAN run against origin/master reproduced a slab-use-after-free in
x25_kill_by_neigh().

Fixes: 7781607938c8 ("net/x25: Fix null-ptr-deref caused by x25_disconnect")
Cc: stable@vger.kernel.org
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Acked-by: Martin Schiller <ms@dev.tdt.de>
Link: https://patch.msgid.link/20260713104752.241175-1-david.lee@trailofbits.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/x25/af_x25.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1772,15 +1772,19 @@ void x25_kill_by_neigh(struct x25_neigh
 {
 	struct sock *s;
 
+again:
 	write_lock_bh(&x25_list_lock);
 
 	sk_for_each(s, &x25_list) {
 		if (x25_sk(s)->neighbour == nb) {
+			sock_hold(s);
 			write_unlock_bh(&x25_list_lock);
 			lock_sock(s);
-			x25_disconnect(s, ENETUNREACH, 0, 0);
+			if (x25_sk(s)->neighbour == nb)
+				x25_disconnect(s, ENETUNREACH, 0, 0);
 			release_sock(s);
-			write_lock_bh(&x25_list_lock);
+			sock_put(s);
+			goto again;
 		}
 	}
 	write_unlock_bh(&x25_list_lock);


