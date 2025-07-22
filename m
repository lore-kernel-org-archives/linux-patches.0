Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0508B2EA17E;
	Tue, 22 Jul 2025 13:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192134; cv=none; b=cajvbWMprN0u7iNz7TzXEfnCcQUYkcHsLPjpByClqj0Zls3u1U8GzhbTVR3ySEKV5bSD9ohU/sr5h+miH+Zr/B16Q5zVLyglXLvn9TXAFyYWhmLcYvogYKnnH/7WcI7v0VNqOqerexxOaBcG5fSUYhRH8WXZZTu9JX4IET04dvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192134; c=relaxed/simple;
	bh=Op0BXKu0Dd5o5AqkCfWP0ED7pOB4WfaSZ6PoMu7E98I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZec69Zn/VvpQb6bQ0KH8kzFsDUoy8msfqUwLvE3x1DW0LVQHY2vhaDagb0Gx9xEGbeLRHBAdWb9lCqrFdj14+ue9UU3LzG8KTA514SJX53kKmie7X2MzkKrecikRmvwqDwltxFkWdvi8sSq6NnSyor44i/uOnBl9MjBRZyZWjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGM039qW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGM039qW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1E8C4CEEB;
	Tue, 22 Jul 2025 13:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192133;
	bh=Op0BXKu0Dd5o5AqkCfWP0ED7pOB4WfaSZ6PoMu7E98I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGM039qWqz72EVDqtXP6Zq475yGnNf87kTjDKBcmcm3OIYjxk5q01NzZ/gNuYcuuC
	 ROSA0Qs0jyVKaNzRmZwRXAXYKvw6A7Nu94dcMcgFEhaHAFc1CyGnwghhVUye/k5fSI
	 12usxy1XtLc5TdYtdew7BEtQYEzrnYcXs7C1xaoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 55/79] Bluetooth: SMP: Fix using HCI_ERROR_REMOTE_USER_TERM on timeout
Date: Tue, 22 Jul 2025 15:44:51 +0200
Message-ID: <20250722134330.401065326@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2ed57a71f1b2f..a03920fe44d94 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -1373,7 +1373,7 @@ static void smp_timeout(struct work_struct *work)
 
 	bt_dev_dbg(conn->hcon->hdev, "conn %p", conn);
 
-	hci_disconnect(conn->hcon, HCI_ERROR_REMOTE_USER_TERM);
+	hci_disconnect(conn->hcon, HCI_ERROR_AUTH_FAILURE);
 }
 
 static struct smp_chan *smp_chan_create(struct l2cap_conn *conn)
-- 
2.39.5



