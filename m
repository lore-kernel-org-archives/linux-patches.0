Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D9410A35;
	Mon,  4 Mar 2024 21:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588286; cv=none; b=XIYJ65QTyzmeqCbL5s9+yRoGxCd8616dz9ekYc/up0bAdJ+xZCf6FjH/iHnnDnt6h0k1g2OnFJcW6KTv7AJzdyxwkcs7ev4APV5lAKsk6j/hSb28bF+bIZPcHz4kNBotJjIYNO/dhEqecPLEvnb8Kb2RoaaDencP8eqGLQ+EIgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588286; c=relaxed/simple;
	bh=fhrv4GAqC8UQAX3++URjPOPHHh68jCR4SYoUJrrSLoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6aE1oNcCVwiX5X+W7MfMcuKucmfedo5sjMWyIwIZMxYTjmD2o/hLfiRjm+DXmpalMEEAcx2N3k2rak25vsSNWpSq5vlxkcUt5iUvqFShdUkq5Urmc/AkYQXparzGUYRL3bLqJ8BsfixbvirPSq1wnFjwRIGMjmZvrmPw8VMrVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVEX45t7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVEX45t7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCD3C43390;
	Mon,  4 Mar 2024 21:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588286;
	bh=fhrv4GAqC8UQAX3++URjPOPHHh68jCR4SYoUJrrSLoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVEX45t7HdHmfQMarIYBRi19cEmBWZXVUzpV9SRk+CpL51msAjJ+3veBj5DUPy++M
	 VSRnneINTZQic9mBUjFHgEBxYCTZEPFw+zkJ1CeNG1Y35WDkl9xrB62TDaSzxxeQOK
	 UMQU1R69wMG2k1HDP68AtjIL0sfoZnhZRNKzIkMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clancy Shang <clancy.shang@quectel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/143] Bluetooth: hci_sync: Fix accept_list when attempting to suspend
Date: Mon,  4 Mar 2024 21:22:25 +0000
Message-ID: <20240304211550.752987737@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 497b12e0374e0..fef9ab95ad3df 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2274,8 +2274,11 @@ static int hci_le_add_accept_list_sync(struct hci_dev *hdev,
 
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



