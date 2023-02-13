Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF7A8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00390C4339E;
	Mon, 13 Feb 2023 15:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300550;
	bh=91+QGElK0eJrpYuG/o1o3ARtXkithUdOwIse86U7+NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnDOSugFih2n3qpNCNPENuR2p8KjRgNpuRrz+aRFFs8prerv3dCST2wWCxcUMH+qj
	 adUJt9aYS1rK1fL5ggg/Hp/nvnbXVYe/0cfLrazOuKkfzXQan7f0Eaxvhkcl3oPxUZ
	 vWyQtxRmGefg+fdO3NYn3gP+sBlyM8HlAqt5kHpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.10 056/139] watchdog: diag288_wdt: do not use stack buffers for hardware data
Date: Mon, 13 Feb 2023 15:50:01 +0100
Message-Id: <20230213144748.703676529@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Egorenkov <egorenar@linux.ibm.com>

commit fe8973a3ad0905cb9ba2d42db42ed51de14737df upstream.

With CONFIG_VMAP_STACK=y the stack is allocated from the vmalloc space.
Data passed to a hardware or a hypervisor interface that
requires V=R can no longer be allocated on the stack.

Use kmalloc() to get memory for a diag288 command.

Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/diag288_wdt.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/watchdog/diag288_wdt.c
+++ b/drivers/watchdog/diag288_wdt.c
@@ -272,12 +272,21 @@ static int __init diag288_init(void)
 	char ebc_begin[] = {
 		194, 197, 199, 201, 213
 	};
+	char *ebc_cmd;
 
 	watchdog_set_nowayout(&wdt_dev, nowayout_info);
 
 	if (MACHINE_IS_VM) {
-		if (__diag288_vm(WDT_FUNC_INIT, 15,
-				 ebc_begin, sizeof(ebc_begin)) != 0) {
+		ebc_cmd = kmalloc(sizeof(ebc_begin), GFP_KERNEL);
+		if (!ebc_cmd) {
+			pr_err("The watchdog cannot be initialized\n");
+			return -ENOMEM;
+		}
+		memcpy(ebc_cmd, ebc_begin, sizeof(ebc_begin));
+		ret = __diag288_vm(WDT_FUNC_INIT, 15,
+				   ebc_cmd, sizeof(ebc_begin));
+		kfree(ebc_cmd);
+		if (ret != 0) {
 			pr_err("The watchdog cannot be initialized\n");
 			return -EINVAL;
 		}


