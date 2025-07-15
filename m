Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3D72E3395;
	Tue, 15 Jul 2025 13:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586706; cv=none; b=I/dgZVmxROkal1ATlboedvjH5OtV3iThRFrLdewDsLazZfXmzbim7crWHf/nD9YdEyo1y07uGQazERG7e15i1kS14eo9S5XPvaksr+hklBKyH5XiIqEzLQBSe0B9vNk//myOnpH7j3FZFR81SjgIs+oPRi/j46+JD7xuV9ZQI8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586706; c=relaxed/simple;
	bh=lCYQLhpJZiPJDH/P80hxNIRP2UsWMHauldsSHnP1a0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAgiusIQhcGWs7dTbeG4rcHFKJ7jTpFYuNWhzc/XuY6FrvZqhf1uSnVOO8pNViJtlQOKoC5MdadOH9Dg8wmysp3zw+98tHqYoWmlb9q2R3Smz4r3GHsn8+BpyY/Gi1Un64ONQPvvL+BHoejb11zD4Hzy7f+j24hfw7B9u2sIA3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkYrX4Lu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkYrX4Lu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78A7C4CEE3;
	Tue, 15 Jul 2025 13:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586706;
	bh=lCYQLhpJZiPJDH/P80hxNIRP2UsWMHauldsSHnP1a0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkYrX4Luh3oI4hueUIppxi0Yb6MBhIQ4C2M9Y8BwyBOeN+Z20nJmVXb6jSzWX/mWQ
	 V1klER/DwRuj/tiRnuCmU4acRoSKJPxS9PIkyGLhpjk3roi/ZOjFRb6UcdkIqYsDKT
	 SRV/2SAxVu4GGCjzPXSPKWOFmHisGjtdFnIM3IYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 018/192] Bluetooth: hci_sync: Fix attempting to send HCI_Disconnect to BIS handle
Date: Tue, 15 Jul 2025 15:11:53 +0200
Message-ID: <20250715130815.594137940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

[ Upstream commit 314d30b1508682e27c8a324096262c66f23455d9 ]

BIS/PA connections do have their own cleanup proceedure which are
performed by hci_conn_cleanup/bis_cleanup.

Fixes: 23205562ffc8 ("Bluetooth: separate CIS_LINK and BIS_LINK link types")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index f3897395ac129..3ac8d436e3e3a 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5479,7 +5479,7 @@ static int hci_disconnect_sync(struct hci_dev *hdev, struct hci_conn *conn,
 {
 	struct hci_cp_disconnect cp;
 
-	if (test_bit(HCI_CONN_BIG_CREATED, &conn->flags)) {
+	if (conn->type == BIS_LINK) {
 		/* This is a BIS connection, hci_conn_del will
 		 * do the necessary cleanup.
 		 */
-- 
2.39.5



