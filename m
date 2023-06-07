Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2F71D2A5
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACF5C433EF;
	Wed,  7 Jun 2023 20:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170779;
	bh=GwBaXoNiSoSFSpiNL3cErcNCcIVhHLLYcgqU77N4EW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0dpOrwyrpCW9SrlDewglSeHs0XlucQ7V5L9mtGORbKgZvEljM2zrd47sQ+6+xMwz
	 fXHOEAgODupn3sM6wenrn7C455KyMB58MpCAbJYAH3IKw7XeOMYKsF6vpmsu8GRrnL
	 fzYlcDFrvruJOPer7eoRbhoLGSS5ULMqFYo+7X6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Richard Weinberger <richard@nod.at>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 185/225] mtdchar: mark bits of ioctl handler noinline
Date: Wed,  7 Jun 2023 22:16:18 +0200
Message-ID: <20230607200920.437442344@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

commit 0ea923f443350c8c5cca6eef5b748d52b903f46c upstream.

The addition of the mtdchar_read_ioctl() function caused the stack usage
of mtdchar_ioctl() to grow beyond the warning limit on 32-bit architectures
with gcc-13:

drivers/mtd/mtdchar.c: In function 'mtdchar_ioctl':
drivers/mtd/mtdchar.c:1229:1: error: the frame size of 1488 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Mark both the read and write portions as noinline_for_stack to ensure
they don't get inlined and use separate stack slots to reduce the
maximum usage, both in the mtdchar_ioctl() and combined with any
of its callees.

Fixes: 095bb6e44eb1 ("mtdchar: add MEMREAD ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230417205654.1982368-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdchar.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -590,8 +590,8 @@ static void adjust_oob_length(struct mtd
 			    (end_page - start_page + 1) * oob_per_page);
 }
 
-static int mtdchar_write_ioctl(struct mtd_info *mtd,
-		struct mtd_write_req __user *argp)
+static noinline_for_stack int
+mtdchar_write_ioctl(struct mtd_info *mtd, struct mtd_write_req __user *argp)
 {
 	struct mtd_info *master = mtd_get_master(mtd);
 	struct mtd_write_req req;
@@ -688,8 +688,8 @@ static int mtdchar_write_ioctl(struct mt
 	return ret;
 }
 
-static int mtdchar_read_ioctl(struct mtd_info *mtd,
-		struct mtd_read_req __user *argp)
+static noinline_for_stack int
+mtdchar_read_ioctl(struct mtd_info *mtd, struct mtd_read_req __user *argp)
 {
 	struct mtd_info *master = mtd_get_master(mtd);
 	struct mtd_read_req req;


