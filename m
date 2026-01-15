Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2DF3BF2FD;
	Thu, 15 Jan 2026 17:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497120; cv=none; b=ebYwg3vuv/J/K1NDBeOYQdm3NFA/Gmv41SB6JYPSiccncwVLL35TWWDXlk9fMrOagNyh2B/BGnTQH/KHKMfLVKVjJXlFX1iy09ktCS+u0RmDRKh7OJb5x09HdnAyyv65rkKYx1qWKuKU3H8YcCLo63Cqq5fFG9eYm/mCerADjKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497120; c=relaxed/simple;
	bh=VposaqrpJo+TSPtl9DHlWRGCWeRo3r1lv1DS5n+WIFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyZcTowhEhtHhkmiZUWfSnbF+T4cVt6LACh/d3HsCCat+xiS0R1nX4tYoXMTly/Org1c2iFxY94Posm2gJi6gdPxeCpCE8z2oKKcnoo8jTSD3ef1zJUYxo5LwXbIJKkFJzFjwq8gEm6o5v48urJZxd+rfJS1CoCNvuhveOtliq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbuEDlwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbuEDlwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C5EC19423;
	Thu, 15 Jan 2026 17:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497120;
	bh=VposaqrpJo+TSPtl9DHlWRGCWeRo3r1lv1DS5n+WIFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbuEDlwllV5Ogoa4HFMT70eZr/caAl5yKTZDUagxTX3Xng53zRM2NUkUvZ2X7woHt
	 2a8l4PBGchUaYloYoqwOZ9iZyTTGiYiYrFF9Fot6cNaAb5SJ0sIx9SDCjflTQQkq/0
	 qeroAslLlBnqB2w1pwFy9nMaBLyQCuG+rnVGuF8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 43/72] net: wwan: iosm: Fix memory leak in ipc_mux_deinit()
Date: Thu, 15 Jan 2026 17:48:53 +0100
Message-ID: <20260115164145.056413568@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 92e6e0a87f6860a4710f9494f8c704d498ae60f8 ]

Commit 1f52d7b62285 ("net: wwan: iosm: Enable M.2 7360 WWAN card support")
allocated memory for pp_qlt in ipc_mux_init() but did not free it in
ipc_mux_deinit(). This results in a memory leak when the driver is
unloaded.

Free the allocated memory in ipc_mux_deinit() to fix the leak.

Fixes: 1f52d7b62285 ("net: wwan: iosm: Enable M.2 7360 WWAN card support")
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20251230071853.1062223-1-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_mux.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux.c b/drivers/net/wwan/iosm/iosm_ipc_mux.c
index fc928b298a984..b846889fcb099 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux.c
@@ -456,6 +456,7 @@ void ipc_mux_deinit(struct iosm_mux *ipc_mux)
 	struct sk_buff_head *free_list;
 	union mux_msg mux_msg;
 	struct sk_buff *skb;
+	int i;
 
 	if (!ipc_mux->initialized)
 		return;
@@ -479,5 +480,10 @@ void ipc_mux_deinit(struct iosm_mux *ipc_mux)
 		ipc_mux->channel->dl_pipe.is_open = false;
 	}
 
+	if (ipc_mux->protocol != MUX_LITE) {
+		for (i = 0; i < IPC_MEM_MUX_IP_SESSION_ENTRIES; i++)
+			kfree(ipc_mux->ul_adb.pp_qlt[i]);
+	}
+
 	kfree(ipc_mux);
 }
-- 
2.51.0



