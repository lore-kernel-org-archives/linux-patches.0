Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F82A168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7197C433D2;
	Mon,  8 May 2023 10:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540382;
	bh=37Et6PbHvCGIsocBUxddF/q1eEzwLg/W60V58U66AO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dv+UAuiSCqJi1U9wJPztQy6pXCzFyPWo1fI2YVELdBxyi46HvsH+gyoSuhMLRCHUn
	 248dT++eNMqsIkdLBcWcQBMVS7VJUWxevcC33GmQkhV3jYnaxcloFWlZeX73OxtE6E
	 fzuqMpiHmcVdPhgnmV7/JcPd3ve9q+UwZjcZ6SNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 342/611] wifi: iwlwifi: debug: fix crash in __iwl_err()
Date: Mon,  8 May 2023 11:43:04 +0200
Message-Id: <20230508094433.523922768@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 634c7b1bd08ca322537ab389f8cbd7bb543b5e45 ]

In __iwl_err(), if we rate-limit the message away, then
vaf.va is still NULL-initialized by the time we get to
the tracing code, which then crashes. When it doesn't
get rate-limited out, it's still wrong to reuse the old
args2 that was already printed, which is why we bother
making a copy in the first place.

Assign vaf.va properly to fix this.

Fixes: e5f1cc98cc1b ("iwlwifi: allow rate-limited error messages")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230413102635.e27134c6bcd4.Ib3894cd2ba7a5ad5e75912a7634f146ceaa569e2@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-debug.c b/drivers/net/wireless/intel/iwlwifi/iwl-debug.c
index ae4c2a3d63d5b..3a3c13a41fc61 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-debug.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-debug.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2005-2011, 2021 Intel Corporation
+ * Copyright (C) 2005-2011, 2021-2022 Intel Corporation
  */
 #include <linux/device.h>
 #include <linux/interrupt.h>
@@ -57,6 +57,7 @@ void __iwl_err(struct device *dev, enum iwl_err_mode mode, const char *fmt, ...)
 	default:
 		break;
 	}
+	vaf.va = &args;
 	trace_iwlwifi_err(&vaf);
 	va_end(args);
 }
-- 
2.39.2



