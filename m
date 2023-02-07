Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64402C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23358C433EF;
	Tue,  7 Feb 2023 13:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775189;
	bh=MacZ1whNHk5jZpB3a+BAxtb940aA4gQt/9BRQ1UrugA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u26hmNjeDhUhMuA8XoRYREpKpSDiDT23BGaZnj6P2aCmdWt+h1086u2S4SWPQv5Vi
	 RJN5P2O1N84aFnZ5B0jGBIkmYn0Ho3S0xuPxrwOhXe6jjH/u2HRAjDTSp93FFlWy1F
	 TcxV8gG1IIer3TN2aidv0VRigOZc0Q40EOKEH49w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yongjun <zhengyongjun3@huawei.com>,
	Russ Weight <russell.h.weight@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: [PATCH 6.1 166/208] fpga: stratix10-soc: Fix return value check in s10_ops_write_init()
Date: Tue,  7 Feb 2023 13:57:00 +0100
Message-Id: <20230207125641.933198175@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Yongjun <zhengyongjun3@huawei.com>

commit 65ea840afd508194b0ee903256162aa87e46ec30 upstream.

In case of error, the function stratix10_svc_allocate_memory()
returns ERR_PTR() and never returns NULL. The NULL test in the
return value check should be replaced with IS_ERR().

Fixes: e7eef1d7633a ("fpga: add intel stratix10 soc fpga manager driver")
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Reviewed-by: Russ Weight <russell.h.weight@intel.com>
Cc: stable@vger.kernel.org
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20221126071430.19540-1-zhengyongjun3@huawei.com
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/stratix10-soc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/fpga/stratix10-soc.c
+++ b/drivers/fpga/stratix10-soc.c
@@ -213,9 +213,9 @@ static int s10_ops_write_init(struct fpg
 	/* Allocate buffers from the service layer's pool. */
 	for (i = 0; i < NUM_SVC_BUFS; i++) {
 		kbuf = stratix10_svc_allocate_memory(priv->chan, SVC_BUF_SIZE);
-		if (!kbuf) {
+		if (IS_ERR(kbuf)) {
 			s10_free_buffers(mgr);
-			ret = -ENOMEM;
+			ret = PTR_ERR(kbuf);
 			goto init_done;
 		}
 


