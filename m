Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF723403E7;
	Thu, 28 May 2026 19:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998164; cv=none; b=Yl7Kin/9VoFicr02iUH5XfUo81R4V1Zmfsca9Q2QoWj9MGgNk+mBmzg+u5D/aZdR/8kGS9q5G920rk7SjION6RQO86UhB83GBSzvgxXRHKmwhso5XHZ+JZvfK7I82pqVFVogYWIiaviVIO1+Yb2bTn5nTRCE7h9ubFeUr/agfsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998164; c=relaxed/simple;
	bh=QLNP1uAc5z2PpLcWww7KjdxVBb0OimLHi6gvBrDMYho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnbrtkKaoWDfGMCco2x1OV+bvss8+VPS+TtTUMrI5b/jeqYTgAvrdTLc+pLD+x9iwbw2F3d7aErP4x5oP3siOq2O/2HrS653D9oeszy18WRCOdp0oKJW1PU5RaHJ3XhvEHvwTqTPOWqht3IayeHEeW0wUxxpVI5nmmwWB1W3klA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QSpzYfMz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSpzYfMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1717F1F000E9;
	Thu, 28 May 2026 19:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998163;
	bh=QJkbiD/ztxbjvvP/nTUryG7Mb+rN4obKa+lLsD2bAQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QSpzYfMzLWk133yV8GhflSoUrdHF9ghMrnjkyl24/MeinkeXI/tYHxrmEV4NNx3ZI
	 MP7swwEYDupwTW9jMsgRL4aoLynayDz4iCPNynlxKEfhk9lC/XxWkKCMwb6TSeoD1H
	 J4excNAmVR/svDV5x8T1rH3DhrnBcowECL24bbRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 040/461] net: wwan: iosm: fix potential memory leaks in ipc_imem_init()
Date: Thu, 28 May 2026 21:42:49 +0200
Message-ID: <20260528194648.059806506@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit c5d93b2c40355e999715262a824965aac025a427 upstream.

The memory allocated in ipc_protocol_init() is not freed on the error
paths that follow in ipc_imem_init(). Fix that by calling the
corresponding release function ipc_protocol_deinit() in the error path.

Fixes: 3670970dd8c6 ("net: iosm: shared memory IPC interface")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260519062815.55545-1-nihaal@cse.iitm.ac.in
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -1425,6 +1425,8 @@ imem_config_fail:
 protocol_init_fail:
 	cancel_work_sync(&ipc_imem->run_state_worker);
 	ipc_task_deinit(ipc_imem->ipc_task);
+	if (ipc_imem->ipc_protocol)
+		ipc_protocol_deinit(ipc_imem->ipc_protocol);
 ipc_task_init_fail:
 	kfree(ipc_imem->ipc_task);
 ipc_task_fail:


