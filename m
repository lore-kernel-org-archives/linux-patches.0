Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F8E223335;
	Tue, 26 Aug 2025 14:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217340; cv=none; b=gqoMvgg8ItCwO5pT0w4DFztdRLnpT1cc9ErQvLgpSxmK2y9fTE3GaD4oaqPgItTm0bTuPIRTA4SzgdqoCucUfztSbxNjFeBOtypnH+06kM5WsolIFrCI0rPHkP//EuwBQ/xJY6twYCBPNUiyNmzbBkhj0XoFZEBJ1z3My1H6guc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217340; c=relaxed/simple;
	bh=GKPS+JdvbQcz14xq8aFh5DNxBhOS+a/pg02RAoEmMDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJqbRQZ5VJ6qaCetOOWstJqMD42dYVIRRG5sSOmfCjcg27+MSllVbfkWEImb/5eOB4F/HLsGD4KP6ysb0v4HIdC4QixSlpZ1NkV6IMCFtd/1czr+jHSdRzcc9Pg2UJHlHMEUitiGqghZSUngpt7S2uXxPqS1FO+CG3K5fR9dFcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3uMUWNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3uMUWNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA83C4CEF1;
	Tue, 26 Aug 2025 14:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217340;
	bh=GKPS+JdvbQcz14xq8aFh5DNxBhOS+a/pg02RAoEmMDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3uMUWNg37qMypUsppvATvU5ycFsFqApJJrpSuVKIb4GM8mOg9NY65WEfXUeneUPW
	 YHjznX4s5Yxc+rtn1hoxkLgSjCgbEW2HFKWBGRCzNGyXIxnkSItxhMi17x6uY5q5uM
	 cFJKgoJTyreI8aaupe2/sdzIcDpKPLLidReQWhl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/523] wifi: iwlwifi: Fix memory leak in iwl_mvm_init()
Date: Tue, 26 Aug 2025 13:05:09 +0200
Message-ID: <20250826110926.981744579@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9b1a1455a7d5..1f14636d6a3a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -116,8 +116,10 @@ static int __init iwl_mvm_init(void)
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



