Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676441875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE76AC433EF;
	Wed, 28 Dec 2022 16:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243373;
	bh=qRGNyaetA+FUFks0KGazDQ2BAE2qJIx13bFDlWp+UGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Khhtt0Eaim8EuImprGhjJbmHAasQR5r+VwXoQgpflNmgU6NeRqYH4qGzDSHXsTpSx
	 dx4QS5KIFYishRdBUb9/cj1FsFcRPyecTCVYv4LWCg5lXBuy4hHY50UNdXgbkhwuDG
	 X/8qAl2F+jGUwhr72x7LA3i4ysOvj8K/2GGlZhqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Chen <kenchen@google.com>,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 714/731] loop: Fix the max_loop commandline argument treatment when it is set to 0
Date: Wed, 28 Dec 2022 15:43:41 +0100
Message-Id: <20221228144317.140279120@linuxfoundation.org>
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

From: Isaac J. Manjarres <isaacmanjarres@google.com>

commit 85c50197716c60fe57f411339c579462e563ac57 upstream.

Currently, the max_loop commandline argument can be used to specify how
many loop block devices are created at init time. If it is not
specified on the commandline, CONFIG_BLK_DEV_LOOP_MIN_COUNT loop block
devices will be created.

The max_loop commandline argument can be used to override the value of
CONFIG_BLK_DEV_LOOP_MIN_COUNT. However, when max_loop is set to 0
through the commandline, the current logic treats it as if it had not
been set, and creates CONFIG_BLK_DEV_LOOP_MIN_COUNT devices anyway.

Fix this by starting max_loop off as set to CONFIG_BLK_DEV_LOOP_MIN_COUNT.
This preserves the intended behavior of creating
CONFIG_BLK_DEV_LOOP_MIN_COUNT loop block devices if the max_loop
commandline parameter is not specified, and allowing max_loop to
be respected for all values, including 0.

This allows environments that can create all of their required loop
block devices on demand to not have to unnecessarily preallocate loop
block devices.

Fixes: 732850827450 ("remove artificial software max_loop limit")
Cc: stable@vger.kernel.org
Cc: Ken Chen <kenchen@google.com>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Link: https://lore.kernel.org/r/20221208212902.765781-1-isaacmanjarres@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -2091,7 +2091,16 @@ static const struct block_device_operati
 /*
  * And now the modules code and kernel interface.
  */
-static int max_loop;
+
+/*
+ * If max_loop is specified, create that many devices upfront.
+ * This also becomes a hard limit. If max_loop is not specified,
+ * create CONFIG_BLK_DEV_LOOP_MIN_COUNT loop devices at module
+ * init time. Loop devices can be requested on-demand with the
+ * /dev/loop-control interface, or be instantiated by accessing
+ * a 'dead' device node.
+ */
+static int max_loop = CONFIG_BLK_DEV_LOOP_MIN_COUNT;
 module_param(max_loop, int, 0444);
 MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
 module_param(max_part, int, 0444);
@@ -2536,7 +2545,7 @@ MODULE_ALIAS("devname:loop-control");
 
 static int __init loop_init(void)
 {
-	int i, nr;
+	int i;
 	int err;
 
 	part_shift = 0;
@@ -2564,19 +2573,6 @@ static int __init loop_init(void)
 		goto err_out;
 	}
 
-	/*
-	 * If max_loop is specified, create that many devices upfront.
-	 * This also becomes a hard limit. If max_loop is not specified,
-	 * create CONFIG_BLK_DEV_LOOP_MIN_COUNT loop devices at module
-	 * init time. Loop devices can be requested on-demand with the
-	 * /dev/loop-control interface, or be instantiated by accessing
-	 * a 'dead' device node.
-	 */
-	if (max_loop)
-		nr = max_loop;
-	else
-		nr = CONFIG_BLK_DEV_LOOP_MIN_COUNT;
-
 	err = misc_register(&loop_misc);
 	if (err < 0)
 		goto err_out;
@@ -2588,7 +2584,7 @@ static int __init loop_init(void)
 	}
 
 	/* pre-create number of devices given by config or max_loop */
-	for (i = 0; i < nr; i++)
+	for (i = 0; i < max_loop; i++)
 		loop_add(i);
 
 	printk(KERN_INFO "loop: module loaded\n");


