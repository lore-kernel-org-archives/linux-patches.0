Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054715;
	b=LwWJzjG/u5ZSH4H05amYXJIHCoDqEFlKN4pERZURHUNNBk9b7h6IHGW3DGQBs/sfTXUC
	 h7Q8WQWm2uQduF9mghZK+4t768uXUKkbdWM18VLwCsqstsYnDzJt6t0dg6W+/kgJTbB7u
	 5VV6eQN7AbwL5HDisDoUmEG03oQMtQgv808I/B4Dxmq2PW/YzCwwaA2RDfNQUcfD/aJyn
	 fIuM8L3gdqTt7s35I6sjxjiwrMpynLB1mMDGLf9oFWd/RQMO+q5lvWLV94IdhycpYpDz6
	 uUsAlfttAPzzTl7UQCAZkUaA1iZxp5XH/2V43FH6wzlD4Dtf0fZxE8l39wRwNDK1Xug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tofDP7l7T+Mgtc9MzbNbCHqlEvrP1Rpop14rwwJua5c=;
	b=lIgt60ISeI3uYAvg5j8zap+HBvV3udzGKiuxnfqc8cbf5de9g7p41lm4lB4Dz04qNODb
	 shLMgBcJMg2XHY8yON4MEgu5vZigOeR87Wi82yce038A/DzvOwScvlrGjWDxbHlayhtRS
	 ZMbpvKeSl5fHuEkdrr5Myr8BdKFu5kzg5hqJmRUL/F0tZbKn3IKFoNUv6jisDJ+TFDk06
	 8P9eFvir6HTcrvr6KEivKVfyhhhwgAmt6075GK4V4+gm47FT48azaAQK5C62P1lvi73y7
	 WUrFAhsgsBMdMGvGxMKQeZ/1g1DfgjYCFfEvglB1fcneDPBXYabzAqwdAZsGkUMjzrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yko727Nd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D125606A320;
	Thu, 19 Nov 2026 02:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yko727Nd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B441F000C4;
	Thu, 19 Nov 2026 02:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054715;
	bh=tofDP7l7T+Mgtc9MzbNbCHqlEvrP1Rpop14rwwJua5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yko727NdNyiGEgSIuFQP7KFw4TaMpLqvNrSfxnTA5O2vT7nCHP1hCHfRL8YUv51HH
	 nC/CUqgatuj0XiGCioxlKkgSbdpH2Kfzik9BhQD4RFDH2hTVCmFqwduZbbvpLMAZhp
	 7fI+gZwvEVLjR0bmlDnppKWt6xKWO6TxEC1Bc0Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1371/2214] microblaze: CCF: fix refcount leak
Date: Wed, 18 Nov 2026 15:50:47 +0100
Message-ID: <20261118150106.266199031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander A. Klimov <grandmaster@al2klimov.de>

[ Upstream commit aeedf85beac51c7cd8f7bf4c918a0104dfdb8b78 ]

Every value returned from of_clk_get() is supposed to be cleaned up
via clk_put() once not needed anymore.

Fixes: c1120542b99a ("microblaze: Add support for CCF")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Link: https://patch.msgid.link/20260526184105.18962-4-grandmaster@al2klimov.de
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/cpu/cpuinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/microblaze/kernel/cpu/cpuinfo.c b/arch/microblaze/kernel/cpu/cpuinfo.c
index cd9b4450763b0..32c508e85408a 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo.c
@@ -133,6 +133,7 @@ void __init setup_cpuinfo_clk(void)
 		cpuinfo.cpu_clock_freq = fcpu(cpu, "timebase-frequency");
 	} else {
 		cpuinfo.cpu_clock_freq = clk_get_rate(clk);
+		clk_put(clk);
 	}
 
 	if (!cpuinfo.cpu_clock_freq) {
-- 
2.53.0



