Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61CB27781E;
	Tue, 12 Aug 2025 19:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025711; cv=none; b=iNaWXk4Sxt3wGiNutJ15hO1tmDkHxUEQpHfc+RTZA9KFSot+v4slQ8EETXl8z7Y4qu4uBDvgNozrR4MOWthFTd+qgsdN5OpkhB+UZnB3Op3J8b92r1eGVrDRbnqP0waDtypH3/Y5ZFg8aBi3chbLwG/JfAGRF4zNsk6QRFtmmSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025711; c=relaxed/simple;
	bh=xngX3FRdOd1aS3QrmhLumidbV6aQrMsubxHBlKPzems=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAizmwgENcfy2WJfp9Ad82uHKs22aCTomasP+GNFS4r/1mgYl9grBf7bvg77MhKMEOtdc2mvrFOTvPo9yLIReJeGVDqo0QYq+iGaNF2oQ8mmd6u1DihVb5QllYMO5G0ApPOP5haxxSgGzC/mhfXw8syj3iOvt3h0DnLiAFWWYfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDzdB3sq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDzdB3sq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48525C4CEF0;
	Tue, 12 Aug 2025 19:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025710;
	bh=xngX3FRdOd1aS3QrmhLumidbV6aQrMsubxHBlKPzems=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDzdB3sqNPBGLP/KYV+K3gkG+3PPh7JNvZLPkjG38WNl1mYPN3/fHSRJPTUbjfKNN
	 eLj/WtP2o6XARKjt0m+K5DEOWVOJmKnbulYR6AJw/WqSZ3rR8I2RZ1sciuGBhuxsro
	 Wg0E3KUn5RKF6RmWRtBhXqbod4fEDLyrpsPjHEY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 122/480] wifi: iwlwifi: Fix memory leak in iwl_mvm_init()
Date: Tue, 12 Aug 2025 19:45:30 +0200
Message-ID: <20250812174402.559643124@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 76603ef02704..15617cad967f 100644
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



