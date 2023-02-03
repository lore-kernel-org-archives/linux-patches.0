Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE941FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4A3C433EF;
	Fri,  3 Feb 2023 10:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419746;
	bh=SGhr37+TV6G0LvjAGKsSRgYYqvpyCDZRUG+oipTEypM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukEfSm1tfsA3xFZjSIqV8m0fT6GAOgi3qmxhjDm9hOh2iV5ElUs4L3rDDE2LOH5oL
	 TSMzcMDv4xXPCTWJMdIWR3TdafQe7fIDsGERUUgjsECotNukqtFKhQaAyp0HQVNWGr
	 aHCuopzYPMoosVpqSqO19YvMmibFsg5rgb5mihss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/28] nvme-apple: only reset the controller when RTKit is running
Date: Fri,  3 Feb 2023 11:13:11 +0100
Message-Id: <20230203101010.958075281@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Janne Grunau <j@jannau.net>

[ Upstream commit c0a4a1eafbd48e02829045bba3e6163c03037276 ]

NVMe controller register access hangs indefinitely when the co-processor
is not running. A missed reset is preferable over a hanging thread since
it could be recoverable.

Signed-off-by: Janne Grunau <j@jannau.net>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index ff8b083dc5c6..262d2b60ac6d 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -987,11 +987,11 @@ static void apple_nvme_reset_work(struct work_struct *work)
 		goto out;
 	}
 
-	if (anv->ctrl.ctrl_config & NVME_CC_ENABLE)
-		apple_nvme_disable(anv, false);
-
 	/* RTKit must be shut down cleanly for the (soft)-reset to work */
 	if (apple_rtkit_is_running(anv->rtk)) {
+		/* reset the controller if it is enabled */
+		if (anv->ctrl.ctrl_config & NVME_CC_ENABLE)
+			apple_nvme_disable(anv, false);
 		dev_dbg(anv->dev, "Trying to shut down RTKit before reset.");
 		ret = apple_rtkit_shutdown(anv->rtk);
 		if (ret)
-- 
2.39.0



