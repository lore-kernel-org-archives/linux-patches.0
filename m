Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98C22EAB98;
	Tue, 22 Jul 2025 14:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193587; cv=none; b=K6Pg+hg5258EkRWjzQYjF5wVOZTSKB6XdkNuwHCCoNqOnSn0kavZNGxFOtaQnG/bnuiP6Ds+/o5YmmExmQqr+zbZnVFZjR9KWnYfQXrO0mnPPbypE52r6RjATq77hRZ+PcLQSBUv1gqtandPRZXshUIOcGsVKtNAc9NI2WaEXm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193587; c=relaxed/simple;
	bh=OLKLkCz1K0PslxHzhpLtEDWVVWB0WA6vPCJcPCh2Aio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9t2Ny+626T/STj8FSfvyhyMLReskk0YBcPgpWOuoJExIiFF2vxRia65iW7OJhKTlXlEm8t1unbAvoz06Hs12lMrLg9l3ltlQ3SnOadV/uyyga8OuOvcxfF14Z9aUB/xDyHt/2NIPuXPBsIvycFtpTXXCCzvmyxeeRrq9ydkhFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0qe5TSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0qe5TSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20677C4CEEB;
	Tue, 22 Jul 2025 14:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193587;
	bh=OLKLkCz1K0PslxHzhpLtEDWVVWB0WA6vPCJcPCh2Aio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0qe5TSteSufK2cJqsmVN7UZn+Qhk26WFcHsS+d0zPylDJ2F9n9cTa1EOpXVQWwg6
	 JbHjKYmzSBiY3A5pufuWH7ImwTXRmdHbWV9ZsRo75nxDjyg1/UDNMXmfrp4ODYLKjt
	 YPjpAIqjymeMMKQqBmRTo+CaCSVQJ35AVW49Lb30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 136/187] Bluetooth: SMP: Fix using HCI_ERROR_REMOTE_USER_TERM on timeout
Date: Tue, 22 Jul 2025 15:45:06 +0200
Message-ID: <20250722134350.804521580@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index a3a4ffee25c80..8115d42fc15b0 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -1379,7 +1379,7 @@ static void smp_timeout(struct work_struct *work)
 
 	bt_dev_dbg(conn->hcon->hdev, "conn %p", conn);
 
-	hci_disconnect(conn->hcon, HCI_ERROR_REMOTE_USER_TERM);
+	hci_disconnect(conn->hcon, HCI_ERROR_AUTH_FAILURE);
 }
 
 static struct smp_chan *smp_chan_create(struct l2cap_conn *conn)
-- 
2.39.5



