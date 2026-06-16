Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF2E4502F;
	Tue, 16 Jun 2026 17:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630517; cv=none; b=X73lI9QP9O3f6xH7w9SJGmDG/DEs7IM4/GY4m1IDASt5JlaJ/qnn5RjuL6r+YpLOgWWbkTfj6URdjKBZJkY3GeR/gTLnzfw3hpOpThaParlnzvf4EPRKylfHxBbZJql/vVLuadHwtElSRP4p0vVtcXOyB2m0VaY2A2ecbdheSlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630517; c=relaxed/simple;
	bh=0stcyc9xF03CVhTQy6fb/1YfZGwo6M3OYZgY4Zd7Pvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3ktL/XXOHNSca6Ir7hw30xG4aAkf+Q7C0XPeK8A+ImygTF3i+9+XKw2HUNMcWM1EPAPzfTWAj5aItcUxah6DjpwidCKsZvd50qWUaPSzTLYJkQwKhxLiirAaLMxmWF+7tax1RxmyyJiujkjgnN5HlrfxvwH0xZMRp51PHNK/1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CIAcCvqT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CIAcCvqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111531F000E9;
	Tue, 16 Jun 2026 17:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630516;
	bh=XiQFXMw/+bn4SRgoW7Ob1MVzMOWFF7RjNRKgYOIShEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIAcCvqTNqmaBbGxbjSfhVFpCPH9mORPwbH6448UyQWx+6fvwi1JXGlKSatbXmTBG
	 nyCNrzCGXMymdeuPWiEBMIb4/9WGrXDn2Wb5tNruOR6VglaJ4fkfX5AwmuTIUIh1W9
	 AkyUys2bTEdqxl2/ifc+/31X4knL22ZvtMG8d8Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ido Schimmel <idosch@nvidia.com>,
	syzbot+9fdcc9f05a98a540b816@syzkaller.appspotmail.com,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/522] batman-adv: bla: avoid NULL-ptr deref for claim via dropped interface
Date: Tue, 16 Jun 2026 20:23:12 +0530
Message-ID: <20260616145127.870158482@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ switch to old "mesh_iface" name "soft_iface" ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bridge_loop_avoidance.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index f614709e6cda74..76d8c91c156a3b 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -356,12 +356,14 @@ static void batadv_bla_send_claim(struct batadv_priv *bat_priv, const u8 *mac,
 	       sizeof(local_claim_dest));
 	local_claim_dest.type = claimtype;
 
-	soft_iface = primary_if->soft_iface;
+	soft_iface = READ_ONCE(primary_if->soft_iface);
+	if (!soft_iface)
+		goto out;
 
 	skb = arp_create(ARPOP_REPLY, ETH_P_ARP,
 			 /* IP DST: 0.0.0.0 */
 			 zeroip,
-			 primary_if->soft_iface,
+			 soft_iface,
 			 /* IP SRC: 0.0.0.0 */
 			 zeroip,
 			 /* Ethernet DST: Broadcast */
-- 
2.53.0



