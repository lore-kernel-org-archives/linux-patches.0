Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2143E1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEC4C433EF;
	Wed, 28 Dec 2022 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238922;
	bh=Q1J0+QDRDdqbKCV8jK/CSqhRD6+HaxWQ8KpoTNgF/qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vTnlCDMRMRliglQcU6UpQwTjsdDuEMLHgzEDa/O/9FcFVWAwzTQ/tV1IJJz9iPkhd
	 bcscc1idXZsIclPH/JR5liDH4WPitM2uG1oe3ZMWfTFY63deDl6NwNF9KohjZphOLx
	 f6pTrid3+z44wQp4h2HNGfIH3upFwvllkV0myJcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Maxim Uvarov <maxim.uvarov@linaro.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/731] tpm/tpm_ftpm_tee: Fix error handling in ftpm_mod_init()
Date: Wed, 28 Dec 2022 15:32:48 +0100
Message-Id: <20221228144258.322132999@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 2b7d07f7acaac2c7750e420dcf4414588ede6d03 ]

The ftpm_mod_init() returns the driver_register() directly without checking
its return value, if driver_register() failed, the ftpm_tee_plat_driver is
not unregistered.

Fix by unregister ftpm_tee_plat_driver when driver_register() failed.

Fixes: 9f1944c23c8c ("tpm_ftpm_tee: register driver on TEE bus")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Maxim Uvarov <maxim.uvarov@linaro.org>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_ftpm_tee.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_ftpm_tee.c b/drivers/char/tpm/tpm_ftpm_tee.c
index 6e3235565a4d..d9daaafdd295 100644
--- a/drivers/char/tpm/tpm_ftpm_tee.c
+++ b/drivers/char/tpm/tpm_ftpm_tee.c
@@ -397,7 +397,13 @@ static int __init ftpm_mod_init(void)
 	if (rc)
 		return rc;
 
-	return driver_register(&ftpm_tee_driver.driver);
+	rc = driver_register(&ftpm_tee_driver.driver);
+	if (rc) {
+		platform_driver_unregister(&ftpm_tee_plat_driver);
+		return rc;
+	}
+
+	return 0;
 }
 
 static void __exit ftpm_mod_exit(void)
-- 
2.35.1



