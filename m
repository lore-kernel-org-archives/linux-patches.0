Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D825187DA;
	Wed, 30 Sep 2026 17:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788463; cv=none; b=GpB3RG/H7W86R6w1eTFk47PkCrUSkUSOcFXrMgGqb9phuI74n3jFotj+IEshy9dTFfKLWsbktNIY7rdcipYQGnieHI0AikqIOLT8rOGKU4QajC+vX7rMOhG7M3UeEU2i30ysuOX074EBW7dKg8djJLpqqMm5YMfISZA9sm6Cc7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788463; c=relaxed/simple;
	bh=B4jVOWBuiUHhAf1BydQ14Wkkjn2BN6OwOvy4st1z+fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAztB424M8poDmTqm5bl8kwgiKA5pMm0sIn4sf2T+S4tivTUnFP5sutvazhTuKMPUUkx6tvfM5PVjIrwPsBe9xYWHNgdVDjZfsY2pIT++fNJLLD0Bn6RqJ54RuycgW63i/xaEqCHtJFDlVx5xt0LHDLsvxJgshrubAPHn+PGX0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJ/P/Wz0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJ/P/Wz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375311F000FF;
	Wed, 30 Sep 2026 17:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788461;
	bh=0REmHYu4tp4hZb03YrPp5XFtV0BnavN7Do6pm/gmKug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJ/P/Wz0Tbq8oXm2mGE0OzyOtzqfqy0jvmTS0Zq0S0H2GE1R7SGu1c/vtkj6jTwNz
	 yEQ2tOh3FCrsobu8yLeb8ErFps+zjayHSV9Jv9C8Dxu5ww5LNlbFEQoe/64jNMMD1F
	 J6vHT5uk37AucljDhemx4gQ5MYSIIqmcK/+pLhDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/877] Bluetooth: ISO: Fix parent socket leak in iso_conn_ready()
Date: Wed, 30 Sep 2026 17:17:24 +0200
Message-ID: <20260930152417.602397389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit ca18ee413a7cb6f09885778039225e58bae0d607 ]

iso_get_sock() returns the parent socket with a reference held, which is
dropped by sock_put() once the child socket has been set up. The error
path taken when iso_sock_alloc() fails only calls release_sock() and
returns, leaking the reference and thus the parent socket itself.

Drop the reference on that path as well.

Fixes: fa224d0c094a ("Bluetooth: ISO: Reassociate a socket with an active BIS")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 6e1fac4b1cf63..8cdfe3b6e1235 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2013,6 +2013,7 @@ static void iso_conn_ready(struct iso_conn *conn)
 				    BTPROTO_ISO, GFP_ATOMIC, 0);
 		if (!sk) {
 			release_sock(parent);
+			sock_put(parent);
 			return;
 		}
 
-- 
2.53.0



