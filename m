Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EE4757EB;
	Mon, 15 Apr 2024 14:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191250; cv=none; b=aQDfkM9AkePxJz6LjXQ6Db0ulocM+BJzONce5y9uCnxQIRjiwbH0NoCmGR8CmzjCoRxUOCdHqNBNx+5N9nCAMSmg/5J5ot7pwXlu1gnDy4NcPc1r+ql3lJVj4O6u4DtubdWIJhsuTRkmWobrqL6RcQqFxFlmhC4+/1CiI8as+zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191250; c=relaxed/simple;
	bh=mwcaxuPyyuoV9k7Xky+3sHheFnNr9a/9n217b3Ig4Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqgVC6P/Qpyz8xj+ytpydRyhwSUeuENtZt4ZeEBXpfifkgLdd0igbNMwA7IsmTjU2/MU/QzY0fQyRCsDhi+LHkBywuoDybrHUN07q7jxpl+9+N/mlIReJDx1Kne0u6wV1WMe9tbPnUyfGC83jvGRbVJvXQ5ZJQzknMdqfo8nzGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSIkMJJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSIkMJJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D2AC2BD11;
	Mon, 15 Apr 2024 14:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191250;
	bh=mwcaxuPyyuoV9k7Xky+3sHheFnNr9a/9n217b3Ig4Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSIkMJJrIOGwh1RQ4ZqWUq6S8jDSpRN5wbDwnDQD13LQY4nvOKrXFndDkfvWfP6Sk
	 TWuaJY6/2yyf/hNC7E0SIf+ELviouETzI0HDfIqGbIGA1oGhhbev6jQnCnhG4RT5Jd
	 5j6wa6XJQQr3ZcxfDER3yoRzQyzhqJCJl3K5kCvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Archie Pusaka <apusaka@chromium.org>,
	Manish Mandlik <mmandlik@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 080/172] Bluetooth: l2cap: Dont double set the HCI_CONN_MGMT_CONNECTED bit
Date: Mon, 15 Apr 2024 16:19:39 +0200
Message-ID: <20240415142002.830898582@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Archie Pusaka <apusaka@chromium.org>

[ Upstream commit 600b0bbe73d3a9a264694da0e4c2c0800309141e ]

The bit is set and tested inside mgmt_device_connected(), therefore we
must not set it just outside the function.

Fixes: eeda1bf97bb5 ("Bluetooth: hci_event: Fix not indicating new connection for BIG Sync")
Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index ab5a9d42fae71..706d2478ddb33 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4054,8 +4054,7 @@ static int l2cap_connect_req(struct l2cap_conn *conn,
 		return -EPROTO;
 
 	hci_dev_lock(hdev);
-	if (hci_dev_test_flag(hdev, HCI_MGMT) &&
-	    !test_and_set_bit(HCI_CONN_MGMT_CONNECTED, &hcon->flags))
+	if (hci_dev_test_flag(hdev, HCI_MGMT))
 		mgmt_device_connected(hdev, hcon, NULL, 0);
 	hci_dev_unlock(hdev);
 
-- 
2.43.0



