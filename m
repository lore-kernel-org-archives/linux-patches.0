Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7ED8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE28C433D2;
	Fri, 10 Mar 2023 14:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457092;
	bh=BtpRRmAwmp+wle9T2F+1zMPKEBYiOKFCztRZkmdwxY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpEtaUIDpI6Tm9Jl3Fs5kLksJNO0Lt8Gw5qm9nrqvMsq5hZp9KjEAf9m79u9cvdji
	 7xzMMeBg2sz39me3ljhCwB7lyMSNytDLGaHPwGXIiqF4ngNESdl8N+XDVoS7Hglxrh
	 VQtZcRiGd1JZ+G+gSN9t045gRV9flMCrjWnQIw0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Lu <roger.lu@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/200] soc: mediatek: mtk-svs: reset svs when svs_resume() fail
Date: Fri, 10 Mar 2023 14:37:05 +0100
Message-Id: <20230310133717.600518803@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roger Lu <roger.lu@mediatek.com>

[ Upstream commit f4f8ad204a15d57c1a3e8ea7eca62157b44cbf59 ]

Add svs reset when svs_resume() fail.

Fixes: a825d72f74a3 ("soc: mediatek: fix missing clk_disable_unprepare() on err in svs_resume()")
Signed-off-by: Roger Lu <roger.lu@mediatek.com>
Link: https://lore.kernel.org/r/20230111074528.29354-3-roger.lu@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-svs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index 9859e6cf6b8f9..e0b8aa75c84b6 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -1614,12 +1614,16 @@ static int svs_resume(struct device *dev)
 
 	ret = svs_init02(svsp);
 	if (ret)
-		goto out_of_resume;
+		goto svs_resume_reset_assert;
 
 	svs_mon_mode(svsp);
 
 	return 0;
 
+svs_resume_reset_assert:
+	dev_err(svsp->dev, "assert reset: %d\n",
+		reset_control_assert(svsp->rst));
+
 out_of_resume:
 	clk_disable_unprepare(svsp->main_clk);
 	return ret;
-- 
2.39.2



