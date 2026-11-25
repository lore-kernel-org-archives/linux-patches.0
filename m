Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624852;
	b=ssIgg2RLz6YeTEUzwph1atsqS9f3Wijpff2cw5PJbj47KyC4KFt/APkIlREqEeaHpu02
	 0qfseCmbrS6xNoXQSarLOdNHx4GlLLXZGPqIP74VV6NO7YfgkUXC+zlurphtGI9tLhit1
	 +CQoTFMgAgifbXYMBMFAbU0OrAD2CA0IC/L54/mMtjwIeEM4FdumExDupTaWgE4pq3FVy
	 n7ZT0VM/fE3zb4Q7OrhqRlNNndkaPVfnQB+n48YhMUVdy+VdrMUtaBAVsJNfN4jlLnu9S
	 IFeCdF8bP8WIzmJPhPd3TgOwL3fM1a6T1ypaI5OIbfQ/7gKEdjqGJS971bIaGejSN8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T5qRXSwB7j0NO1WYqmAa+BnxrGKh78T6lhESjVAzXpg=;
	b=d44MXsr6sUWv2H7vHiCYxl1vsiLbKxDtjNXAGp/k7VJdtPsDH4fKxFJap1PpsJpRP7uJ
	 zxaviBc0gND6lO6s3BnAzX5Vg/QrwRRZA9ArZ6aQEr9YEGxuWk4MMUaoAvbhJ530JZqGm
	 JM3JG1W05TPS07ghapzyyNHp/nuyWij7qC4gZhSD75NMtiok2txoh9O94THi45MxO/I5L
	 2cb39Ppj9X18iO3S/XFbwObwZkD5hE90z3KgOimcQFgDCRFTPzkCXjCvBxjpYlmkYKzh2
	 Zy0Ybcx58E3iCTH+7aD/U6kwuQNTq4UlmapV/xyTn2/nFW92Gwx0eBRHzAyS4EcnCag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tIWvm1vs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213FC606A31E;
	Wed, 25 Nov 2026 16:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tIWvm1vs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137771F000CF;
	Wed, 25 Nov 2026 16:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624851;
	bh=T5qRXSwB7j0NO1WYqmAa+BnxrGKh78T6lhESjVAzXpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIWvm1vsszu+0fZOnakHbJktFXpN5XNHkrEDzQiQeCHRiupUY54Ct8/Lc2M6HowJL
	 744TckzbjmvadaLUG8sKLOHSH98XX8+CEfdhPJFRpTFxRURrB0psSOmOcP7c5Dwhgj
	 1ozAWjPK0LcpnZ5JgzJtbwJzepN+2eKfEJn9vLwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 320/816] ovl: allow idmapping overlay mounts
Date: Wed, 25 Nov 2026 15:31:08 +0100
Message-ID: <20261125143856.607580328@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit adedb6a00a1e4c77b1de9ea1f63b5008ad0c21f5 ]

Now that every overlay inode operation honors the overlay mount idmap,
allow the merged overlay mount itself to be idmapped by setting
FS_ALLOW_IDMAP on ovl_fs_type.  mount_setattr(MOUNT_ATTR_IDMAP) can
then apply an idmapping to an overlay mount, exposing the merged tree
under a different ownership view.

The composition is clean because overlayfs already normalizes every
underlying id through the relevant layer idmap when it copies
attributes into the overlay inode (ovl_copyattr()); the overlay inode's
i_{u,g}id are thus "overlay-final" ids.  The overlay mount idmap
composes on top of that pivot: it is applied to (getattr) and removed
from (setattr, create) those ids at the overlay-inode boundary -
permission, getattr, setattr, ACL owner checks and inode_init_owner() -
while the underlying layers keep being accessed with the mounter's
credentials through their own, possibly idmapped, mounts.  The mount
idmap therefore only changes how the caller sees the overlay inode and
never widens the mounter's access to the layers.

This is deliberately the final code patch of the series: only once
every operation honors the mount idmap is it safe to make overlay
mounts idmappable.

Link: https://patch.msgid.link/20260615-work-idmapped-overlayfs-v1-6-7381632aa402@kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: cb6c084182d4 ("ovl: release the upperdir/workdir in-use locks before the umount sync")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b0cf671b4200d..6a9db5b742598 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1491,7 +1491,7 @@ struct file_system_type ovl_fs_type = {
 	.name			= "overlay",
 	.init_fs_context	= ovl_init_fs_context,
 	.parameters		= ovl_parameter_spec,
-	.fs_flags		= FS_USERNS_MOUNT,
+	.fs_flags		= FS_USERNS_MOUNT | FS_ALLOW_IDMAP,
 	.kill_sb		= kill_anon_super,
 };
 MODULE_ALIAS_FS("overlay");
-- 
2.53.0



