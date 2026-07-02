Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F2E343896;
	Thu,  2 Jul 2026 16:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010181; cv=none; b=Y4Vp8Bng8/f3wO3CKtZ9hAUFEwCXvGrCquSm/aC2ADxY19LHbcFF4LBpiPWE6SCvGhg4Od/LUMx86oU9x7T2bC5+7Kv/FoLq6oT/dz93Qn5spHnHEXa96sNrBzWrYfb6U2CW0ZlQk8g5Gn9jDUObVUGOb3J/waLNDr79CethvyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010181; c=relaxed/simple;
	bh=b8JQmBTQNspjDvhf2UgFmLDt9ky4NNa+eZ/K3c1Rk48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwTb4Gy8cqZ8TYsYyr5DVeBywS1osO1qEXbzcsAO7KhcWxokR7pqDXtucNsabJn1hx5XIQ3FUqbiQSPOCfYWWWtnBiaIH3HIpQf1G9svA8zElppQrD73lNisXIlAmJijA8nQ1/ohz6HYihklZHjHKjRMpA9Xk8pE6lmEt7/gciI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drOklXJd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drOklXJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8661F000E9;
	Thu,  2 Jul 2026 16:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010180;
	bh=FfyCBBgPo2uQKDI3GD9KZGDXPMMFTyllPGoQTaC8VOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=drOklXJdkmdHrjntuCEbDP6VpggyRjDihNC/Skb3V2Iv+LlfO/JM9qvb0kYDlLAmu
	 DzQlx48b2hzDScsFKG411FdbDjRZJsZMsXseJEgDVU4zz/5dTJQxWEEDv/ZUdz3zzP
	 gmIp3VFh7RDXVVCWonj1o8GM1EP6c51Op0FUWS2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/204] eventpoll: use hlist_is_singular_node() in __ep_remove()
Date: Thu,  2 Jul 2026 18:17:49 +0200
Message-ID: <20260702155118.927645307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 3d9fd0abc94d8cd430cc7cd7d37ce5e5aae2cd2b ]

Replace the open-coded "epi is the only entry in file->f_ep" check
with hlist_is_singular_node(). Same semantics, and the helper avoids
the head-cacheline access in the common false case.

Link: https://patch.msgid.link/20260423-work-epoll-uaf-v1-1-2470f9eec0f5@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: a6dc643c6931 ("eventpoll: fix ep_remove struct eventpoll / struct file UAF")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index a860cb54658a3b..8f9dc2f4891ff5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -827,7 +827,7 @@ static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
 
 	to_free = NULL;
 	head = file->f_ep;
-	if (head->first == &epi->fllink && !epi->fllink.next) {
+	if (hlist_is_singular_node(&epi->fllink, head)) {
 		/* See eventpoll_release() for details. */
 		WRITE_ONCE(file->f_ep, NULL);
 		if (!is_file_epoll(file)) {
-- 
2.53.0



