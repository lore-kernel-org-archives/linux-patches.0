Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1603415C158;
	Sun,  7 Sep 2025 20:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277064; cv=none; b=L+djQ/cajN3+RHMk4kS53MBaB0jyD78k2A2GDgnoGoJ78Yw46R33rlTM+Pz3hzkLvY0E5BnKFFLDH1QgHQNaKDuL9WNleoeVX0lyFeWi5jUSmpND+CrLjunXN+0I9kdYvTtbybYyod7vjZ5xsnzm2HFu3/TeMEL0VnoNSzts+PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277064; c=relaxed/simple;
	bh=ISREC13juLf+6eAlWFS13NTo5CbNxoJ9yfbvm9cXHfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4SBt9ZLQ9yMwbMhAN9atFvTvKjilrkjpt4/RHn9H6CUCtmiM+fJWBn/exqvmgwR1I6VYmuyRgG4jk1AwD2QnDFvKowSdLdLGFTMpiiidQfVbOH/5TzyDU6DRO9W3O8X59GSPEb5KeTI0hVvADFESxVS56/5PwnppYdkTVWqdfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mldMCz74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mldMCz74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913FBC4CEF8;
	Sun,  7 Sep 2025 20:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277064;
	bh=ISREC13juLf+6eAlWFS13NTo5CbNxoJ9yfbvm9cXHfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mldMCz74UwSO3V9wXheVIhT25qyEabjLEZN5vbUtTwdaYjQttd6W7/+J5rTS0X+GG
	 fweZYIcCr5iigWHoApKJad8BIyRtdaBgLDjQSUQZKWHQYWFsC7svScZBYL9DbH/Jfm
	 8uFwFE533wQO6E7qvYm/INdUgQd/6eRLj7SaTBSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/175] vxlan: Refresh FDB updated time upon NTF_USE
Date: Sun,  7 Sep 2025 21:57:47 +0200
Message-ID: <20250907195616.538294750@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 40a9994f2fbddf299655073be947e9cfc57dfdf1 ]

The 'NTF_USE' flag can be used by user space to refresh FDB entries so
that they will not age out. Currently, the VXLAN driver implements it by
refreshing the 'used' field in the FDB entry as this is the field
according to which FDB entries are aged out.

Subsequent patches will switch the VXLAN driver to age out entries based
on the 'updated' field. Prepare for this change by refreshing the
'updated' field upon 'NTF_USE'. This is consistent with the bridge
driver's FDB:

 # ip link add name br1 up type bridge
 # ip link add name swp1 master br1 up type dummy
 # bridge fdb add 00:11:22:33:44:55 dev swp1 master dynamic vlan 1
 # sleep 10
 # bridge fdb replace 00:11:22:33:44:55 dev swp1 master dynamic vlan 1
 # bridge -s -j fdb get 00:11:22:33:44:55 br br1 vlan 1 | jq '.[]["updated"]'
 10
 # sleep 10
 # bridge fdb replace 00:11:22:33:44:55 dev swp1 master use dynamic vlan 1
 # bridge -s -j fdb get 00:11:22:33:44:55 br br1 vlan 1 | jq '.[]["updated"]'
 0

Before:

 # ip link add name vx1 up type vxlan id 10010 dstport 4789
 # bridge fdb add 00:11:22:33:44:55 dev vx1 self dynamic dst 198.51.100.1
 # sleep 10
 # bridge fdb replace 00:11:22:33:44:55 dev vx1 self dynamic dst 198.51.100.1
 # bridge -s -j -p fdb get 00:11:22:33:44:55 br vx1 self | jq '.[]["updated"]'
 10
 # sleep 10
 # bridge fdb replace 00:11:22:33:44:55 dev vx1 self use dynamic dst 198.51.100.1
 # bridge -s -j -p fdb get 00:11:22:33:44:55 br vx1 self | jq '.[]["updated"]'
 20

After:

 # ip link add name vx1 up type vxlan id 10010 dstport 4789
 # bridge fdb add 00:11:22:33:44:55 dev vx1 self dynamic dst 198.51.100.1
 # sleep 10
 # bridge fdb replace 00:11:22:33:44:55 dev vx1 self dynamic dst 198.51.100.1
 # bridge -s -j -p fdb get 00:11:22:33:44:55 br vx1 self | jq '.[]["updated"]'
 10
 # sleep 10
 # bridge fdb replace 00:11:22:33:44:55 dev vx1 self use dynamic dst 198.51.100.1
 # bridge -s -j -p fdb get 00:11:22:33:44:55 br vx1 self | jq '.[]["updated"]'
 0

Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250204145549.1216254-5-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1f5d2fd1ca04 ("vxlan: Fix NPD in {arp,neigh}_reduce() when using nexthop objects")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index ce9dcd8e74a93..ce9c979080bb4 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1047,8 +1047,10 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 		notify |= rc;
 	}
 
-	if (ndm_flags & NTF_USE)
+	if (ndm_flags & NTF_USE) {
 		WRITE_ONCE(f->used, jiffies);
+		WRITE_ONCE(f->updated, jiffies);
+	}
 
 	if (notify) {
 		if (rd == NULL)
-- 
2.50.1



