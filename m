Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA8A611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C46AC4339B;
	Sun, 28 May 2023 19:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302638;
	bh=8s8AD71lfyyNrUM4xPKFaUP/3S4cqKW5UGyZAX6JCmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcQOPKXCS7+1Bw5oAzdG1ZHxfL7JRO39GHymk4B5oHyrxvVF7CF3iyuH+zB0OesiY
	 HM1B7+68qYol3Wh0CkXxxE/Gd5l4XXYl7grNdsCcRpTQ6LU1Z6c8zd4wwXaxrMJ5ht
	 MDGToWTrc39iIHbOuPQcRoiaVswKSeBc1Z243nzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Etienne Carriere <etienne.carriere@linaro.org>,
	Sumit Garg <sumit.garg@linaro.org>,
	Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 6.1 085/119] optee: fix uninited async notif value
Date: Sun, 28 May 2023 20:11:25 +0100
Message-Id: <20230528190838.369628545@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Etienne Carriere <etienne.carriere@linaro.org>

commit 654d0310007146fae87b0c1a68f81e53ad519b14 upstream.

Fixes an uninitialized variable in irq_handler() that could lead to
unpredictable behavior in case OP-TEE fails to handle SMC function ID
OPTEE_SMC_GET_ASYNC_NOTIF_VALUE. This change ensures that in that case
get_async_notif_value() properly reports there are no notification
event.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/202304200755.OoiuclDZ-lkp@intel.com/
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/all/d9b7f69b-c737-4cb3-8e74-79fe00c934f9@kili.mountain/
Fixes: 6749e69c4dad ("optee: add asynchronous notifications")
Signed-off-by: Etienne Carriere <etienne.carriere@linaro.org>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/optee/smc_abi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tee/optee/smc_abi.c b/drivers/tee/optee/smc_abi.c
index a1c1fa1a9c28..e6e0428f8e7b 100644
--- a/drivers/tee/optee/smc_abi.c
+++ b/drivers/tee/optee/smc_abi.c
@@ -984,8 +984,10 @@ static u32 get_async_notif_value(optee_invoke_fn *invoke_fn, bool *value_valid,
 
 	invoke_fn(OPTEE_SMC_GET_ASYNC_NOTIF_VALUE, 0, 0, 0, 0, 0, 0, 0, &res);
 
-	if (res.a0)
+	if (res.a0) {
+		*value_valid = false;
 		return 0;
+	}
 	*value_valid = (res.a2 & OPTEE_SMC_ASYNC_NOTIF_VALUE_VALID);
 	*value_pending = (res.a2 & OPTEE_SMC_ASYNC_NOTIF_VALUE_PENDING);
 	return res.a1;
-- 
2.40.1



