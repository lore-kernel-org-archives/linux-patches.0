Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80FA2E041E;
	Tue, 15 Jul 2025 13:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585811; cv=none; b=ZzZSns/dlifGD4efnToNsNHfLaHD1hdZrHArI/JTePf+D4gqSX0h2Kv7cQEXKW41WcP56OlWcuZsFLdMigrHGUPD4ZlL/rCDh/yebyDS7hFsHaGU4SJW49kEIBWYp/H2nzCzxVk8qwm703N88HvgIVv1E7Bq2EEzphHpz39N60c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585811; c=relaxed/simple;
	bh=vQf3riLDBKjyaGTPaAet7OWwUKfrIF3/wXhlwHoSqRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isJQtjR+50b5einh1aSq5erpKt6cyMvlPR77AhtaVrsE1gtkKquI0l4yRyse3cqDCbrQcRfGiqldf3hQv/86UOvvgNX3ZSyaVRs/n//c5VFwM5hil/lAM+qZEYmNb6LbdgK8LbTA4uJKkK8uz7QQl/vvngLBRpH7hLu4gaf2p5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BANZFi8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BANZFi8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7AAC4CEE3;
	Tue, 15 Jul 2025 13:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585811;
	bh=vQf3riLDBKjyaGTPaAet7OWwUKfrIF3/wXhlwHoSqRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BANZFi8hd19vKrmaf5ZCTqzQmxhbc4+uhatQ+a6VHGcTgeTH/YSYU2omvAP2vLiPA
	 TR0n0/fbeuRLgfRpJDBGtEVlzwtD2FK/XUAuj+3WWDtBL9HejgvvCPyrg4+J5ZFzRN
	 +nGdq9y3Wm4IBDqIl8Xo3rjg7oS5OCys7dGD2dEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/109] vsock: Fix IOCTL_VM_SOCKETS_GET_LOCAL_CID to check also `transport_local`
Date: Tue, 15 Jul 2025 15:12:33 +0200
Message-ID: <20250715130759.569934062@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 1e7d9df379a04ccd0c2f82f39fbb69d482e864cc ]

Support returning VMADDR_CID_LOCAL in case no other vsock transport is
available.

Fixes: 0e12190578d0 ("vsock: add local transport support in the vsock core")
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Link: https://patch.msgid.link/20250703-vsock-transports-toctou-v4-3-98f0eb530747@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 58b7404a0da05..f20b117e5255e 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2436,6 +2436,8 @@ static long vsock_dev_do_ioctl(struct file *filp,
 		cid = vsock_registered_transport_cid(&transport_g2h);
 		if (cid == VMADDR_CID_ANY)
 			cid = vsock_registered_transport_cid(&transport_h2g);
+		if (cid == VMADDR_CID_ANY)
+			cid = vsock_registered_transport_cid(&transport_local);
 
 		if (put_user(cid, p) != 0)
 			retval = -EFAULT;
-- 
2.39.5



