Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614A9396B75;
	Thu, 15 Jan 2026 16:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496234; cv=none; b=Gq0Xlf3kjBA/liArilqZo7b6Mh1WvuwGMYK+KIz01+dQ3Rs166Ro6wWMThryltXorl0kfAo3Pikw6IpygLz0LHIQ8TyMmrNyPotdKHe2MfUfVgJRFqnHOiqyRqrxHvA1FiEclSVVbveUvbFrLJzT7alC5FAPgIpOF7sPuPAuZOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496234; c=relaxed/simple;
	bh=jnHN5dckhkJPeQxHocYi0Mt0g3xo8SiSTkwwq+YcN1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnQCB5FwOgdKILV1wP8XYqunqlYKIM5pFk5ihdDCWCA2kFwskbJWN7WMxFQge+XLAeD/39ifCSoFnd1GhTKw5XLexfHOZoJbBC+M2jsZcJ3GBX+srcvb8dSD4HQbVzNuY04+UqeyYzTAKiMt2rHG3fConCqGUDgWLhkzjiGzFP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hZBn3Lg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hZBn3Lg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1D2C116D0;
	Thu, 15 Jan 2026 16:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496234;
	bh=jnHN5dckhkJPeQxHocYi0Mt0g3xo8SiSTkwwq+YcN1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hZBn3Lg1LKbomOkKkDqrW7dQm4APkktzY6f3s6Nte0lnmCLf6C8AVB6htBw19wr5
	 RsLBa1EvZM0JRO3K4/Q5hf5Cp12gVm9joGXtnpOVhMQ4RV0DBxUqfBmd3jmQBm4CKR
	 wkycRhWpyV+eJ80F1duimlpf2+uHjrJfGJ6LoqGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/181] net: wwan: iosm: Fix memory leak in ipc_mux_deinit()
Date: Thu, 15 Jan 2026 17:47:24 +0100
Message-ID: <20260115164206.181218384@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



