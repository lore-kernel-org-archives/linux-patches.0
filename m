Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021992;
	b=GmcEodccwUq2lsw3MEa4nCtwsA0/Lu0BgVyhHTSvS8+KNFN2pTrFdaY8BCoFiaBGK6kL
	 2K4MQ00OxftlS2ph0nVci70mJjrp9PT2Ur5/jyAJuPaKhdmBtqEYdwH17yYEBE8UJMULG
	 p710oGCCAaRfOoL6Km0vlFNn1Eau3hjuu9sxs3qtYVbq9xAuMui0zxDAW2zB6mknO8NNz
	 W7QYMYeyJNITdPmjnBR7y7/1sRNFCN1NrdYtX9LSsQCMuiaaM30Ri2qg0WalddUG58y5g
	 fNJeqEcjLsHOfTqd7pVkqWjysPVY6Pm6O4wy/y2wCLa16Vgw7tyVZAimqiFSFk04vaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qAwepq4r9T3NGHXGJcTHOxDVloE0NNsIjySur+x+POE=;
	b=43LDvw3p+Z+/Iob7t2HzVxc+8eGecTsvQqn5WHeqe/FgFPTuZC4MaoBelZFHUqYcZjjX
	 6TBpCEOSMb1dFkdCUC8DlzJ1WTykSC530YlGcokkR+rmXFwtiCUOYI3UyQaJo4mALWcuf
	 ggb5BNjD+ZpO0AFIi00g3gwP0YzYcQ41eR+xssjWVWK7+i27JISAbYzrjNA+b+TB76wR4
	 nnER2m4HL7kIIhIjBMZeG+dMzuz/QKNNfoUhXhMLpu/vP1O3/otnhI3PADOE1Il1bkxuK
	 XwtrawAcBOrSlfu5t8tMQN70PZYRbSDNx3V09nJIESK41mPqRlZJl4DrthlR2EQfcdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Jw/ekzYi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5884E606A31C;
	Wed, 18 Nov 2026 17:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jw/ekzYi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD951F000C4;
	Wed, 18 Nov 2026 17:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021992;
	bh=qAwepq4r9T3NGHXGJcTHOxDVloE0NNsIjySur+x+POE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jw/ekzYi9BRk+teXwyqf5c2eJ1KKkyoax+JfFiUf37zlJaELVToVkxTkOpQwZjdHg
	 dFdUXKmtyA7I/xSIM9Pid3W7oX35Y8HocCn5npC2hSpX2upJJ36TQVb9gIyzBbslR3
	 jcmyokz47hCmx2nTYZ+tIvvuTGXL92uUR7G4HbdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guikun Yang <yangguikun19@qq.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2505/2651] devlink: region: fix snapshot id leak on kernel-allocated ids
Date: Wed, 18 Nov 2026 16:02:25 +0100
Message-ID: <20261118150414.959292266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 537779bbff07a..c22016f23a4a4 100644
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



