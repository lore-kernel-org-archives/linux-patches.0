Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2FCBA34
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3F5C433EF;
	Tue,  7 Mar 2023 17:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210358;
	bh=eHG1zj8LeGJyv49UKhYbyrQ28kyFSzkO61Tb4oEtaDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JiaRSiDeHfaFdEZYGV4sph4yi8XmDtRkeumHm3MOmNd3wFsktN7GVm9FqIQ0VwPy7
	 MnksWhSfasqeHZLTGbVYBXq6akc/jDKek1BWbltugwarHCTTetB7RLWhR7lFJSyhUg
	 ng8mEyCEqV2FnGcKNV3umiDjHX5vxPixiGGBCxlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0515/1001] eeprom: idt_89hpesx: Fix error handling in idt_init()
Date: Tue,  7 Mar 2023 17:54:47 +0100
Message-Id: <20230307170043.787024064@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit d717a3ab282f51ec45142f911f7ef8a55c057de5 ]

A problem about idt_89hpesx create debugfs failed is triggered with the
following log given:

 [ 4973.269647] debugfs: Directory 'idt_csr' with parent '/' already present!

The reason is that idt_init() returns i2c_add_driver() directly without
checking its return value, if i2c_add_driver() failed, it returns without
destroy the newly created debugfs, resulting the debugfs of idt_csr can
never be created later.

 idt_init()
   debugfs_create_dir() # create debugfs directory
   i2c_add_driver()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without destroy debugfs directory

Fix by removing debugfs when i2c_add_driver() returns error.

Fixes: cfad6425382e ("eeprom: Add IDT 89HPESx EEPROM/CSR driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Acked-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/20221110020030.47711-1-yuancan@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/idt_89hpesx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/eeprom/idt_89hpesx.c b/drivers/misc/eeprom/idt_89hpesx.c
index 4e07ee9cb500e..7075d0b378811 100644
--- a/drivers/misc/eeprom/idt_89hpesx.c
+++ b/drivers/misc/eeprom/idt_89hpesx.c
@@ -1566,12 +1566,20 @@ static struct i2c_driver idt_driver = {
  */
 static int __init idt_init(void)
 {
+	int ret;
+
 	/* Create Debugfs directory first */
 	if (debugfs_initialized())
 		csr_dbgdir = debugfs_create_dir("idt_csr", NULL);
 
 	/* Add new i2c-device driver */
-	return i2c_add_driver(&idt_driver);
+	ret = i2c_add_driver(&idt_driver);
+	if (ret) {
+		debugfs_remove_recursive(csr_dbgdir);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(idt_init);
 
-- 
2.39.2



