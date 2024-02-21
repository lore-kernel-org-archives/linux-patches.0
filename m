Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF456F074;
	Wed, 21 Feb 2024 13:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522597; cv=none; b=U2foHVM+BCrItd9/SsArCPEUNTJ4rErgSku63BcDdSyUwiEV7xVlat6xTQQUBlxRQu+tNxAxkWghynIi439Wp8pl9tuQPAEQMWj74guejMqrDehsqSjgHcCewFXkXVmVsa5laAvIKDf9rb+3GUOkih2XyJO/7e8KV3TDrOCjT/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522597; c=relaxed/simple;
	bh=B18iRTuXa+9xDZ6fP6QVTUMPBM0HmwtepQk2NlCXH2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hEA5wgZSHWGCJNo4/RQ2DcHVNQtWpb2aLrEAXa3y+uabTGoDtjzJQ1i6/UwvB258tzi6eu3xMr8A5OXCTkFNs/PN+Y2/iMe81Wn5eHYRXsDwCpNMuQFS8F/JXkQfBrb8C60HNUJwN+PikNnPCchMsbOhdH0/Heyp5dUTaFjRF9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdcYt9cI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdcYt9cI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DD3C433C7;
	Wed, 21 Feb 2024 13:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522597;
	bh=B18iRTuXa+9xDZ6fP6QVTUMPBM0HmwtepQk2NlCXH2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdcYt9cIloBfa6GIFBrZ6qqr4FNlFt3m90upzPwVEIAzmSjvVAXBcunE0uR4dtz3R
	 BVt8ZAqBo1oHdtZCrL/CBYhIS8T1xkPdi/aYl7+EZ2+a0BsUgCValXE+gH8US+dAPF
	 mSdJQXjSokPkgiEz7FSCGtgqnS5NhlfJvqJDTE0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Danis?= <frederic.danis@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/476] Bluetooth: L2CAP: Fix possible multiple reject send
Date: Wed, 21 Feb 2024 14:04:15 +0100
Message-ID: <20240221130015.449203737@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9f3596de90a7..850b6aab7377 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6527,7 +6527,8 @@ static inline void l2cap_sig_channel(struct l2cap_conn *conn,
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



