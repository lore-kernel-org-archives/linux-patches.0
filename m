Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905976FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D91C433D2;
	Mon, 16 Jan 2023 16:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887868;
	bh=2znVnBPnMrHx8pSuHlGBxMWHuS+26idcVnJSa3Rouhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCYYVVtkcELjCPYz7+QdjXYFECCyf4yVPxdNpyLA6ocyTXdVzcXiVIbJD4yaeAXPB
	 ejbEEv3PPUhIS6yne4ZEfuS1RiKhuzCJ3xDnMEeRu3FU8Tp4ue0r4HScoh4aNLm/Yv
	 32gUFUs7d3KFc3mnJ39NIDpMkgao4q7LfQi4PVgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 295/521] powerpc/pseries/eeh: use correct API for error log size
Date: Mon, 16 Jan 2023 16:49:17 +0100
Message-Id: <20230116154900.321184402@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 9aafbfa5f57a4b75bafd3bed0191e8429c5fa618 ]

rtas-error-log-max is not the name of an RTAS function, so rtas_token()
is not the appropriate API for retrieving its value. We already have
rtas_get_error_log_max() which returns a sensible value if the property
is absent for any reason, so use that instead.

Fixes: 8d633291b4fc ("powerpc/eeh: pseries platform EEH error log retrieval")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
[mpe: Drop no-longer possible error handling as noticed by ajd]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221118150751.469393-6-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/eeh_pseries.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index f56248f19ef3..b7160120c0bb 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -946,16 +946,7 @@ static int __init eeh_pseries_init(void)
 	}
 
 	/* Initialize error log size */
-	eeh_error_buf_size = rtas_token("rtas-error-log-max");
-	if (eeh_error_buf_size == RTAS_UNKNOWN_SERVICE) {
-		pr_info("%s: unknown EEH error log size\n",
-			__func__);
-		eeh_error_buf_size = 1024;
-	} else if (eeh_error_buf_size > RTAS_ERROR_LOG_MAX) {
-		pr_info("%s: EEH error log size %d exceeds the maximal %d\n",
-			__func__, eeh_error_buf_size, RTAS_ERROR_LOG_MAX);
-		eeh_error_buf_size = RTAS_ERROR_LOG_MAX;
-	}
+	eeh_error_buf_size = rtas_get_error_log_max();
 
 	/* Set EEH probe mode */
 	eeh_add_flag(EEH_PROBE_MODE_DEVTREE | EEH_ENABLE_IO_FOR_LOG);
-- 
2.35.1



