Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042629;
	b=RJYAeVSSY7+vPR2HfnLczHx0+m0qCsSw2cpFa05XeJpjWkauJKr6d0k8hFDp2q/xwtLf
	 fNqpBDKjOomCAMa4IGLq+H98pE1wln+h9GllCmFwgJftYlFNB3jMTGLeCw4i1bfg7QkDO
	 hIIoPEUy7pTbJCPBmVazw3LjGv21NOvU4XF4nOB1I5DoqJVmfy+6xXnYf+zrLVw3enhyj
	 vIAuILTjVgkF/7JK8sSeJM9mJs7EgZlEdkrHXJKQQnobM6vNnUiDsESq1yhTt3gpaNhd7
	 sCHE+EvcTlDPhBWmPXgcAtvjLo7FToL41VmoQ5jL8+yAvn/I8+8/zQcWTmspS5RTqrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v/6ytGKr9Td0RvMWo+aC+CIC8VNRBjehvq6YPCv70Ls=;
	b=QPVpzpeb+ReFLV9Tbj/g3v45HCUa3bhI1J1Yt5aGsChZAxbUtEJE9RomTB0Y8jmN8l0w
	 m3sptHzsziYY/tDjl2wpQQVq/tp5iBSSr61LyQ7JIptXl7o6REE47TvYfd0BusBPDex5L
	 heA4iSojqv7Z89wD+hliVxzQKSEept8n8eNYEsiHLWSJhRv47T5LWWYE4ELuLEnNC59+w
	 unFH+5WIGC9bjYAH0H/XZJsADQWTCW3mJMGeClwTerAb0Wx+DlZeK+kx65QfpYdd1sQ/I
	 SLn1wUxH6X4X3JAi0Q76obTHdz+9+a547CCUavm/wsA4Tu9OAU3kvFM745ZTIzNL4zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L0ne/NDT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51FE606A325;
	Wed, 18 Nov 2026 22:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L0ne/NDT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280FB1F000C4;
	Wed, 18 Nov 2026 22:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042629;
	bh=v/6ytGKr9Td0RvMWo+aC+CIC8VNRBjehvq6YPCv70Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0ne/NDTSdpMVKwe0LCVl+WFpA78Y2pl+kwwTGbIrysQ4pkd7xvuNKLwszHk+oqFt
	 y/EhzTjImzDoFjWnNdf6ffoMH0U/m4SCYo/Y3pTyXS22XUCbP2e6ihLTxRMYWBmVL4
	 mTQQcaJO8fe9nY6Zzs7mvUpT5+rnkoNS8HJ09byM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guikun Yang <yangguikun19@qq.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3202/3318] devlink: region: fix snapshot id leak on kernel-allocated ids
Date: Wed, 18 Nov 2026 16:03:44 +0100
Message-ID: <20261118150455.816775806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d197cdb662dbd..40d2f738d35cb 100644
--- a/net/devlink/region.c
+++ b/net/devlink/region.c
@@ -721,6 +721,11 @@ int devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
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



