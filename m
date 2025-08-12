Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C0C2868AF;
	Tue, 12 Aug 2025 17:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021077; cv=none; b=q9v5IKrrt4o+gCWXGqOu8037bYClrcQ4dLn1HYnJCTe9VqxyfWQDYDg5dpF2jtMFXqlUSVy3thmI25ckgL+XvkRNDltcrdznAI0VzKyqMXS8f5D+aPw2Zg12BvGJ0XX/vKk7qoWjFReP2VGdrkSEPjWZ6IGquUhwXlwJ0CxsGJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021077; c=relaxed/simple;
	bh=fHASWCmMh0tyxsTf8XbZhsrmWp6dnCfCX41cxvSvSeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftglIUaR5hswbF6+TVwkMxayoBFboP+svCfAGhJ0b3j3pf06NVPbXGAPx2H8nj+toHQZVoIS4d/gpvPTIso8Tj4tvzBklYoifeS+/rXxJJa5NjANU1LNmuV3+4Bsx58tVpkna9zRBopgzWZUydXNv19sTNOOd5jNVYCWV5XocqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdFENiIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdFENiIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF18C4CEF0;
	Tue, 12 Aug 2025 17:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021077;
	bh=fHASWCmMh0tyxsTf8XbZhsrmWp6dnCfCX41cxvSvSeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdFENiIt1RE825ceWOiKABnVOJ9QeELDpjbs8gRMo//WI1gVoqPykzWmLXSkbLIiG
	 5y8oiybngNLLszLZY6ofFXwIfwHjGXGsynPeqamY/s+IrK3p4TR36PxRmyBf/IkTvC
	 IMwXFURFloPc+3iNLyrxxQkaqch4MX2BTbGwiNX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/262] wifi: iwlwifi: Fix memory leak in iwl_mvm_init()
Date: Tue, 12 Aug 2025 19:27:26 +0200
Message-ID: <20250812172955.456377686@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b2cf5aeff7e3..d2dbbc9fe384 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -65,8 +65,10 @@ static int __init iwl_mvm_init(void)
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



