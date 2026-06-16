Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219E038C437;
	Tue, 16 Jun 2026 15:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622896; cv=none; b=JHxd4CKkCXOCIK/XREvzFxl/0+cUQj+qh+b2sPN34Wo3HbbDwn3ijKP49YSircpp5mPoPLTIEuazokvyp17ACs/iKcFQIo/T/fdaFGw53sAp+58JGznQLLkZteBEnjnYh3sa2x6KJVemevjGsO8ToqWDgN++eYem95502De4kKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622896; c=relaxed/simple;
	bh=mvObhHhTApx60iQzFm8x6Gtp3PBngqop46MSEZIGvd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoaXtr9YLQWOYpGcMkD3cfTFlCdvpsg/4BHQRzs2cfmhiyhq/ASTwyrcCuqpTYcc716hTWyOIicq7fd1ylK78Le3U/pdiPQgGQgfEOI/2XcStk3t9qb7tTPiL8YQGutBQBKYxGWZrYRCCY/KpfeSq/qm9HYvZj8eClYFcYQ5qrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dm/9EwhB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dm/9EwhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66481F000E9;
	Tue, 16 Jun 2026 15:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622894;
	bh=nBWTW3uWE7ACEvSXYMBUHMPXc6Tcay/PK2JqMhz7dsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dm/9EwhBt28P8CgTRXL89TTM7EmElvOlTmxM5B4FVHA4f1nofil+EC9Ibt/T53oz+
	 +k62bgHgyE2VdmbXaoYCHmMDee1XkNtXBrtrkxRq5yWdduZhaz587eUcPZhg4B/VyQ
	 E8tMxOjX8clQ0g1xqDgXxxkh9L0+TxTyUAjrGOJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 050/378] Bluetooth: ISO: Fix not releasing hdev reference on iso_conn_big_sync
Date: Tue, 16 Jun 2026 20:24:41 +0530
Message-ID: <20260616145112.563555899@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index a6bd608cbda69d..2363b6135c6f1b 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1603,6 +1603,7 @@ static void iso_conn_big_sync(struct sock *sk)
 
 	release_sock(sk);
 	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 }
 
 static int iso_sock_recvmsg(struct socket *sock, struct msghdr *msg,
-- 
2.53.0



