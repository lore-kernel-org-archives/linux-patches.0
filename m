Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033006;
	b=hKVNiZmWAlwLtZiSGraCrAXrDvWEVTXJiUgDG1NexFyGBuaCZm4LVz0nghihFQ2TKkXt
	 pHdKz3++OrH7ELYlu3s+bWlBVlYMgsw39YNx2h9j+a+V1ZuhlWKokFSMR2JUT/yQVhgEO
	 sF3qSY+wQrIctuoSkJTcpJhOMPjz18uiHpUvwQg6Naz2t9Sdi7lR7ieEmzXUVuqSCHQDf
	 1kmKng+CTEl2pf7N8SnHGkP8ycKYPb4HTJMNm/rOr3zbz6srz76ib4eFqgaTFW8ZAHUU/
	 uyJNc0o0QiEEuwSZPGC4yRIP387IQ//WbsapdFQl0fQv8qRlIRaqUHZx1p5uQQGrnLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hQjLyMNKVI5N1qWBlJW3V24k32T4wyR8yVmiQ6F+Y0s=;
	b=Gxhp84UtQt7Rr6zxZi6Ml3Al1m9moYQ+qHST7+gwpJYbxPitDNF24kdlq3oDDm7MBrxP
	 N6Ie2o9Omf3HgxV6iT49B7HtrI8upKE9rLyyInDJrfiK7InwhE7YOvJJmT+E5F+b5uobx
	 nLijTmLqGdmhPxvUx2BvwrE+LFSFztpr8O4cKsEgq5SEY6Ris3ZuQgprtSIunO9Bk/A7C
	 2vr8tMK2a/aATiZDwYPTPsceXk94Z9ueW7TqEYpSkyOsjSjw9B8gHMku8C+cbsS2zBo7o
	 VmMle/v1m5rqN4A3fgJa+BqgrZyeFCbm0JCm/4JGzuIUeU2PRNoaOhiZ6lDb59CtuBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NV9mjaBQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F09F606A32C;
	Wed, 18 Nov 2026 20:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NV9mjaBQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865491F000C4;
	Wed, 18 Nov 2026 20:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033006;
	bh=hQjLyMNKVI5N1qWBlJW3V24k32T4wyR8yVmiQ6F+Y0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NV9mjaBQ8qeKGGkAVko6ZlZfhps5Za7MZASbI8NEPCkyPeCCNQ4bP06TBZqIImJ14
	 HzpCXfW8mWaj1+hy6oi0rqzxIRTRz5JKIShbh7wRy6yXbFqIQrFtCmUM7+wHrUuhN6
	 jgm8neP2PlE6Oq1E/A3y/EzpBmzdC2sMAzxtybKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guikun Yang <yangguikun19@qq.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1615/1756] devlink: region: fix snapshot id leak on kernel-allocated ids
Date: Wed, 18 Nov 2026 16:02:22 +0100
Message-ID: <20261118150114.138954481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit ef8f0a1d888e0280452792f6d4edad237c934a51 ]

When DEVLINK_CMD_REGION_NEW is issued without a snapshot id, the kernel
allocates one with __devlink_region_snapshot_id_get(). That helper counts
the caller as a user of the id, and the caller must release this hold
once it is done.

devlink_nl_region_new_doit() never drops it. The refcount of the id goes
1 (allocation) -> 2 (snapshot created) and stays at 2. When the snapshot
is deleted the count only drops to 1, so the id is never erased from
the snapshot_ids xarray. The id then stays in use for the lifetime of
the devlink instance: requesting a snapshot with that explicit id fails
with -EEXIST, and there is no snapshot left to delete to clean it up.

Reproducer steps:
  # devlink region new pci/0000:13:00.0/device-caps
  pci/0000:13:00.0/device-caps: snapshot 0
  # devlink region del pci/0000:13:00.0/device-caps snapshot 0
  # devlink region new pci/0000:13:00.0/device-caps snapshot 0
  kernel answers: File exists

Drop the caller's reference right after the snapshot has been created,
as the snapshot then holds its own.

Fixes: 043b3e22768d ("devlink: let kernel allocate region snapshot id")
Reported-by: Guikun Yang <yangguikun19@qq.com>
Closes: https://lore.kernel.org/netdev/tencent_BE912BA710539F285F9FCF28E854ABEFCD07@qq.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20261026174403.512-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/region.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/devlink/region.c b/net/devlink/region.c
index 7319127c5913f..2bd000d878367 100644
--- a/net/devlink/region.c
+++ b/net/devlink/region.c
@@ -721,6 +721,11 @@ int devlink_nl_region_new_doit(struct sk_buff *skb, struct genl_info *info)
 	if (!snapshot_id_attr) {
 		struct sk_buff *msg;
 
+		/* Drop the allocation reference, the snapshot
+		 * now holds its own.
+		 */
+		__devlink_snapshot_id_decrement(devlink, snapshot_id);
+
 		snapshot = devlink_region_snapshot_get_by_id(region,
 							     snapshot_id);
 		if (WARN_ON(!snapshot)) {
-- 
2.53.0



