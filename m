Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B922222B2;
	Mon, 23 Jun 2025 22:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717617; cv=none; b=GRoneaFiVd8JZ69kqa0Ljc2eziXUqbmT+28FX+ZLMtR5qulQnxytbvNWXd7rMmLWuqqL9LFIbVWyHR8kLI4IQmLGt2kDDjFGg2As/2UxrQygcnMz1DqX3txaREgej0lTfAgTyJjslz6ncz6groGwWY1W1fVuVGcBKu6aFmA1HB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717617; c=relaxed/simple;
	bh=AU12D7zBcHwyXlhoVe2L6sCZTUb+lUlHBvQSN1sy5ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqXGmbfJ7fh91OG5bFDT4tqwylAkgIxfV8MNqqPMjb1y1XnnPIGOfLhquj7oANCw+FiYN9BKNt/ezJZQVZCi+6gRx3NehwBaT2AlKejnlD47xfVYxUnAqyKt32c/WDxsrdKXPhprBTY1P3q/ewMIfExrKePEr/Y5ZuE2WhgqAdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSTujKu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSTujKu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77839C4CEED;
	Mon, 23 Jun 2025 22:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717616;
	bh=AU12D7zBcHwyXlhoVe2L6sCZTUb+lUlHBvQSN1sy5ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSTujKu0iqvV6Xog+0HWANzU50h1ZrhtXwc/72DTnfWJpg5aZMYNOahOKxFwJ+zoI
	 h5X2pkhM/b87Iwver1WdVO7t+Fm1+QU1TZPcnekIMmRIvHvTwn5ZHPatmyaCA3dyXt
	 HKgzAWy94Q6lgZhPo4fLAZoFzxjZMe6loUR/UUJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 472/508] ionic: Prevent driver/fw getting out of sync on devcmd(s)
Date: Mon, 23 Jun 2025 15:08:37 +0200
Message-ID: <20250623130656.706451905@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 5466491c9e3309ed5c7adbb8fad6e93fcc9a8fe9 ]

Some stress/negative firmware testing around devcmd(s) returning
EAGAIN found that the done bit could get out of sync in the
firmware when it wasn't cleared in a retry case.

While here, change the type of the local done variable to a bool
to match the return type from ionic_dev_cmd_done().

Fixes: ec8ee714736e ("ionic: stretch heartbeat detection")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250609212827.53842-1-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index d2038ff316ca5..16f96ed73909c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -461,9 +461,9 @@ static int __ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds,
 	unsigned long start_time;
 	unsigned long max_wait;
 	unsigned long duration;
-	int done = 0;
 	bool fw_up;
 	int opcode;
+	bool done;
 	int err;
 
 	/* Wait for dev cmd to complete, retrying if we get EAGAIN,
@@ -471,6 +471,7 @@ static int __ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds,
 	 */
 	max_wait = jiffies + (max_seconds * HZ);
 try_again:
+	done = false;
 	opcode = idev->opcode;
 	start_time = jiffies;
 	for (fw_up = ionic_is_fw_running(idev);
-- 
2.39.5



