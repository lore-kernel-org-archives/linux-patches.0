Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F08043B3EC;
	Mon, 17 Aug 2026 14:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977118; cv=none; b=GNDqQRPmUdshGDx09dROEIgj9xNWLTuhhK1qmG/c8lIFXPWbCpni/OooLA2hIDGGjoZozf9nZz3VX9EprcHqohD0iul5pyS5EmwR5hn9JgtHeP1d6hUH0S3tpAPNsmk9ecB0a0ox8PM3oE0Al9igVxhXiLMGKkmVntDsjoyM7OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977118; c=relaxed/simple;
	bh=T03AWWYYkdj0ufaBUh1ABXqBNPKkuxVdrIHN1pm+DKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnlBjtx+QhpxueWfnTRiohRIGF98I9i89eFpu8+KVMPUWrYMtVz+h+pfQubmjdIz8GrjwDAshu5BcGbEhBcejkz/Q7Cr1d2ypR4U2uqJ6OUDRi2L6jYoBa5lwoVkqQPvOycDkTxcoiAFBSDDfnkYXSznrAMldJq9yNK5iuXaVLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/RsHR2W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/RsHR2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A2A1F000E9;
	Mon, 17 Aug 2026 14:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977117;
	bh=7bchEMZtul9iDAvf1Ybz6bWYOgnEOV8qjctfKC3X7ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/RsHR2Wg5Rv0Ih4oi2Qm2TDfEhU+4HzEVI9Gp5NyXKtq1K7/hkLY2/s6C+26WHfx
	 IPKIEILUpkKhCawjnMiI7iXbyuQm0KzeA/cUcwditMoUuiW08VxC8gEY9k5lfL/TXE
	 KGh6E1T/z7wGWJFZBiMimqSwTZMhOcKNJJmxfg84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Martin Schiller <ms@dev.tdt.de>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 217/456] net/x25: fix use-after-free in x25_kill_by_neigh()
Date: Mon, 17 Aug 2026 15:30:07 +0200
Message-ID: <20260817132548.675711348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1769,15 +1769,19 @@ void x25_kill_by_neigh(struct x25_neigh
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


