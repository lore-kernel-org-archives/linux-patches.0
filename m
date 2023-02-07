Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB683214
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A146C4339B;
	Tue,  7 Feb 2023 13:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775052;
	bh=jaF2ORhaKh4b+IjRoPmH57vBzpUUok2poMj1wAoCf6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5p/y34H1BI1AdVBq8hh5VZUAM3ZjDb+J0wxf+34J1fCUAOt6r6iwQL+R5sVB/qAu
	 +693u7v1MRLAYjuBrIkUP2tASdq/LDWmGEQbEj5ygVEktmyqKo3yWeu2eh0/txQgRW
	 aEehnqW7jucrtLzEwPJaHWVCJ+ZltaDP27N2nDyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.1 122/208] watchdog: diag288_wdt: do not use stack buffers for hardware data
Date: Tue,  7 Feb 2023 13:56:16 +0100
Message-Id: <20230207125639.940801570@linuxfoundation.org>
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
@@ -268,12 +268,21 @@ static int __init diag288_init(void)
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


