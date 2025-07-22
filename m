Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7CE22CBE9;
	Tue, 22 Jul 2025 13:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192482; cv=none; b=mNKDFZR8DmKZMAp7yQxFf5zWSK+E9kUSTfQIdDnCWc+aHKH1Shupj1JcLjCSad32oEDY+I8hF85C6YTM5QiPBX3jDnzpzY2M98dP3fgpt/y0QtSUpLWEJNDwqgLVL2iJTt86Psxlk7b5x9n7ZimJDAG4wMcvwGDARWJ8USQmSGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192482; c=relaxed/simple;
	bh=BqJ7X/vPGLfcQawk9spHT/S6Mj4d+zz/sgB1kLqFphM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMJnEZsuluc38BotX3MQDafUNliq62iig/uqGXvY12WxYcTmWbMD/TB7+Tyjab2z6TN5BtLawjj0u51dZLqrwejnVOcZpFGAWsZg9H2rcgZeLfj45wwU7Wpzr4Nn5VjQ7k28pBH/fLpaaYze/rcDY/uxd3Cx3Y0ZCmJn0QO3Xnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywu59lAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywu59lAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB4AC4CEEB;
	Tue, 22 Jul 2025 13:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192482;
	bh=BqJ7X/vPGLfcQawk9spHT/S6Mj4d+zz/sgB1kLqFphM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywu59lApNi1ba2JpJuYmzQA9dvxkv0ZYFJVM3nVutP3haRO6VsUuUxyI8MK7FP/WS
	 4aH90eOqZv2H4ARikjetTQlNOh8BPIlfujHjBKhm/cQHooHGWnKiJ2m5YUOQVBQ7yx
	 Prxp6hVzIOkCAn1RWvy8ktofFoS873wcwDj9EoVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/111] Bluetooth: SMP: Fix using HCI_ERROR_REMOTE_USER_TERM on timeout
Date: Tue, 22 Jul 2025 15:44:54 +0200
Message-ID: <20250722134336.337996106@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 6ef99c917688a8510259e565bd1b168b7146295a ]

This replaces the usage of HCI_ERROR_REMOTE_USER_TERM, which as the name
suggest is to indicate a regular disconnection initiated by an user,
with HCI_ERROR_AUTH_FAILURE to indicate the session has timeout thus any
pairing shall be considered as failed.

Fixes: 1e91c29eb60c ("Bluetooth: Use hci_disconnect for immediate disconnection from SMP")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 7040705876b70..4c00bc50de811 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -1380,7 +1380,7 @@ static void smp_timeout(struct work_struct *work)
 
 	bt_dev_dbg(conn->hcon->hdev, "conn %p", conn);
 
-	hci_disconnect(conn->hcon, HCI_ERROR_REMOTE_USER_TERM);
+	hci_disconnect(conn->hcon, HCI_ERROR_AUTH_FAILURE);
 }
 
 static struct smp_chan *smp_chan_create(struct l2cap_conn *conn)
-- 
2.39.5



