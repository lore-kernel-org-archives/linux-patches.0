Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59303358C6;
	Tue, 21 Jul 2026 18:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656815; cv=none; b=C7H0v92B7QCUzy4rHsS//84zOyW5WStLtRnSAbFE11ORvtAdOHF9/qSWvj79PxT1g23YyLxS++zQr1w/FM1GEQRbflp+dL6i92Ur3nUqcG8ktzxBPiyAEy4r33oeMC3co/lR8p27zrj0HzJepK9cTIOmeqUoCmrUFhRprNEL2aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656815; c=relaxed/simple;
	bh=CLO/lo8b/0ZbvgJ9eLtvg/pJ4kd31ta0/cmjbDjtdmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptEneI/+mXXi4sxSTRgJlaIgZzw7xPPB3Yqc2nniKMV4Obdwq28AUQ6O48oZwOcW58lbuyBMJMP1ezzxoDi/CwI6wPFOd+TbTGYlcq7TF0sVPLShRc503QQrJyNWwpP/tKyd03E9GAhYbXwUqxNQAx6kpZkDdYJQ710qfpjmrBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=weWMSrAa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="weWMSrAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109521F000E9;
	Tue, 21 Jul 2026 18:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656814;
	bh=Rm+Nw0L+/6iL9SNdRxhfDRGZitub7f8JtJfRzHT3+xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=weWMSrAaGRZIBQKtCxLrHNUufggcG4Fi/UyV2Jsq6Q2k+bC7sDyEJdXPmKHV2uZbC
	 Eux09DQth/yZuZOU4OzuXCzuNZQPnmlf1O2LTP2tDHPam/7ZdIKOVb2m3zclLc17EV
	 rpyhyPeukjZBE0i75LLOmSOjnvGC/0uRa/bLVBOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0530/1611] kcm: use WRITE_ONCE() when changing lower socket callbacks
Date: Tue, 21 Jul 2026 17:10:46 +0200
Message-ID: <20260721152527.270565642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index f6d44481954cd7..dc126f7f030c4d 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1304,8 +1304,8 @@ static int kcm_attach(struct socket *sock, struct socket *csock,
 	psock->save_write_space = csk->sk_write_space;
 	psock->save_state_change = csk->sk_state_change;
 	csk->sk_user_data = psock;
-	csk->sk_data_ready = psock_data_ready;
-	csk->sk_write_space = psock_write_space;
+	WRITE_ONCE(csk->sk_data_ready, psock_data_ready);
+	WRITE_ONCE(csk->sk_write_space, psock_write_space);
 	csk->sk_state_change = psock_state_change;
 
 	write_unlock_bh(&csk->sk_callback_lock);
@@ -1381,8 +1381,8 @@ static void kcm_unattach(struct kcm_psock *psock)
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



