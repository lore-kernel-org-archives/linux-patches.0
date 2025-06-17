Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0D11E98E3;
	Tue, 17 Jun 2025 16:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178844; cv=none; b=EmkzE3BnZs7zu0Lbw+nfh90rjkNHpstbMoWEWE9MabjBupJ2SwTuTFiR9A9R/+j/1zH6F4LzD7rrxiNowvii8UPw0LqHtvT96yvHH17RUH4chqhmR2IDuz2wLBjMXL9ygIhynZGddL4T8reSywSJe7MHt8sF+VsgtAcJ/1/eUxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178844; c=relaxed/simple;
	bh=NOQNt6kpQxn5+4Ar1RNgcsdjeFpMCsDe6E38O3Yn9n0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRLpMq1PHthXRI78zvex6xVZiI5P4Mqfo5mLYy1LthJNx4nXRINCAbrZMB9rnKUSXlWNwtRIZxvDTobdp6qN/WYRFRCNU+iHAva+I/XlsjZfEiOSfVAp3KYJOYSIx25byUox1gc2G5hxOiTq8+Wv8p4rLCEqde6qa8mzfw8rzfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sy3zJI6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sy3zJI6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AA1C4CEE3;
	Tue, 17 Jun 2025 16:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178844;
	bh=NOQNt6kpQxn5+4Ar1RNgcsdjeFpMCsDe6E38O3Yn9n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sy3zJI6PxAiFi9A9pkSk4kd9EO7LinAl2PpZRPEDyZAkCI9RfLjmGqv6J9LDvSiB+
	 Yska3pVQtyV7H71UC/gchQJXuVVNwURbSZ7swE+BzI+X3KTIiFT2nwBQfD7TdMyoc6
	 hehAw+m3hMVLR2SXV1fWeZsJC4AIAKkMVFhJj6Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5fe2d5bfbfbec0b675a0@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 569/780] Bluetooth: MGMT: reject malformed HCI_CMD_SYNC commands
Date: Tue, 17 Jun 2025 17:24:37 +0200
Message-ID: <20250617152514.649721570@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 03f1700b9b4d4f2fed3165370f3c23db76553178 ]

In 'mgmt_hci_cmd_sync()', check whether the size of parameters passed
in 'struct mgmt_cp_hci_cmd_sync' matches the total size of the data
(i.e. 'sizeof(struct mgmt_cp_hci_cmd_sync)' plus trailing bytes).
Otherwise, large invalid 'params_len' will cause 'hci_cmd_sync_alloc()'
to do 'skb_put_data()' from an area beyond the one actually passed to
'mgmt_hci_cmd_sync()'.

Reported-by: syzbot+5fe2d5bfbfbec0b675a0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5fe2d5bfbfbec0b675a0
Fixes: 827af4787e74 ("Bluetooth: MGMT: Add initial implementation of MGMT_OP_HCI_CMD_SYNC")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 261926dccc7e8..14a9462fced5e 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2566,7 +2566,8 @@ static int mgmt_hci_cmd_sync(struct sock *sk, struct hci_dev *hdev,
 	struct mgmt_pending_cmd *cmd;
 	int err;
 
-	if (len < sizeof(*cp))
+	if (len != (offsetof(struct mgmt_cp_hci_cmd_sync, params) +
+		    le16_to_cpu(cp->params_len)))
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_HCI_CMD_SYNC,
 				       MGMT_STATUS_INVALID_PARAMS);
 
-- 
2.39.5



