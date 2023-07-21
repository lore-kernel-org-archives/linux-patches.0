Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A341F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BF9C433C8;
	Fri, 21 Jul 2023 16:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955880;
	bh=WobzbKCo3HNo/CQqTM7PQ6upSAaCKLi2CbsS297v0Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jw4tD8MYHwwzhRegWNNXwm8WQSmsrPZt9ARPjMRzIVFBm5AD9bvHwT3VILR/AcFTI
	 Uu3Nccy4iYfdriDS/TX3S1gsRIw1pHZPgTL4bUUKAXdinFvDL6OPWxOty5Y5Y3nA6k
	 v70i18NtNADD1zi6AamZPZFc/g+zkVh5YwbiDrd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 062/292] NTB: ntb_transport: fix possible memory leak while device_register() fails
Date: Fri, 21 Jul 2023 18:02:51 +0200
Message-ID: <20230721160531.458115878@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8623ccbfc55d962e19a3537652803676ad7acb90 ]

If device_register() returns error, the name allocated by
dev_set_name() need be freed. As comment of device_register()
says, it should use put_device() to give up the reference in
the error path. So fix this by calling put_device(), then the
name can be freed in kobject_cleanup(), and client_dev is freed
in ntb_transport_client_release().

Fixes: fce8a7bb5b4b ("PCI-Express Non-Transparent Bridge Support")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/ntb_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index a9b97ebc71ac5..2abd2235bbcab 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -410,7 +410,7 @@ int ntb_transport_register_client_dev(char *device_name)
 
 		rc = device_register(dev);
 		if (rc) {
-			kfree(client_dev);
+			put_device(dev);
 			goto err;
 		}
 
-- 
2.39.2



