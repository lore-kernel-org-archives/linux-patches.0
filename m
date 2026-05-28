Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB5E26B973;
	Thu, 28 May 2026 19:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998384; cv=none; b=VOUCShGHqF6TBmZSY7TQT+ifg3GI0umeU0lM7M7e/oHZHgX4iOZ1hCU6gNCIw4S72jTmYXjUEhiVGQFFLLVGiUI7uCzM2VYVYO8gd3un46GWU86nhllf0H7PZ91LCwV8W4/Ithk00VKJjKfor4Mk9Lg+/6/3k3kkZEYqAO51Nqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998384; c=relaxed/simple;
	bh=eAEGnfgWpfYSJC+jB/Gh8Uyl8aWhI2yXkrWiqeXZ2Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQoF6mjboBzwcRobnu56jH4i04MX/jfd6sBV1QgJKGBp20jXLg4zXwa/4ho2R+tl+ziHZKHNuAAiBCGQHGKgVlpVea2n+5NXqF+LD24s0Jq2PrZZC6VO2mvT/sT1TsRaqQZ7iPb6hienM9A4hfTKv1Ua0sT3f6IUSugOxkQ+o1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apFqFqRU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apFqFqRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA821F000E9;
	Thu, 28 May 2026 19:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998383;
	bh=tdTJHfK6BInjm38k8OKj11cEfQWfivB2f+p8mxzGUFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=apFqFqRU92n9adiMU1t+o2aDJGse6ifaIu7VxTu1WRbDo9H80YIFXNPCR0ZRiKMfL
	 og27brlg6aroG0jH01UPJicuVuwluVIZH0u5MxGSN8NVc//QaWqbx56NdKNTwKyr67
	 zHBpIL0BEQns9v5ewGegoiEuKYn+tqNffRs9xjfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ido Schimmel <idosch@nvidia.com>,
	syzbot+9fdcc9f05a98a540b816@syzkaller.appspotmail.com,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.0 153/461] batman-adv: bla: avoid NULL-ptr deref for claim via dropped interface
Date: Thu, 28 May 2026 21:44:42 +0200
Message-ID: <20260528194651.468030098@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -356,12 +356,14 @@ static void batadv_bla_send_claim(struct
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


