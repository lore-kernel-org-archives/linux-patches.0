Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2949118FC91;
	Tue, 12 Aug 2025 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022192; cv=none; b=kmEyPPol6UQhc60KNo29X85125/wMJdzTXurCSctB4mciPyAE708gASFcZuLpWE7X2I9IlQI1RuFur1RKibwyKpNXFW5xDM3vekvrbvVLFECg2XEPDj7azbArNCttVffv9tibBaXRP4WzokD7dp8tXolCzXWhf7qRsn5UePJ39k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022192; c=relaxed/simple;
	bh=fD79+C5/pjqtePigLl/FhLaPFGpQCTUNZ76mCS1U94s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2v11qogBlLmmopYIJil24YumU7Z9eXvMCj6pidQ/VTwjIWJEwYduE/NSA6dHtA6KHXm6MNI0I/ewoHOWRBHcZ55NOgTOQdDxxJPx0OPwu7lqmLNtyx4xtx9GgCYEAkri3FirIMC1q6OfjlzG9kzjtGEACtym18U7oZPJN4EkpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRAJVMDm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRAJVMDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708CFC4CEF0;
	Tue, 12 Aug 2025 18:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022191;
	bh=fD79+C5/pjqtePigLl/FhLaPFGpQCTUNZ76mCS1U94s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRAJVMDmkeQBx0O23sFeig1ZmXCJ3NLJGpDQCzvZTW2J5CPt4FzZTHOsxw7mhmsHK
	 p8YqGzlK/25/HSEWXNI3WwFIG1Sc5UNTE9KcoJNp+MpWWimiCcdjpEC6MQcDANdjZb
	 oyvt5zkbmhKJv/TgiW5bXzbgC9UkWcihO05oLZ2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/369] wifi: iwlwifi: Fix memory leak in iwl_mvm_init()
Date: Tue, 12 Aug 2025 19:26:20 +0200
Message-ID: <20250812173017.907085993@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4dd4a9d5c71f..a7dbc0a5ea84 100644
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



