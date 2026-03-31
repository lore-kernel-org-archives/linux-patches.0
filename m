Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129D7401A2C;
	Tue, 31 Mar 2026 16:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974675; cv=none; b=K+3eXtRvWyFQoCBirsnsYl0tHu6JzADRgDO4nSIOtZPxMLrxioa0qUVVfMKHJnAlWuGF59ds6Wcn4vmqA6XQMmTtZE+aymnTlMlejOeGqA2LT+BDIuB1rs18usvZLhyKn8YP4lusmxLBCHSUNcdGpCMcntmyswQ7LKZgDNuOcBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974675; c=relaxed/simple;
	bh=TOY6M3o1lbBUPySfiTq8GkasiaKVbHvpL5nhaqq0k6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8WLG1dLhUIxOn8v9ZbLjjpddXz6Od647xAKM1g8bayFE+b1VjPiI8xYvc4GNSpVgfJQRn8rt0Pn4SnjptJmuGZuu6stG9BU63Ga93HN7olIMNZ88Bj/DrgIFugg2yKCSn5dyGmF05otLEbX9p9QvrRVAESUZKMYkbe6xB675e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mih4kzge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mih4kzge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6F6C19424;
	Tue, 31 Mar 2026 16:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974675;
	bh=TOY6M3o1lbBUPySfiTq8GkasiaKVbHvpL5nhaqq0k6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mih4kzge46N6SL0bcXZvfB66c4UL+ZmWU6jahCmhmL+mHSZaviNShbkx3ZdPs6R2C
	 GlHeqKXq+OvuHWi8F4i69DtDnUSa2Zhe+X2DK/Cp2gtevA28KXp/+5Hkre91mttv36
	 RhXlJ402HRjwjdNOwvBylsQkdhAfl8P0yYfEsCAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 175/175] tcp: Fix bind() regression for v6-only wildcard and v4-mapped-v6 non-wildcard addresses.
Date: Tue, 31 Mar 2026 18:22:39 +0200
Message-ID: <20260331161736.222746088@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit ea111449501ea32bf6da82750de860243691efc7 upstream.

Commit 5e07e672412b ("tcp: Use bhash2 for v4-mapped-v6 non-wildcard
address.") introduced bind() regression for v4-mapped-v6 address.

When we bind() the following two addresses on the same port, the 2nd
bind() should succeed but fails now.

  1. [::] w/ IPV6_ONLY
  2. ::ffff:127.0.0.1

After the chagne, v4-mapped-v6 uses bhash2 instead of bhash to
detect conflict faster, but I forgot to add a necessary change.

During the 2nd bind(), inet_bind2_bucket_match_addr_any() returns
the tb2 bucket of [::], and inet_bhash2_conflict() finally calls
inet_bind_conflict(), which returns true, meaning conflict.

  inet_bhash2_addr_any_conflict
  |- inet_bind2_bucket_match_addr_any  <-- return [::] bucket
  `- inet_bhash2_conflict
     `- __inet_bhash2_conflict <-- checks IPV6_ONLY for AF_INET
        |                          but not for v4-mapped-v6 address
        `- inet_bind_conflict  <-- does not check address

inet_bind_conflict() does not check socket addresses because
__inet_bhash2_conflict() is expected to do so.

However, it checks IPV6_V6ONLY attribute only against AF_INET
socket, and not for v4-mapped-v6 address.

As a result, v4-mapped-v6 address conflicts with v6-only wildcard
address.

To avoid that, let's add the missing test to use bhash2 for
v4-mapped-v6 address.

Fixes: 5e07e672412b ("tcp: Use bhash2 for v4-mapped-v6 non-wildcard address.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240326204251.51301-2-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_connection_sock.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -185,8 +185,15 @@ static bool __inet_bhash2_conflict(const
 				   kuid_t sk_uid, bool relax,
 				   bool reuseport_cb_ok, bool reuseport_ok)
 {
-	if (sk->sk_family == AF_INET && ipv6_only_sock(sk2))
-		return false;
+	if (ipv6_only_sock(sk2)) {
+		if (sk->sk_family == AF_INET)
+			return false;
+
+#if IS_ENABLED(CONFIG_IPV6)
+		if (ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr))
+			return false;
+#endif
+	}
 
 	return inet_bind_conflict(sk, sk2, sk_uid, relax,
 				  reuseport_cb_ok, reuseport_ok);


