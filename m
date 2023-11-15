Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD54171CE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8evZ7SM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CA3C433CB;
	Wed, 15 Nov 2023 20:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081867;
	bh=B0PRmg26orsCMJ7IPVDgtTTqCDPIllqZMI/6Tm+dwU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8evZ7SMzYSHlRUiPanaZohs49BT/MIN+wr3IMfkT7/fI6VX0aKifhTnib58oFqT3
	 mZXzOm+Y0KXq/k9FtAq/ydDQTJYGFoBehp0tZVNG3CB0o9P4dur4VrpNge5BFMA5BH
	 s1cCHIVFSl/Grq5tegzWdDuB6yWakKhCDDCqeWCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/191] net/smc: put sk reference if close work was canceled
Date: Wed, 15 Nov 2023 15:47:31 -0500
Message-ID: <20231115204655.002024108@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit aa96fbd6d78d9770323b21e2c92bd38821be8852 ]

Note that we always hold a reference to sock when attempting
to submit close_work. Therefore, if we have successfully
canceled close_work from pending, we MUST release that reference
to avoid potential leaks.

Fixes: 42bfba9eaa33 ("net/smc: immediate termination for SMCD link groups")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_close.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 0790cac9ae3ee..bcd3ea894555d 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -113,7 +113,8 @@ static void smc_close_cancel_work(struct smc_sock *smc)
 	struct sock *sk = &smc->sk;
 
 	release_sock(sk);
-	cancel_work_sync(&smc->conn.close_work);
+	if (cancel_work_sync(&smc->conn.close_work))
+		sock_put(sk);
 	cancel_delayed_work_sync(&smc->conn.tx_work);
 	lock_sock(sk);
 }
-- 
2.42.0



