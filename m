Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EF9612E
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D7AC433EF;
	Mon,  3 Apr 2023 14:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531693;
	bh=wrhezHmLmCKjt4LuGcSQSpvYXsnUuqQcLgfeEZ4/JhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzdHtGSkncx25n/2eMTSvADzCUy6jIrglD5UEHT+ewsJkvG11q2BcTg3nxyPB6ivP
	 GoJx8qcscaIp/XqZq3d0gBEZFm/iCtRp0VcWWv3nCgqyF/Iysx3SvgHH/WqOWO/JSC
	 jstDWw0HJ1tK0yMpkvOItIsbcm9+CuviytlquIYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SongJingyi <u201912584@hust.edu.cn>,
	Dan Carpenter <error27@gmail.com>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/104] ptp_qoriq: fix memory leak in probe()
Date: Mon,  3 Apr 2023 16:09:08 +0200
Message-Id: <20230403140407.104429805@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
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
index a577218d1ab71..ca211feadb383 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -604,7 +604,7 @@ static int ptp_qoriq_probe(struct platform_device *dev)
 	return 0;
 
 no_clock:
-	iounmap(ptp_qoriq->base);
+	iounmap(base);
 no_ioremap:
 	release_resource(ptp_qoriq->rsrc);
 no_resource:
-- 
2.39.2



