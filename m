Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9B41DB92A;
	Tue, 12 Aug 2025 18:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023738; cv=none; b=TAyQjCCMYjkFxZUgoSV83Hk/JC61k+CYuHMHVbRwGhnqzQm3ChqaTeLEqmW5mTz88G5GL1Iv8ulD2ZLiu87H/o3FQ/iPEFwHjZn2WFYaVxQOiH7WNQK4rb5ECv+4E/We1R3lq0gxdAdXY7JkynG7SvrVNC8Aigdn/wrb9TQ0XS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023738; c=relaxed/simple;
	bh=LU5UFFzwhlFkSP6QpU6WE0QbtpV3K7KA85Cu5QQh/io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAJmpJT3RS9qBz6+d83+nsiZFIcmoaWNR1yvZ12lirKbiAglL9XMUTI9h9bYUddZuycbIjl6Mz/9DaF090E8mhLExp4xikj9kRhHlqXZq97nd9WC+aFRvQDkV01RO32eOZ1L+lHFcf6IRVzZsW0J9Sv7M6nO8psmkffJGC2GdEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0np2rtK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0np2rtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD128C4CEF0;
	Tue, 12 Aug 2025 18:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023738;
	bh=LU5UFFzwhlFkSP6QpU6WE0QbtpV3K7KA85Cu5QQh/io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0np2rtKBU1tDFMPel6xwjp61/qA2PEonXW3iR3JWkGbx4xRG3jg1o8zIluhXeRd8
	 kySwh5Gn79wOupRx3AeH0ykzNQKmfq1b1wb01grpL47J6RELrGEO0TX4n+wm2tfd0p
	 DYP90LuR+cGu2UzGq9KedDOPH76dBe/G3ihsA2ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 166/627] wifi: iwlwifi: Fix memory leak in iwl_mvm_init()
Date: Tue, 12 Aug 2025 19:27:41 +0200
Message-ID: <20250812173425.602015842@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index a2dc5c3b0596..1c05a3d8e424 100644
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



