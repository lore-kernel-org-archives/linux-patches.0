Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B2144B66E;
	Tue, 16 Jun 2026 15:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625121; cv=none; b=mnR97wjMjkFb1J9+GHb6qSyA3ah0mSfkC+eeH6CbTpTBTPU/1pE1cIsLd9il70kLEcbW21seSRhZQ4sv01lEXluVklo2n68sj9nvZI1DORZB7h3bWexvvjtvcdOJoz9U/ZbVHp89vCoZTflGd1jHY9vqkIpF19tO5Nfn30gKgTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625121; c=relaxed/simple;
	bh=gGcDcNi4luGCYIxrGlPOr2veccsTswScerXdIq3jzPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n80SFeoGjR4xKEKCo09qY3lFspjHgCvDaf4M26iAAaRpu31oTv2hxPkOtdykzzq2UZomR2EZWfsSsxoOl6HOQJ/twiC3/TU/zwB4XaLy8OqWVvJrs6Nx4SWgW5FI+YZGQPlFc1LlIkjAp1VcbzGwUm7o04KRXrKJcQ1g3c4gLOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBG/SILH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBG/SILH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA841F00A3A;
	Tue, 16 Jun 2026 15:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625120;
	bh=A4ojEDawW0smEQo9FLSat+Ug8KYM6TvbW8YkudewSx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBG/SILHPruN+i1S5EAQlOG1rOcAOlkL9xCfV/bf067kTtwx5uKSk0nI1mx8ULzCw
	 /jMbXQ4idNIlxv6ZJbsfZEnxfIit3Ai0wIqli6BOKwE5JzCBOpBlYb+yGqijIzDkDc
	 1PDOvo9nv057edqDVsZlvQlABG8aMs76d55RpuEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/325] Bluetooth: ISO: Fix not releasing hdev reference on iso_conn_big_sync
Date: Tue, 16 Jun 2026 20:27:24 +0530
Message-ID: <20260616145100.120422345@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 5cbf290b79351971f20c7a533247e8d58a3f970c ]

hci_get_route() returns a reference-counted hci_dev pointer via
hci_dev_hold(). The function exits normally or with an error without ever
releasing it.

Fixes: 07a9342b94a9 ("Bluetooth: ISO: Send BIG Create Sync via hci_sync")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 9b421e4a2466f7..355487613c82a0 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1521,6 +1521,7 @@ static void iso_conn_big_sync(struct sock *sk)
 
 	release_sock(sk);
 	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 }
 
 static int iso_sock_recvmsg(struct socket *sock, struct msghdr *msg,
-- 
2.53.0



