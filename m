Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85949BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B84C4339E;
	Tue,  7 Mar 2023 18:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213212;
	bh=jnBCoKJC7GwPrc7UGWKAZFZMHTHhVWq6oaYDBqb2qqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsXMSyo6TmwEA/GyCqUPYQ/Vv+fT9IO5bI0KUhPVK2gRQ2dZeh3UxTGeNEV8wf6E4
	 T3pnJ5jeF3AB6UO8283xyStJlUUZ1RjSv1S05tEwdW9myFxKxHGq3jYzY4usy4dJ6/
	 pks5xsuVcAWV10goeZSp+U9ywK3cpvW+8yWd3ASU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 434/885] eeprom: idt_89hpesx: Fix error handling in idt_init()
Date: Tue,  7 Mar 2023 17:56:08 +0100
Message-Id: <20230307170021.265130706@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index bb3ed352b95f9..367054e0ced4e 100644
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



