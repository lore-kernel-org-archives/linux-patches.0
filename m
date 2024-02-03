Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F6013AC6;
	Sat,  3 Feb 2024 04:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933828; cv=none; b=tE62jgcyVH9HuZ0+PSbWjKVJnFcSp67kY3V6Q6TFIuJgH/Y4En+qoLRJbjRASi+gQXNsEtWSHmLHuWvrY2Si24RhDiE6A3rLCU0SMmHve9eFIM3j3DFQ65fL9Nva7vDy9gUfrlcFHr52jY+5CdtNWOL0/lhNM+fuBIhvPh5tFlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933828; c=relaxed/simple;
	bh=IxZD+JTKJ8/ECF2a6/n6iC4GV93yg9p3NCLh/DKruoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DFEhjHw/KCKa2NuE1s2WS5t9ZlWD+4ltCArfR1+R1BRN2suAWgBBj4Brs8+BmNqr7n2EtD96vnYg35iAmG6SRFLw4KWs6hvhGchFcUWjhAyZSWU/uJnqynFldgCVK1fMDkeUBMiwdNv590CljTQ1PU+zcMjCDPGsml3B00rKdSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yf9LCzst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yf9LCzst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28913C43390;
	Sat,  3 Feb 2024 04:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933828;
	bh=IxZD+JTKJ8/ECF2a6/n6iC4GV93yg9p3NCLh/DKruoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yf9LCzstEonwyPdwwynGjkiSSBbE4umFXn9qC3oij0oRI0TbrfHftXk179uEg5qVp
	 CKqnVDXpBsYJFUb5OnX/+k7df2UUFlXha8VdoXLcdzSDDRYgb7yY8oeNw93t1HNIaL
	 98rvzgjD6Etzj3jSgnbprIwZnFFTGCQiRtJUaBYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Danis?= <frederic.danis@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 151/353] Bluetooth: L2CAP: Fix possible multiple reject send
Date: Fri,  2 Feb 2024 20:04:29 -0800
Message-ID: <20240203035408.443637561@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frédéric Danis <frederic.danis@collabora.com>

[ Upstream commit 96a3398b467ab8aada3df2f3a79f4b7835d068b8 ]

In case of an incomplete command or a command with a null identifier 2
reject packets will be sent, one with the identifier and one with 0.
Consuming the data of the command will prevent it.
This allows to send a reject packet for each corrupted command in a
multi-command packet.

Signed-off-by: Frédéric Danis <frederic.danis@collabora.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index baeebee41cd9..60298975d5c4 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6526,7 +6526,8 @@ static inline void l2cap_sig_channel(struct l2cap_conn *conn,
 		if (len > skb->len || !cmd->ident) {
 			BT_DBG("corrupted command");
 			l2cap_sig_send_rej(conn, cmd->ident);
-			break;
+			skb_pull(skb, len > skb->len ? skb->len : len);
+			continue;
 		}
 
 		err = l2cap_bredr_sig_cmd(conn, cmd, len, skb->data);
-- 
2.43.0



