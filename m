Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D057BB01;
	Wed, 21 Feb 2024 14:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524194; cv=none; b=UtQKIpfSh92mVBfWBQCYqzJkPm79i0sN6GaYcKku25o1zodUzZcBEzYPq2OQmTVNzJN/Vymg5TbRCHSnSiaLDSoMrcufnlw+utqmnbyOQF3XaUMfrbMQmfsZ3vtCbKqewEkpk6uWOE3QJ7rIUoQfN8fmKV9t/DOPyHch4pdOQos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524194; c=relaxed/simple;
	bh=CyexDbKluc7PPsJxJxQOZ6+hlKT6zPIb9rQux3C7zxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rdAvPNRDOqVDWC++nuEXnQN0QPGaXou/GEEVmcOtLOWqHYtidIe7J205JO4U5Q+ThcNbrAV2FOPM+ga5eFtNIkR25erT5Koo8jOPCpomRXqtnWq/FB7Ro4IetZNArkOniI87qmKEstDDkDJ1N7uayGCTw9mgY3KMM5VRmcQSj6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+3EsTJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+3EsTJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732A4C433F1;
	Wed, 21 Feb 2024 14:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524193;
	bh=CyexDbKluc7PPsJxJxQOZ6+hlKT6zPIb9rQux3C7zxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+3EsTJUBlrXBSAMMAIwt7JYFl60iGE3w82szduV+JWFtJG115Ef1CnjxBqwZ2WsQ
	 9TK8XHkEp67HRMimpnOM+B2mPh5jbHjyxUV8i3MeaeQLZ0mmojyK24BatIRnI5mRII
	 8OheuaR9mISH7WS8swP9jmcKMn3XvGP1IQmA7zFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Danis?= <frederic.danis@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/379] Bluetooth: L2CAP: Fix possible multiple reject send
Date: Wed, 21 Feb 2024 14:05:52 +0100
Message-ID: <20240221130000.033408524@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cf78a48085ed..a752032e12fc 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6522,7 +6522,8 @@ static inline void l2cap_sig_channel(struct l2cap_conn *conn,
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



