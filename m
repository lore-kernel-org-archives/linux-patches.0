Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC03510A35;
	Mon,  4 Mar 2024 21:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588714; cv=none; b=IQe+jaJBn1lIV/ez9g3PRT8E2e8F4IG9rLafVgP94DZTIh1oFKPM4nwGcDI2/U99j06Yk1/13/IHYZIX+9i5r2qGgR0P9zJJ62Q1AzGuMk3k52TmKv7p7/KXb09tqLBvWj3V2stnNZhvj/AzRYhMbgFAnu0Hv5M5dUP9FsljUYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588714; c=relaxed/simple;
	bh=bi0kqbDY8Vwo1GpuWG3ZfIyKJrTQdAKt5B42qOmWG/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PG9ypJN+/GBd6Ri2wHtAdsxTOlWXe+ijafNFawvOmNY6+DV7MvZCkWMRGTTVfO+xylwlRTuSQ278WWrOK4FgEDgefpzqww6zjHPkLNbL/RN7EjJBJtyxxEBi+EBzf2JWKGKjxD8VY8Mu0Z93jzGAwt4GPZxh06BSCPIGETd6O+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixChFI7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixChFI7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E31AC433F1;
	Mon,  4 Mar 2024 21:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588714;
	bh=bi0kqbDY8Vwo1GpuWG3ZfIyKJrTQdAKt5B42qOmWG/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixChFI7ef5YGcZRH/1cMi3YpAxDfZLjPtcloNyGWrzWyBrIxspqFbFku67Y5/DPz9
	 5z7lAYwA6zYJ3DxtGrRL91Lft1HbqI4ySPdKci+KDSZ9oBxppf49tOsjc2lLVBSV3N
	 moBPkBDlJMOBmzcl0gyK2ABFm5ltasZEOMbk53IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clancy Shang <clancy.shang@quectel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/215] Bluetooth: hci_sync: Fix accept_list when attempting to suspend
Date: Mon,  4 Mar 2024 21:21:47 +0000
Message-ID: <20240304211558.401218030@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit e5469adb2a7e930d96813316592302d9f8f1df4e ]

During suspend, only wakeable devices can be in acceptlist, so if the
device was previously added it needs to be removed otherwise the device
can end up waking up the system prematurely.

Fixes: 3b42055388c3 ("Bluetooth: hci_sync: Fix attempting to suspend with unfiltered passive scan")
Signed-off-by: Clancy Shang <clancy.shang@quectel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 13ed6cbfade3e..a337340464567 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2251,8 +2251,11 @@ static int hci_le_add_accept_list_sync(struct hci_dev *hdev,
 
 	/* During suspend, only wakeable devices can be in acceptlist */
 	if (hdev->suspended &&
-	    !(params->flags & HCI_CONN_FLAG_REMOTE_WAKEUP))
+	    !(params->flags & HCI_CONN_FLAG_REMOTE_WAKEUP)) {
+		hci_le_del_accept_list_sync(hdev, &params->addr,
+					    params->addr_type);
 		return 0;
+	}
 
 	/* Select filter policy to accept all advertising */
 	if (*num_entries >= hdev->le_accept_list_size)
-- 
2.43.0



