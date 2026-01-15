Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BAE2D5C9B;
	Thu, 15 Jan 2026 17:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496907; cv=none; b=ln7uNws//nlbGhp2qqDDtSo9fqCWqsXc1Y+yigTlnnDShGrNCl8z4MJrGA9sWaI6ws0/0nLjtiDqrLg3/J2Kix7GkoAXF/Ej0BnrWitkFw2g98qnthfrCOw5TD05llFv/N1eD6zN9sHALZuFufBJgbybG9PkEqt4EvnryS2FlAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496907; c=relaxed/simple;
	bh=6gN1XKF5iEgm729SACStsqa5XK6CIf65cwmUTBog+VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1mf9scyjxNBH23cDK6p1oc9e8g0ShQhPBgIxNRF3Agy/0fmAUm/L7mONMAeRm4skKmYeKD0fBsdHSAfL/eZ8bFa2WAS0UtOQuxtQeJdVRAAtso8Mcbp/kCek63lTjAJ8DaDP6bPWL6PbNdr+3fAvlDcJAV+akhTB273j42TD/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mR8XVp7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mR8XVp7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E037C116D0;
	Thu, 15 Jan 2026 17:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496906;
	bh=6gN1XKF5iEgm729SACStsqa5XK6CIf65cwmUTBog+VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mR8XVp7nIdz26E5j3g31sLpZWNm4fWZyjfTp0oj2n5UYZ89JBhJrIWiS4hEvx1CUE
	 wy35J7t1Q15rAE0FtrnL7ODBEemtevlDm1hzGEy3LMzOTzpLpLIurPMzpVj0pwmi4b
	 cv5pPkBTEo3H1D4YV5B2EBuojRIHcw2Az5zyaaUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 57/88] net: wwan: iosm: Fix memory leak in ipc_mux_deinit()
Date: Thu, 15 Jan 2026 17:48:40 +0100
Message-ID: <20260115164148.376540960@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



