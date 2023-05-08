Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03DA168C4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B643C433D2;
	Mon,  8 May 2023 11:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545481;
	bh=ZheHF2Es9l7dGqTGX453WIo07dJi81f7biRKOVgUASw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSat6jTvyJcxPbscwc8/lJErpXM9ic/TFp17O3OVYTZwngrHqOr/bFjF60HXUvp9j
	 9CbhYxxx0diT8Y8l58GeG7jtHd8ssarjFnevueybu8WtPOJv2TnPBaFnLl4BE4DANF
	 DFMuDc/DGIz3FgeFDW7TUxLA2XcJ9M4/XuW7hPTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.15 053/371] Revert "ubifs: dirty_cow_znode: Fix memleak in error handling path"
Date: Mon,  8 May 2023 11:44:14 +0200
Message-Id: <20230508094814.166291637@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
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

commit 7d01cb27f6aebc54efbe28d8961a973b8f795b13 upstream.

This reverts commit 122deabfe1428 (ubifs: dirty_cow_znode: Fix memleak
in error handling path).
After commit 122deabfe1428 applied, if insert_old_idx() failed, old
index neither exists in TNC nor in old-index tree. Which means that
old index node could be overwritten in layout_leb_in_gaps(), then
ubifs image will be corrupted in power-cut.

Fixes: 122deabfe1428 (ubifs: dirty_cow_znode: Fix memleak ... path)
Cc: stable@vger.kernel.org
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/tnc.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -267,18 +267,11 @@ static struct ubifs_znode *dirty_cow_zno
 	if (zbr->len) {
 		err = insert_old_idx(c, zbr->lnum, zbr->offs);
 		if (unlikely(err))
-			/*
-			 * Obsolete znodes will be freed by tnc_destroy_cnext()
-			 * or free_obsolete_znodes(), copied up znodes should
-			 * be added back to tnc and freed by
-			 * ubifs_destroy_tnc_subtree().
-			 */
-			goto out;
+			return ERR_PTR(err);
 		err = add_idx_dirt(c, zbr->lnum, zbr->len);
 	} else
 		err = 0;
 
-out:
 	zbr->znode = zn;
 	zbr->lnum = 0;
 	zbr->offs = 0;


