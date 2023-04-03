Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881046FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDABC433EF;
	Mon,  3 Apr 2023 14:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533276;
	bh=noVZb804vuPDQVTQr3X92/tFr/DAUTuTMhxnNHqblGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAQ1//z2eApyTLs1oQkAIaifiNB5vXmq1e5pDQG8ghtgjErqjTkno3BMjl6qFC/w4
	 NHz5JoozfUd94DerKb6tsx6knnesZFSapxXLpVU3WCxtJYv5Tzh/daGvikWW4myNIG
	 28GP4Yj0qa3QZ9Fzsy68lvcLfo5p4/HkzcxBeH7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SongJingyi <u201912584@hust.edu.cn>,
	Dan Carpenter <error27@gmail.com>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 082/187] ptp_qoriq: fix memory leak in probe()
Date: Mon,  3 Apr 2023 16:08:47 +0200
Message-Id: <20230403140418.656990984@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: SongJingyi <u201912584@hust.edu.cn>

[ Upstream commit f33642224e38d7e0d59336e10e7b4e370b1c4506 ]

Smatch complains that:
drivers/ptp/ptp_qoriq.c ptp_qoriq_probe()
warn: 'base' from ioremap() not released.

Fix this by revising the parameter from 'ptp_qoriq->base' to 'base'.
This is only a bug if ptp_qoriq_init() returns on the
first -ENODEV error path.
For other error paths ptp_qoriq->base and base are the same.
And this change makes the code more readable.

Fixes: 7f4399ba405b ("ptp_qoriq: fix NULL access if ptp dt node missing")
Signed-off-by: SongJingyi <u201912584@hust.edu.cn>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/r/20230324031406.1895159-1-u201912584@hust.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_qoriq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index 08f4cf0ad9e3c..8fa9772acf79b 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -601,7 +601,7 @@ static int ptp_qoriq_probe(struct platform_device *dev)
 	return 0;
 
 no_clock:
-	iounmap(ptp_qoriq->base);
+	iounmap(base);
 no_ioremap:
 	release_resource(ptp_qoriq->rsrc);
 no_resource:
-- 
2.39.2



