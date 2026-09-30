Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B983F509EF3;
	Wed, 30 Sep 2026 18:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793377; cv=none; b=lyBdmywiX6r3sGzAUTW3i0cuua1S7qRpXpHcQbQPJH+BP9X4BC7fY1123z44MRT8x1OZfKBWCYWBggnvr0CDXYi6T2pEYvw82oaU5sYIEBhThvrWdNOLbB1tK2U6PIESsjo0EFWnG3Lk2bgvCfxjjMbMcbh/pRS3i/dDn/t2HXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793377; c=relaxed/simple;
	bh=WJcgKoRbnQPb/ItxbUFV0hho6EaccN7+9XR3e6PsloQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYEB2DCbx/C4+YphOm3UJvxyP+92ng+IHiL9CAdsIwYKqtdCjsZluCY3sJnkLkw3LHIHC+mjFZl7IEeZMtvOUX3Uxwy8XVf3g5n60IP5BRaKwvfYQnAMrlKJJX21oWyiSS9pGg6dm2AQ+mBoLtBwNz5ClYHQgNcb5r9qhLLLntg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnMNGfR4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnMNGfR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206371F000FF;
	Wed, 30 Sep 2026 18:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793375;
	bh=U3HcqrPdAoOWuZlMkfKPyaLeGoC2wSlMx5Dy7kVc8Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnMNGfR4WHKAlmU+MOhJVkDQJ/isAeqWRvGH+mRH/ymxwMvZmYKYmoMozHZSo/BFI
	 Mqoq66K9BzbSBeF5QO77EVPdOwRlVbMranm7vrAfSRT8Bsj14WfIat9V2c/44fC8Jk
	 in33W9vb+qIvwdAdbtge40/0gSvj7LUldXp8CXTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Hui Peng <benquike@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 234/395] mctp: route: iterate socket tag list in mctp_lookup_prealloc_tag()
Date: Wed, 30 Sep 2026 17:28:16 +0200
Message-ID: <20260930152345.736652415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

commit 26cc0e69cce062cd3aa6fae33074684669c35a71 upstream.

When a socket transmits a packet with MCTP_TAG_PREALLOC set,
mctp_lookup_prealloc_tag() iterates over the per-netns &mns->keys list
and matches netid, req_tag, peer_addr, and manual_alloc, without
checking whether tmp->sk == &msk->sk. This allows any MCTP socket in the
same network namespace to use and consume another socket's preallocated
tag.

Iterate the socket's own tag list (&msk->keys via sklist) instead of the
namespace-wide &mns->keys list in mctp_lookup_prealloc_tag(), ensuring
that only tags allocated by msk are matched.

Tested in QEMU against Linux 7.3.0-rc3 by allocating a manual tag
(0x18) on socket A via SIOCMCTPALLOCTAG for peer EID 9 and sending a
4-byte message with MCTP_TAG_PREALLOC from socket B in the same network
namespace. On the unfixed kernel, sendto(sock_b) using socket A's
preallocated tag succeeds (ret = 4); with this patch applied,
sendto(sock_b) fails with -ENOENT (errno = 2) while sendto(sock_a)
succeeds (ret = 4).

Fixes: 63ed1aab3d40 ("mctp: Add SIOCMCTP{ALLOC,DROP}TAG ioctls for tag control")
Suggested-by: Jeremy Kerr <jk@codeconstruct.com.au>
Cc: stable@vger.kernel.org
Signed-off-by: Hui Peng <benquike@gmail.com>
Link: https://patch.msgid.link/20260921051002.1656692-1-benquike@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mctp/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -825,7 +825,7 @@ static struct mctp_sk_key *mctp_lookup_p
 
 	spin_lock_irqsave(&mns->keys_lock, flags);
 
-	hlist_for_each_entry(tmp, &mns->keys, hlist) {
+	hlist_for_each_entry(tmp, &msk->keys, sklist) {
 		if (tmp->net != netid)
 			continue;
 


