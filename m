Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028056;
	b=0W7+1iadXjfIcrMV+2F83xdxxOIQLSvZt6xHH14UW4pVeNaZU72jUVRaxMRhbKFwDi3y
	 SEBRaNK/Y+2dyRNwOVilX27MqxatebZ24C48/BK3iu6e71U3lPmRjZh5D8u7MiioNuMw1
	 0jt9tonPZ63E2ACKe7sv/UK+Tl9zaumsGp30xKa8SOgrhfhKe9cIq5ZnJ0Jn3GJEgRKq/
	 d0aoYbqfY879zTrNQ1XBn9ckhdNriuxsgJI3qntLQauiiVMnEELF8uHBg7RbCTe3xMwfS
	 iWdqYObkvUJ0+jz4o5gWcYOet+OdUaByiCg719348atkn9vmJ+TO0e3dq7cdyMAsOsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GZJLb88L8sT4Ybh1OdUA6XONHrNT5dEdr8BMZRl5/kQ=;
	b=M/peBLulpY+bWAHppIC+8ODGEIcfPOQufJy3As7+7GhN6Bfrv0FoOZ+i6fcEkorrVlIO
	 o4pMTKhVSwHZtMUyxf7rv2caBXk8tSOPohhwb5wn9dzjUAmPRSHZIPm4sMtbTFnzVXYcj
	 sA9cJKA3D19kA5/3/povp0C231F0WggbIAjxZInm+cQQC1Sw0f8OO+8e4/uxBpyhMxrLu
	 oiQDJ8VWH5OLVPZFs+1uE4+oWGpxTgpEOxuKfQhr6nFLAbwpZXsHNyhjVMJZbMdkD6ZmM
	 G+iqD21kY2M3AvtpjhnS+b8Hkka7v0EYKYx9XmvlI+AXMWpFnvhWumrv1mCX5aumefA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kUjvyzOB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BCD606A31C;
	Wed, 18 Nov 2026 18:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kUjvyzOB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036431F000C5;
	Wed, 18 Nov 2026 18:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028056;
	bh=GZJLb88L8sT4Ybh1OdUA6XONHrNT5dEdr8BMZRl5/kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kUjvyzOBI3PHfY7wlQ1apXum2G4boF6yyS5Y78nXNyBrxGO5lKuGn/R7WgPHXm65w
	 Vu5Z2lvGDHRzbG6Nj5N+svJAkWfpjwXunqkam5b1f+mnypeyw8rsXGHM8u9CCsDjS9
	 45RYFzsnYau3GBeJdqoGh16jAjPb34rxckIV9MEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guikun Yang <yangguikun19@qq.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2010/2151] devlink: region: fix snapshot id leak on kernel-allocated ids
Date: Wed, 18 Nov 2026 16:02:25 +0100
Message-ID: <20261118150234.946126328@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 63fb297f6d678..1b1dc31106719 100644
--- a/net/devlink/region.c
+++ b/net/devlink/region.c
@@ -719,6 +719,11 @@ int devlink_nl_region_new_doit(struct sk_buff *skb, struct genl_info *info)
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



