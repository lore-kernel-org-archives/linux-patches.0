Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E013FB1B;
	Mon, 23 Jun 2025 21:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715858; cv=none; b=FdpIQW2f098j57TmtDd0MVb/r6WgmBUoXINl9hVLFWak9u8xrEA5iQ5h6fviRa3AGVatHqDz55xgDYF8XySnJYWyFf+85deeE3Yy3YxjXw+oiV7kJ4++YN3B1mGydG3xNy0VHHt36YmYTmIi0jjSBQX199O+keSOYloBdPlmzuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715858; c=relaxed/simple;
	bh=g+npIdFhLzKX4lCG6y3wUhqZ7pLKtCMUCxtBBL4Tbj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9osNO11MvbHgsoDM0/JoUilxgWxhy6GqkIxFERShNx/r40VdgOQw5Az60etWo4GZGqIHHSBCDyUG/kWcg7run1g+9k3czpC/3+ofAQ5Qe88dziA/QqMD8ukXpAFkXVlQImGJEz6HAZiTx+6nwjhAou2wTloTEbo9a9iwSnawEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcADnLHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcADnLHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5DCC4CEEA;
	Mon, 23 Jun 2025 21:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715858;
	bh=g+npIdFhLzKX4lCG6y3wUhqZ7pLKtCMUCxtBBL4Tbj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcADnLHunz8O0dc4encM+q20C/4gCDfEw3myv9kzdlB6h7gk8IwqnXdgJCIiFZAZ4
	 p+VFCsOFhwQ9muFH8NPVDKHruf44G3pg71xfFNKsrMm1F8j9N0EcW/3V+9Q8M7CTen
	 qfSYcFEHa2y9chsJ4tZc00IJlY17KhHrRhCXZZ0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 246/290] ionic: Prevent driver/fw getting out of sync on devcmd(s)
Date: Mon, 23 Jun 2025 15:08:27 +0200
Message-ID: <20250623130634.325639620@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3ca6893d1bf26..2869922cffe2e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -464,9 +464,9 @@ static int __ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds,
 	unsigned long start_time;
 	unsigned long max_wait;
 	unsigned long duration;
-	int done = 0;
 	bool fw_up;
 	int opcode;
+	bool done;
 	int err;
 
 	/* Wait for dev cmd to complete, retrying if we get EAGAIN,
@@ -474,6 +474,7 @@ static int __ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds,
 	 */
 	max_wait = jiffies + (max_seconds * HZ);
 try_again:
+	done = false;
 	opcode = idev->opcode;
 	start_time = jiffies;
 	for (fw_up = ionic_is_fw_running(idev);
-- 
2.39.5



