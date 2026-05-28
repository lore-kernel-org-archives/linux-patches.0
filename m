Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D69B33B6FC;
	Thu, 28 May 2026 20:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000483; cv=none; b=M7/0LXnbeh6Lto6piBaYaAGhPumZqFU88TfTAw/RjjDVptGxzMt2mgF3FxIQS4b0vyr8b6LUtwJL893JxHfAkxuH9kxZbXqwI9XDcVRIV1EtZSO2gR90SMztg6sMADsJJ/2qQrN6OBT1o3H2OqXgfs3W7z69/Y1YB5L0awO7ukM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000483; c=relaxed/simple;
	bh=jMNFY4Y+04B2Q10kll0LbI4U3VJYJzwQYOtyw5XADFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFbf8//ARR5P+7JWMZdcxdtryK7ZjvtNhmjy3pP0iE4B5chmSBRsQyqHc6xliEHS5vAH0BPjDuqbrrS2iheUxuYTSPWfQCmCXIy9MNJdrqcQEcfEfufOwylGhs9DzvowGl0+rnwl6iFbmqzazXF94MDqfkA7CKBUJW6hG6wtVIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYtEJCie; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYtEJCie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1901F000E9;
	Thu, 28 May 2026 20:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000482;
	bh=X7w5JQuObdZxYiCWumLEo2YD/9OTjQwaXEuajJP34CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYtEJCiekYHzw/zooSZXdUnadqawCmvtdZ/TDgs8LRfXtKVPKA36Fa9W8HGrByPBy
	 YecMCqk7OGnS/Nri0t7MZUKcI2z9+sAJG2RvWeepzucL7yDuvIoCUvhOYxOHRqB0HT
	 H68P5Ny3UrePtf6GtapyXTyZmlLveIkkGneLp1ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 061/272] net: wwan: iosm: fix potential memory leaks in ipc_imem_init()
Date: Thu, 28 May 2026 21:47:15 +0200
Message-ID: <20260528194631.086464483@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1430,6 +1430,8 @@ imem_config_fail:
 protocol_init_fail:
 	cancel_work_sync(&ipc_imem->run_state_worker);
 	ipc_task_deinit(ipc_imem->ipc_task);
+	if (ipc_imem->ipc_protocol)
+		ipc_protocol_deinit(ipc_imem->ipc_protocol);
 ipc_task_init_fail:
 	kfree(ipc_imem->ipc_task);
 ipc_task_fail:


