Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A090101C1;
	Sat,  3 Feb 2024 04:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933404; cv=none; b=Mrr3VTyW/m4CqRTa/Voh53LMgethDVegH8QQViVwF53CAkwt3gJTUYJjWfv5Zdch/hwMkvPILuFV7QsnFjhsiE6AQA9jcbeclmhoRMXns6rOFr44BeYP9C44XwMTXUODmtWJTRP+eWf6KK6d4uBqXyaaddrwny5J6lwIsnIwY3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933404; c=relaxed/simple;
	bh=5rIser0X5Ol4YPy/ZTDWTf/54pNwp07LVJJkvYdoS/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uJiKglY5PlqLH064D8MVXRycnaWfcE3UlP9vEp5yC6mLiH0S3Qo/bi1bAhb99Ie+tVTzg6rQdGd6arUtNEcd67X5OXWIPjY4lmsw2NQChr+3pxFnfzFBfIy926zdd3X1pyZiDIT2bF+GfvFNDUIaDwmchwAhmcLmrIbAPy7gOv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTU6+y76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTU6+y76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60DFC433C7;
	Sat,  3 Feb 2024 04:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933404;
	bh=5rIser0X5Ol4YPy/ZTDWTf/54pNwp07LVJJkvYdoS/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTU6+y76ZdS5C8gFYT8JMC1Qqu7Bc95lt8ZmXT3+UchX7xiJfN3zPKLf8bXWJbewG
	 mtZFo83+YGafBVlVnpy1PWnKht7w8WnF0Utoa4iwp7kVrRY00BmHhfoZKuht9oeJBm
	 0wCD7rjWWCHAOwqIpeAAKrrAQdoF51vq1P064tQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Danis?= <frederic.danis@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/219] Bluetooth: L2CAP: Fix possible multiple reject send
Date: Fri,  2 Feb 2024 20:04:31 -0800
Message-ID: <20240203035330.980324989@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4c5793053393..81f5974e5eb5 100644
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



