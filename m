Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FC66FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FC8C433EF;
	Mon, 16 Jan 2023 16:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887726;
	bh=lALA257aza9UChIUWuCJAMEm5wFtLaakyp3iG/S8nOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YvPZVdqen+E9XA6iUKJzL8eQrbzVF0nRUxvpeiCJ47VEBwgijQqJPZmyy6gGKaXds
	 iyh4mpio6qstfB5GXEqjgfB9DOEKSVIc0HQ9NIXJZux8xItVjO2wIrX9/B5v25r4mv
	 /FzWcPlYhCwLm95uPGsn5NlFQrNzM2f3jRjFv2qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 231/521] serial: sunsab: Fix error handling in sunsab_init()
Date: Mon, 16 Jan 2023 16:48:13 +0100
Message-Id: <20230116154857.475797690@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit 1a6ec673fb627c26e2267ca0a03849f91dbd9b40 ]

The sunsab_init() returns the platform_driver_register() directly without
checking its return value, if platform_driver_register() failed, the
allocated sunsab_ports is leaked.
Fix by free sunsab_ports and set it to NULL when platform_driver_register()
failed.

Fixes: c4d37215a824 ("[SERIAL] sunsab: Convert to of_driver framework.")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221123061212.52593-1-yuancan@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sunsab.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index 72131b5e132e..beca02c30498 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -1140,7 +1140,13 @@ static int __init sunsab_init(void)
 		}
 	}
 
-	return platform_driver_register(&sab_driver);
+	err = platform_driver_register(&sab_driver);
+	if (err) {
+		kfree(sunsab_ports);
+		sunsab_ports = NULL;
+	}
+
+	return err;
 }
 
 static void __exit sunsab_exit(void)
-- 
2.35.1



