Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335554071DA;
	Sun,  7 Jun 2026 10:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827489; cv=none; b=MP7ZCprfh8zzwvYd7z/Xoc3+YgiUsWzTZVIp/Bm858PgK0jy8o7A6ZOdZePtWWauDFvzdYjsTyRxXPAehFrznjyC7oyhPWDp0HVqS42QgqyhKMdje6a3/yjvHzpTfVyjqQo73g65ZGl42L+Bb2IBkrn7vJjJR0vlaub1ihOhNpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827489; c=relaxed/simple;
	bh=V/v1OFSSNIfw4KT4FYZh5NL9w1AJvg+TrL2+GIFm6sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGnGSCQTj2S2yIpZgRm2qshy3jEuu084qm2dM+P63vgS3kx2jp5VnP59moW5HncWwdGAmRRiU+sp5lYjjJz3Ty6OuWmXJvThEwYDzcezCZ8KuIbsC0BHfAAkBBEd3L1iDKw6lDuk5wWHcvCxJXcTCSU1hsgR6X2BfeVbbFCLZpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bU46uiV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bU46uiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8561F00893;
	Sun,  7 Jun 2026 10:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827487;
	bh=lrjxbDxdr/QmdlfpYk7g+w45CEuQP4pm1yrzy1eb51s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bU46uiVoCwhxSZKLHJ9EcL72NjUw4NONTJN+NOOtEOvBsx8alFEcKRUIbRu6Ar6I
	 Z24JEvb20PvmcxEtgjIdNdN+DifWFNkhljRrhs0i5A7OvgApiWHgNM/vBD4tKzChF0
	 R+1anvqDHQLMN0wrSGpjPqyAygLl58iu+/m0kRC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 097/332] Bluetooth: l2cap: clear chan->ident on ECRED reconfiguration success
Date: Sun,  7 Jun 2026 11:57:46 +0200
Message-ID: <20260607095731.710737157@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

From: Zhenghang Xiao <kipreyyy@gmail.com>

[ Upstream commit 00e1950716c6ed67d74777b2db286b0fa23b4be9 ]

l2cap_ecred_reconf_rsp() returns early on success without clearing
chan->ident. Every other L2CAP response handler (l2cap_ecred_conn_rsp,
l2cap_le_connect_rsp, l2cap_config_rsp) clears chan->ident after a
successful transaction to prevent the channel from matching subsequent
responses with the recycled ident value.

A remote attacker that completed a reconfiguration as the peer can
replay a failure response with the stale ident, causing the kernel to
match and destroy the already-established channel via
l2cap_chan_del(chan, ECONNRESET).

Clear chan->ident for all matching channels on success, and harden the
failure path by using l2cap_chan_hold_unless_zero() consistent with
other L2CAP handlers (l2cap_le_command_rej, __l2cap_get_chan_by_ident).

Fixes: 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Signed-off-by: Zhenghang Xiao <kipreyyy@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 99297d8f2c1f34..83ea31926bd0f8 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5466,14 +5466,20 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
 
 	BT_DBG("result 0x%4.4x", result);
 
-	if (!result)
+	if (!result) {
+		list_for_each_entry(chan, &conn->chan_l, list) {
+			if (chan->ident == cmd->ident)
+				chan->ident = 0;
+		}
 		return 0;
+	}
 
 	list_for_each_entry_safe(chan, tmp, &conn->chan_l, list) {
 		if (chan->ident != cmd->ident)
 			continue;
 
-		l2cap_chan_hold(chan);
+		if (!l2cap_chan_hold_unless_zero(chan))
+			continue;
 		l2cap_chan_lock(chan);
 
 		l2cap_chan_del(chan, ECONNRESET);
-- 
2.53.0



