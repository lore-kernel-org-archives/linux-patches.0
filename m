Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC71569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDF3C433D2;
	Sun, 28 May 2023 19:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302326;
	bh=bxaHnaQZItMC+Gq94XHcrr8I2j9jtglZ0GuJj8ia62Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xV/z7JVWJBUiVVIdbkdJcgp6y8LXnm76lLP3rPvzkMcQ92Udef+SDPZgazJa2W1zn
	 cHvQ0pSfsB5BzNo+wnS42kGW3n88IO33B+kYX6WHrMdDiQoFNPbPa2xKSULV7sdGuj
	 HEGjj8fT9XCCy+n2NAwBK01GZfqc10is5HMCXcFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Etienne Carriere <etienne.carriere@linaro.org>,
	Sumit Garg <sumit.garg@linaro.org>,
	Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 6.3 089/127] optee: fix uninited async notif value
Date: Sun, 28 May 2023 20:11:05 +0100
Message-Id: <20230528190839.224761417@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
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
 drivers/tee/optee/smc_abi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tee/optee/smc_abi.c
+++ b/drivers/tee/optee/smc_abi.c
@@ -984,8 +984,10 @@ static u32 get_async_notif_value(optee_i
 
 	invoke_fn(OPTEE_SMC_GET_ASYNC_NOTIF_VALUE, 0, 0, 0, 0, 0, 0, 0, &res);
 
-	if (res.a0)
+	if (res.a0) {
+		*value_valid = false;
 		return 0;
+	}
 	*value_valid = (res.a2 & OPTEE_SMC_ASYNC_NOTIF_VALUE_VALID);
 	*value_pending = (res.a2 & OPTEE_SMC_ASYNC_NOTIF_VALUE_PENDING);
 	return res.a1;


