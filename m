Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D1715E5BB;
	Sat, 30 May 2026 18:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166990; cv=none; b=NzxV2ZXgHUM8mxhpRTYcXuPFhnS//08UPZ8yfJLBwMSlMPSvefI8ww4/t0MdS5MlBMOCz/PwgPG4f29Bbjn1RDH7eG8OesJdT3owsRC+4w6w8PbLpO/XocXGyvzbWzISPmOuIh24I/JcHXP9MJ4gbIYZjf5iuOvsV9XZ5MFPQOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166990; c=relaxed/simple;
	bh=NPTwiQubVp5dtDEelyiVy2+pfrCt2G+qtFe3u8iAIV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5xAvKSGJInOpLTjOXlo+7eo45sQxypoIwl7cLZi+/YLsjmOqFb1GGDZkhZO2mtploDnGxkiXjDMrORyIZ1x2NCFvom7GpeCXeZM7J2t15NGe/sPOQvagdncW88iN6dHBx+w2c0qHcUcOgnNOvkXmhriiH2898CV2O4W1ziruyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ordAVN8w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ordAVN8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653A91F00893;
	Sat, 30 May 2026 18:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166989;
	bh=d6w1KNO4AEQcQ4jJUx4YT5Cv3dmt2XWtuAlYgJmoukE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ordAVN8wATN/NyrOKmCJYj4ci/GkghfouiuF+rR7JWJ1WSBioa0IB6YEZognY0Uit
	 TU05fmuQ7PXLPjpHgG+YfGh41ALOWnVPscsxIUv9kdR7UTzqA3WP8Wl7c/W6zYOsDM
	 NhpBeiSi0UN9Kki5HRz7zN1EDk9jP8RdSs1i1l1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 531/589] Bluetooth: bnep: Fix UAF read of dev->name
Date: Sat, 30 May 2026 18:06:52 +0200
Message-ID: <20260530160238.662247811@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 59e932ded949fa6f0340bf7c6d7818f962fa4fd2 upstream.

bnep_add_connection() needs to keep holding the bnep_session_sem while
reading dev->name (just like bnep_get_connlist() does); otherwise the
bnep_session() thread can concurrently free the net_device, which can for
example be triggered by a concurrent bnep_del_connection().

(This UAF is fairly uninteresting from a security perspective;
calling bnep_add_connection() requires passing a capable(CAP_NET_ADMIN)
check. It also requires completely tearing down a netdev during a fairly
tight race window.)

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/bnep/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -638,8 +638,8 @@ int bnep_add_connection(struct bnep_conn
 		goto failed;
 	}
 
-	up_write(&bnep_session_sem);
 	strcpy(req->device, dev->name);
+	up_write(&bnep_session_sem);
 	return 0;
 
 failed:


