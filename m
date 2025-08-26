Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B33225390;
	Tue, 26 Aug 2025 13:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215483; cv=none; b=JauTAM+i+QQUZfe4/HTbO+rSb/FEozO0V9GWpHfbzL+dyIFLVCfziXJKZOtJzogZ/reyANrglejkRbxGvupOLgIzXH6A5UlHOG4aqEUHuFA+oNX2FsFz+3n34A4uXJm0XgHLdnqMQNaW82eBjYgbY3VeOLRB6GKVo2rQy9epzYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215483; c=relaxed/simple;
	bh=4cQwnHP5tFNdXwOC5nvZ55LiMz83sCPrOtzfTu9HM/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHhSjgvIqGB60xzDXjSx3TYincM385fFJbUE3qH7WxOUZ+DrBlro0pbywzOI77OByEBDvtFuHQy6Vtp4r9UjeMVA9G8MCJ0htRagJ7Y4Y3uKI/aLwNACOKAGpK9VeY/Yflzqqh6A8C/13dDFXFsWQiuTRsb1S5Sa/FPgy+nncb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3eC+2JB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3eC+2JB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9337C4CEF1;
	Tue, 26 Aug 2025 13:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215483;
	bh=4cQwnHP5tFNdXwOC5nvZ55LiMz83sCPrOtzfTu9HM/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3eC+2JBflbYCyqQe9pxsZPKMP3CLUEaC+2vA4UIdIHEPI5+MZUuxHq8yr+NmMXHV
	 xKh5Nng89XY0s7nyA/HqLhhJLv9Py6RacqLIdVcupbrVYBeFXUOOndyH/lescBmLVa
	 tQkdtl9Ct82OuchRPSILvTOSZyXbc83LlIkxmkSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/644] Bluetooth: SMP: Fix using HCI_ERROR_REMOTE_USER_TERM on timeout
Date: Tue, 26 Aug 2025 13:02:21 +0200
Message-ID: <20250826110947.743402130@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0f4e92c4dc94a..697ec98b07982 100644
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



