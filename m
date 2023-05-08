Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B66A168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F59C433EF;
	Mon,  8 May 2023 09:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539678;
	bh=ZheHF2Es9l7dGqTGX453WIo07dJi81f7biRKOVgUASw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtB2ePvzgiNkPER0jYLe+YGwwp9JKiaRE2WSFFzzNkKUSWp2SiQPqlKq5SbmN02Qv
	 0YahVJjq70ozR60J/81ho0QDD4CsBkPxqylCJpbjfberaW73uXE347C5b/ib7l/QC5
	 hgZlT5stHodmNZytqrjmeDes6cKlvfZNsfsWbhBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.1 101/611] Revert "ubifs: dirty_cow_znode: Fix memleak in error handling path"
Date: Mon,  8 May 2023 11:39:03 +0200
Message-Id: <20230508094425.501648675@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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


