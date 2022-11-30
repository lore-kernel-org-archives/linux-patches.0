Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB10379C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD75C433D6;
	Wed, 30 Nov 2022 18:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834212;
	bh=4U3+mb3n70ovb4Lg9tEv9Oo48vEG3Fcv7bNdFjel2yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDtVx2N2Mn4G8nSLOjkgoZSrP1ZJFg9TWX0FK1evl2crp2wxX2w/j6PblYeTCzumD
	 3bkMgGkNIs5RQDuKHg4bX40z0PX/ZcaX77M1foQIOMN+obyc4lCpR1cKbzHacsAwRb
	 o+JoNG4VThqqIdG8jVapQCRZCWZdUBVgJZPJSoYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 143/289] s390/ap: fix memory leak in ap_init_qci_info()
Date: Wed, 30 Nov 2022 19:22:08 +0100
Message-Id: <20221130180547.379953035@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 9ac74f0666ceab0b1047e9d59be846a3345e4e98 ]

If kzalloc() for 'ap_qci_info_old' failed, 'ap_qci_info' shold be
freed before return. Otherwise it is a memory leak.

Link: https://lore.kernel.org/r/20221114110830.542246-1-weiyongjun@huaweicloud.com
Fixes: 283915850a44 ("s390/ap: notify drivers on config changed and scan complete callbacks")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 59ac98f2bd27..b02c631f3b71 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -233,8 +233,11 @@ static void __init ap_init_qci_info(void)
 	if (!ap_qci_info)
 		return;
 	ap_qci_info_old = kzalloc(sizeof(*ap_qci_info_old), GFP_KERNEL);
-	if (!ap_qci_info_old)
+	if (!ap_qci_info_old) {
+		kfree(ap_qci_info);
+		ap_qci_info = NULL;
 		return;
+	}
 	if (ap_fetch_qci_info(ap_qci_info) != 0) {
 		kfree(ap_qci_info);
 		kfree(ap_qci_info_old);
-- 
2.35.1



