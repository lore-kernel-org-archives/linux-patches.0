Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590103;
	b=biuyJmRhapfukM7qJLjVvF2HvxMAcTl6iDHvAAo+3iFEvM+PRKUWIzeMAuse6m6s8gmm
	 3m7/6548my7V/aKfQZxAdqwr2TDqj7Gz9NjFE/uk7edn7ONCmVzpDw7naDsRM6p4Ggauh
	 XmzxmdZ+mELoC2MZVgae3o9S/V3Q3yiiqRyHAabeIHa3dPswcuJk8Dy6fuvKeGWVdu885
	 iQrq9csO7M9scFM5FymYFQReHMEbEkGVMoxujE2TwbzAfa1lsDYQd0LRpiU5pIsK4q640
	 L7S/PRqGP5AaQgMgrLmTdQT+0QvqcYDeHwUTxVDOiJsqRaiZ0TzXsJDtIds1Rb5/Fjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eDD4Gi0jSZJrlqj9PXt+23HwjKy94qpkw3jHE1W9mqY=;
	b=Gv4N4WCzWqNJrfVjGPSTLjkZ9XQto61if/VrHiUUD24uAzoMxurw5yM0aoo1fiyVNSi8
	 RKgnJN5BzSNS5K5v156zwxk76Nbe2aWtII5dPVtf8I2hgrkBG82wF174zUPBuHU+NDJPr
	 Hfvm7UW6B+cV0i4GePllXEkbduatnTk5vqeDBaFdl3sPnlzEVr+qpIvlLMlOY3CS66aQi
	 dorN/P25XTwlYsvJm7msL53zhRgVn3DJKqMDatq4RIx+TAE7PXd1iGoo6Ugpo2jbJlsgh
	 HQedeWkY3zn1+iCihrFnO9SoqXhDgI/NMjSR/TUwZzKmkMcC+vFflbvRnuL22fJcn8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u/c8er4b";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754DE60A3832;
	Fri, 13 Nov 2026 17:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u/c8er4b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97B61F000C4;
	Fri, 13 Nov 2026 17:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590103;
	bh=eDD4Gi0jSZJrlqj9PXt+23HwjKy94qpkw3jHE1W9mqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/c8er4bqJQxS3bA7nbsk1yOjJq+vYMXfAbbfcnK2tcitcdCvth2syl+VjhVGvinw
	 ytjWEb1XvaY+u8+myhq+3GQlJ9HXCEFj3KlNN8Gm6+PfCv1ZbrM05QKkx50UUu3/es
	 YAS/c8v4jeGJCnzomI+vcRquVGYSFzx2P7ME19i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 126/686] ax25: dont let connect() find its own socket when calling the same station
Date: Fri, 13 Nov 2026 10:44:19 -0500
Message-ID: <20261113153825.092707048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

Before it starts a link, ax25_connect() looks on ax25_list for an
existing connection with the same source, destination, digipeater path
and device, and returns -EADDRINUSE if there is one. A bound socket is
on that list itself, with the destination of its previous attempt, and
its digipeater path was just freed. When a connect() failed or the
connection ended, a new connect() to the same station without
digipeaters thus finds the socket itself, and fails with -EADDRINUSE
every time.

Forget the previous destination before the lookup, under
ax25_list_lock, where the list readers compare it.

Tested on a QEMU bench (6.12.94 with KASAN and lockdep, two guests over
a KISS serial link). A starts listening on TESTA-9 after 7 s. B calls
TESTA-9 with one socket before that, which times out, then calls
TESTA-9 again with the same socket, non-blocking, and checks 3 s later:

  before: -EADDRINUSE on the second call and on the check, A accepts
          nothing
  after:  -EINPROGRESS, then the check returns 0 and A accepts the
          connection, three runs out of three

send() on the new connection still fails with -EPIPE unless "ax25: let
a socket connect again after a failed or ended connection" is applied
as well; with both, and with "ax25: free the old digipeater path of a
listed socket under ax25_list_lock", A receives the message.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit efd5dce53a6bc296186212d4a16961174fd3df83)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 51a066ae4e89f..d0ac09cc46e74 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1374,6 +1374,15 @@ static int __must_check ax25_connect(struct socket *sock,
 		goto out_release;
 	}
 
+	/*
+	 * The socket is on ax25_list with the destination of its previous
+	 * attempt, if any: forget it, or the lookup below finds the socket
+	 * itself when the same station is called again.
+	 */
+	spin_lock_bh(&ax25_list_lock);
+	ax25->dest_addr = null_ax25_address;
+	spin_unlock_bh(&ax25_list_lock);
+
 	if (sk->sk_type == SOCK_SEQPACKET &&
 	    (ax25t=ax25_find_cb(&ax25->source_addr, &fsa->fsa_ax25.sax25_call, digi,
 			 ax25->ax25_dev->dev))) {
-- 
2.53.0



