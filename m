Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460D2882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AF8C433EF;
	Fri, 10 Mar 2023 15:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460794;
	bh=WQapwnlzvdlcuOSFjzemO+1KCgxp2nR0nblIBIOnKYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xx6f68+wdMtNx6msdR996dHfT1L01SmOVOgOGhyedUfah20Lpci4Vq7/CuBm5BekD
	 7Kj3F+jzsI0ZuJgDu4Im3TT2sVfzN+URhspOkKwYaJFJeA6vCbqXu6ZRuKHwCYv/Hz
	 lKGT+4Yzc5pN1z6A8sypB764hEa01mor6F5vTt2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 454/529] ubi: fastmap: Fix missed fm_anchor PEB in wear-leveling after disabling fastmap
Date: Fri, 10 Mar 2023 14:39:57 +0100
Message-Id: <20230310133825.936600452@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 76f9476ece445a07aeb72df9d896cd563fb5b50f ]

After disabling fastmap(ubi->fm_disabled = 1), fastmap won't be updated,
fm_anchor PEB is missed being scheduled for erasing. Besides, fm_anchor
PEB may have smallest erase count, it doesn't participate wear-leveling.
The difference of erase count between fm_anchor PEB and other PEBs will
be larger and larger later on.

In which situation fastmap can be disabled? Initially, we have an UBI
image with fastmap. Then the image will be atttached without module
parameter 'fm_autoconvert', ubi turns to full scanning mode in one
random attaching process(eg. bad fastmap caused by powercut), ubi
fastmap is disabled since then.

Fix it by not getting fm_anchor if fastmap is disabled in
ubi_refill_pools().

Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216341
Fixes: 4b68bf9a69d22d ("ubi: Select fastmap anchor PEBs considering ...")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/fastmap-wl.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index 053ab52668e8b..69592be33adfc 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -146,13 +146,15 @@ void ubi_refill_pools(struct ubi_device *ubi)
 	if (ubi->fm_anchor) {
 		wl_tree_add(ubi->fm_anchor, &ubi->free);
 		ubi->free_count++;
+		ubi->fm_anchor = NULL;
 	}
 
-	/*
-	 * All available PEBs are in ubi->free, now is the time to get
-	 * the best anchor PEBs.
-	 */
-	ubi->fm_anchor = ubi_wl_get_fm_peb(ubi, 1);
+	if (!ubi->fm_disabled)
+		/*
+		 * All available PEBs are in ubi->free, now is the time to get
+		 * the best anchor PEBs.
+		 */
+		ubi->fm_anchor = ubi_wl_get_fm_peb(ubi, 1);
 
 	for (;;) {
 		enough = 0;
-- 
2.39.2



