Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C952222B2;
	Mon, 23 Jun 2025 22:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717378; cv=none; b=q9eFybd27JKwON42lCye8WLfA6UnMTWhs6xDqGw0sz5P2tUZrENtYw+xUG3fPH97cp1X9oZZfExyYVN4ku5q4a5DboUzVRYCDzUI9T+4v7Co5WMzRhIkKVg3AwOa8ZcIYiOqzg5zZQ6SodAiITgDQvzM2M0cFiONG/7UlKHVmYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717378; c=relaxed/simple;
	bh=FqxunXoLGfdBi5jdFp2mm7kPm8DMpd+uNXdpLc2DkVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHFlC2w+z8Xto78ffg++C75ZUmqVzGRAzzdBUYg6xXsH9eiddx29fPvxVGSrPkpXjc/7zu06iac5TyaLgjxa465M+Hm2zjfuY6hjcfyHOAdkaNzZ/YRfA8LwjHVNYQwrEdnqC2sHcV8yKmZZjctMZtIOJhSk4PfPQnwsqOXoa8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NKBrWeC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NKBrWeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345BAC4CEEA;
	Mon, 23 Jun 2025 22:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717377;
	bh=FqxunXoLGfdBi5jdFp2mm7kPm8DMpd+uNXdpLc2DkVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NKBrWeCuiSFe9kyH4u8hJ1jJdw36P+OQm09cvB/iPTEyt49tTKJzbSWAiEkkExvh
	 BurDxiYllWRuZB3qRO+W9wCFc35R15n8NeWX4vefavIBcOnXy1xHNJ5lYeDPho09pq
	 KmPMD22CtpmviAyB0sden/fxNErSFVMLaaO1reFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 358/414] ionic: Prevent driver/fw getting out of sync on devcmd(s)
Date: Mon, 23 Jun 2025 15:08:15 +0200
Message-ID: <20250623130650.918314021@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0f817c3f92d82..533df5993048f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -515,9 +515,9 @@ static int __ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds,
 	unsigned long start_time;
 	unsigned long max_wait;
 	unsigned long duration;
-	int done = 0;
 	bool fw_up;
 	int opcode;
+	bool done;
 	int err;
 
 	/* Wait for dev cmd to complete, retrying if we get EAGAIN,
@@ -525,6 +525,7 @@ static int __ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds,
 	 */
 	max_wait = jiffies + (max_seconds * HZ);
 try_again:
+	done = false;
 	opcode = idev->opcode;
 	start_time = jiffies;
 	for (fw_up = ionic_is_fw_running(idev);
-- 
2.39.5



