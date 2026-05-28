Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991B830C15B;
	Thu, 28 May 2026 20:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999673; cv=none; b=WvBqjLQXl1FZGeISvpOp8DdUKqtS6qDY7DOR4PttIhkIgaFtyW1mNgOHoP10E0imWuWTJszuprsEYgqFnd+jhhXtX6Qipdv21kevgDrqk3NeNl7VbmkYW+K5rHZdW+hi0z1D6NO3jz3UfkHd9x48P+6HQ3By6ZLAHnn7zV8j+u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999673; c=relaxed/simple;
	bh=pNyN02h6iIBV+H/WQ6wHeOzQoq2wMj6xbl0i2bYfd4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijZHze8eaxEV3HOPDkXefMNNbW8ZsNqNWJSv+XnFzb0u/OmQlADyrSDrn4TTovorQVowAGKGVcdCiMmPRflu6pQkN2P3gRviYh95+2vx3llfej+3qtfLIhS7SL3VhVZG7ymMhJdBwV3HS5yh80EpjLyFMZrwmd5UdoTknNtOyMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqxZRKc8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqxZRKc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1E31F000E9;
	Thu, 28 May 2026 20:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999672;
	bh=Wd8aurS/i6RcXXkOIZPkXfBBQxY5Jc5NrNXSPDvlRSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tqxZRKc8tcXgylcWk58Ha0Z5beZ1uFixVo5Qiu0Fan4YyxNWJp0DM9vuktwlAD8du
	 pjCfAjw5fkqaN2dNIQLNX2noq97nLVIoRK0pBnmxN2stBvLc2eC19gAVK6OL2poMYA
	 A0DF+8RqL8+HtijTblo6qxrcxGt8yiWUGJjBzYog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ido Schimmel <idosch@nvidia.com>,
	syzbot+9fdcc9f05a98a540b816@syzkaller.appspotmail.com,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 149/377] batman-adv: bla: avoid NULL-ptr deref for claim via dropped interface
Date: Thu, 28 May 2026 21:46:27 +0200
Message-ID: <20260528194642.699065010@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit f80d3d98d2ff78d9e2fe5d68b1f45948c4f7bd24 upstream.

Without rtnl_lock held, a hardif might be retrieved as primary interface of
a meshif, but then (while operating on this interface) getting decoupled
from the mesh interface. In this case, the meshif still exists but the
pointer from the primary hardif to the meshif is set to NULL.

The mesh_iface must be checked first to be non-NULL before continuing to
send an ARP request using meshif.

Cc: stable@kernel.org
Fixes: 23721387c409 ("batman-adv: add basic bridge loop avoidance code")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Reported-by: syzbot+9fdcc9f05a98a540b816@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9fdcc9f05a98a540b816
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -357,12 +357,14 @@ static void batadv_bla_send_claim(struct
 	       sizeof(local_claim_dest));
 	local_claim_dest.type = claimtype;
 
-	mesh_iface = primary_if->mesh_iface;
+	mesh_iface = READ_ONCE(primary_if->mesh_iface);
+	if (!mesh_iface)
+		goto out;
 
 	skb = arp_create(ARPOP_REPLY, ETH_P_ARP,
 			 /* IP DST: 0.0.0.0 */
 			 zeroip,
-			 primary_if->mesh_iface,
+			 mesh_iface,
 			 /* IP SRC: 0.0.0.0 */
 			 zeroip,
 			 /* Ethernet DST: Broadcast */


