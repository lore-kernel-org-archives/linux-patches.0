Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0112E3B6C17;
	Tue, 21 Jul 2026 22:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673760; cv=none; b=dg2mu+MrJLFPIDdoDZdn4IlTCg7rHUYyy1Hv9sRd+6Ri6+UFafZaqCpLjJlrzkTQeKedD1hMmUBXvZ3h2hhci35Rp5MK8/o7is796bepY6Sq2HcBn2Va25+e/gtAbgZD1KrH3d1Bv6DNCCLv3Of1srpwyNZeOU/rBfg6EXAkiQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673760; c=relaxed/simple;
	bh=IlK1l8bEMZjlUAL/xbbnurjFW+MnAxCZgXCu0KQ7DrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdYYvALk7At8mDsipbagJattySyzzJDvC/KRU7NbpR95Fwouc643chgXjae8sJIu8lrFNVWPYLRBK1DEHscgsR2GzuSNTCXoP1kCfG4AZaH2whsnJPUlzPrMsr97r6xgMbd6Bi+/uk662aOLUUdqA03WHj5MPWSOp9Lh/8P0S68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyTCch74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyTCch74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619FA1F000E9;
	Tue, 21 Jul 2026 22:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673758;
	bh=3X43Yae0/89OWrK2KcjxKcN+VRQqDilHtN/cWQcwMis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nyTCch74JN/d6gMhpRX5xsYHkzKOXVO2PMgbGEg/dw/S6hjK+p5G+mPdiPKGUfMtS
	 sRj71J1qZAF22qgHrBi8xPRVdpIbWtDuJHSgyqL1WnYJuPNXU0kdTWcgVV/U6aWYIZ
	 ov1nsC9OzaO5BxC9LAsNFQ5O6LR6nCWWDMMX4K7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 267/699] kcm: use WRITE_ONCE() when changing lower socket callbacks
Date: Tue, 21 Jul 2026 17:20:26 +0200
Message-ID: <20260721152401.725615069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 47186409c092cd7dd70350999186c700233e854d ]

kcm_attach() replaces a live lower TCP socket's sk_data_ready and
sk_write_space callbacks with KCM handlers, and kcm_unattach() restores
them later. Those callback-pointer updates are still plain stores even
though the same fields can be read and invoked concurrently on other
CPUs.

If another CPU observes an older callback snapshot after the live field
has already been restored, callback execution can run with a mismatched
target and sk_user_data state, leading to stale or misdirected wakeups.

Use WRITE_ONCE() for the callback replacement and restore operations so
these shared callback fields follow the same visibility contract already
established by the earlier 4022 fixes.

Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260611053543.2429462-1-runyu.xiao@seu.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/kcm/kcmsock.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 2f2840aa4a8129..df3ca6a9791e6c 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1404,8 +1404,8 @@ static int kcm_attach(struct socket *sock, struct socket *csock,
 	psock->save_write_space = csk->sk_write_space;
 	psock->save_state_change = csk->sk_state_change;
 	csk->sk_user_data = psock;
-	csk->sk_data_ready = psock_data_ready;
-	csk->sk_write_space = psock_write_space;
+	WRITE_ONCE(csk->sk_data_ready, psock_data_ready);
+	WRITE_ONCE(csk->sk_write_space, psock_write_space);
 	csk->sk_state_change = psock_state_change;
 
 	write_unlock_bh(&csk->sk_callback_lock);
@@ -1481,8 +1481,8 @@ static void kcm_unattach(struct kcm_psock *psock)
 	 */
 	write_lock_bh(&csk->sk_callback_lock);
 	csk->sk_user_data = NULL;
-	csk->sk_data_ready = psock->save_data_ready;
-	csk->sk_write_space = psock->save_write_space;
+	WRITE_ONCE(csk->sk_data_ready, psock->save_data_ready);
+	WRITE_ONCE(csk->sk_write_space, psock->save_write_space);
 	csk->sk_state_change = psock->save_state_change;
 	strp_stop(&psock->strp);
 
-- 
2.53.0



