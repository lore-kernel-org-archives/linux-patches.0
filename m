Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BF839FC0
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnP9xrHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A92C4E778;
	Wed, 15 Nov 2023 20:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081594;
	bh=szsIfclCFw+IISKdzDo/mzQExU3S8YV0yxkAiZiIBNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnP9xrHfBT8HFxMrmytjSLWjAgNi157qN1ud5iSFdiEUE+ei1KbAq96sIVUPgmJ29
	 x8SSu1OLj49ynUy/qV2dsVMaxnQYMJTUWsr4BGHujkC9aErEHHXv63fLRY8+WjAM6M
	 1xSzKehdiC5TTZBz+zmM8NtnaSJFXNdp85AFhFi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/244] net/smc: put sk reference if close work was canceled
Date: Wed, 15 Nov 2023 15:36:59 -0500
Message-ID: <20231115203601.968052154@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



