Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205D046B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E51C433EF;
	Mon, 16 Jan 2023 16:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886272;
	bh=ySGjcKMG+4IFCEuDi1FhhCS9CQLTHk4jVbLmKtd9nks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKe9GImNvV3gZ2/OIaWow7pv/FlC1jREdl9emUbUBi2S5DZEfxjNd60kR6qiICwnM
	 GGyY89eL7l+UteuVxokOJr26FpGS51beY5kjdYx0x+CDhLKARk/bR0K1aU/UceYiwJ
	 enYRMb0YG2mouzybdfJA7fNc1nzLTny5FPfPsaZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 367/658] powerpc/pseries/eeh: use correct API for error log size
Date: Mon, 16 Jan 2023 16:47:35 +0100
Message-Id: <20230116154926.377282762@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 7e36c617282f..33c1dd7ee432 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -868,16 +868,7 @@ static int __init eeh_pseries_init(void)
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



