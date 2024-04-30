Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD1F12C47A;
	Tue, 30 Apr 2024 11:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476467; cv=none; b=RdiSGYH+3R9ks008dD4cAUNAyaJfFuautypCFXeAUrW/3Q2bSQQ0s7lqtOSGFvvAkFD6K8Y8wcwQ09MgZmMlC0bGyON/KOydx5bHA4usl0DTAeuydEIk5kd96cLPzw/V0602JxHfLzPCiAVyj8FdvHihr6qnG3CtFGI62x4WitE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476467; c=relaxed/simple;
	bh=PmZmBQCizEfTtudEPzhb58NkQ2N53u5mRLPRRRLgtts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIbHFwcnL6gxMQqZUM0WV45jJy8Bc/lcZTvj9rTMWuFA44jFKYieMkvXw3ItIGNRf5i4wRKwD3iZRIWeyw3GGdbqM9cUkg4jlWXqV+Rs3UaWtQFb+NMy9vDPHFbT4nb5npTQASOXmr36+Ft3NBRQRjTNys2145F2rZP4jdKUH/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esZtvzYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esZtvzYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCEDC4AF19;
	Tue, 30 Apr 2024 11:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476467;
	bh=PmZmBQCizEfTtudEPzhb58NkQ2N53u5mRLPRRRLgtts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esZtvzYdId7e/7PGbdXMbcRFaGEwRZwo/DJst/5fN44IZ9cjovTNAZ3e6Dfxb9SK2
	 pbXGq3wuQlf8xTSA25t6T1bXgkBa5GSZQkjrFOIDYQFKK19wIIcS1N1zpbNmyH/mwB
	 wmtiAyLgKSCJYImqYephLl4czMHxv5gWbNH4DrE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Manish Mandlik <mmandlik@google.com>,
	Archie Pusaka <apusaka@chromium.org>,
	Miao-chen Chou <mcchou@chromium.org>,
	Chun-Yi Lee <jlee@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/110] Bluetooth: hci_sync: Using hci_cmd_sync_submit when removing Adv Monitor
Date: Tue, 30 Apr 2024 12:40:09 +0200
Message-ID: <20240430103048.750449719@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

From: Chun-Yi Lee <jlee@suse.com>

[ Upstream commit 88cd6e6b2d327faa13e4505b07f1e380e51b21ff ]

Since the d883a4669a1de be introduced in v6.4, bluetooth daemon
got the following failed message of MGMT_OP_REMOVE_ADV_MONITOR
command when controller is power-off:

bluetoothd[20976]:
src/adapter.c:reset_adv_monitors_complete() Failed to reset Adv
Monitors: Failed>

Normally this situation is happened when the bluetoothd deamon
be started manually after system booting. Which means that
bluetoothd received MGMT_EV_INDEX_ADDED event after kernel
runs hci_power_off().

Base on doc/mgmt-api.txt, the MGMT_OP_REMOVE_ADV_MONITOR command
can be used when the controller is not powered. This patch changes
the code in remove_adv_monitor() to use hci_cmd_sync_submit()
instead of hci_cmd_sync_queue().

Fixes: d883a4669a1de ("Bluetooth: hci_sync: Only allow hci_cmd_sync_queue if running")
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Manish Mandlik <mmandlik@google.com>
Cc: Archie Pusaka <apusaka@chromium.org>
Cc: Miao-chen Chou <mcchou@chromium.org>
Signed-off-by: Chun-Yi Lee <jlee@suse.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 4f4b394370bf2..76dac5a90aef0 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5540,8 +5540,8 @@ static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
-	err = hci_cmd_sync_queue(hdev, mgmt_remove_adv_monitor_sync, cmd,
-				 mgmt_remove_adv_monitor_complete);
+	err = hci_cmd_sync_submit(hdev, mgmt_remove_adv_monitor_sync, cmd,
+				  mgmt_remove_adv_monitor_complete);
 
 	if (err) {
 		mgmt_pending_remove(cmd);
-- 
2.43.0



