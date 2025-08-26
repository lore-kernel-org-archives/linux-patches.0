Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D5728505C;
	Tue, 26 Aug 2025 13:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215721; cv=none; b=rjeopzG/rjjkukHZ7PBmJjIdcAp+c/IXMvEB8N1hThXmTb/4HrXcY+5gKJAhoAJ8yhVPN37fH1/f9yPKWtkduHKC1zUVw3A73/yQmSsFj7XKL++vxp8o4LehcVafVJ4pm107g5xZZAnBqMF3EO5lPeTAYYVFRCXCLSLxPb51gJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215721; c=relaxed/simple;
	bh=QGSkroNth1JJVQkw4tgWCoumyqSMQ2LvmPlPQFc9LV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ye8YX+Mgrqdz3ezpDDGJJuhN+Y7PTMrVetHVC19Lf9KqVQbw6MJ/pE+fXKI3f3zJ6Ck4tT22OmMiM73DwgDDGBMA3eAK3zmrEgrxYxn2JTWjww3HtOT96Pa+x0vk1LX4eUaI7HghO2is6Y7hLIFQwTVgJGT3q9xXQrIF92aIR/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13YEdzoT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13YEdzoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53919C16AAE;
	Tue, 26 Aug 2025 13:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215720;
	bh=QGSkroNth1JJVQkw4tgWCoumyqSMQ2LvmPlPQFc9LV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13YEdzoTjJACRI7sbKdLSPLhHUK9zYIVskeFDX166R9FiTDPCgMZAeU8h+WHbTR08
	 PgHN4eu97CygqT+wRt7DLOjaA3U4vdoMWggcpgmqTbwr73wCqV4ZkWYaWuHjK493/Y
	 9kQtL/oUnNbUKZEAXAOxRk/Hz7UlPB4hAGZqgb+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/644] wifi: iwlwifi: Fix memory leak in iwl_mvm_init()
Date: Tue, 26 Aug 2025 13:03:52 +0200
Message-ID: <20250826110949.991237010@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit ed2e916c890944633d6826dce267579334f63ea5 ]

When iwl_opmode_register() fails, it does not unregster rate control,
which will cause a memory leak issue, this patch fixes it.

Fixes: 9f66a397c877 ("iwlwifi: mvm: rs: add ops for the new rate scaling in the FW")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Link: https://patch.msgid.link/20221109035213.570-1-xiujianfeng@huawei.com
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index e2c244ceaf70..05e1a6de8c2e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -61,8 +61,10 @@ static int __init iwl_mvm_init(void)
 	}
 
 	ret = iwl_opmode_register("iwlmvm", &iwl_mvm_ops);
-	if (ret)
+	if (ret) {
 		pr_err("Unable to register MVM op_mode: %d\n", ret);
+		iwl_mvm_rate_control_unregister();
+	}
 
 	return ret;
 }
-- 
2.39.5



