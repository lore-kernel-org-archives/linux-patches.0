Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D25BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C2DC4339B;
	Tue,  7 Mar 2023 19:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216005;
	bh=HtEflstP9YVFSqBhKRZ5o60xntNJ2+/ynZx50FIm420=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eW9aBHDQTQrvEAXhA9ma0O950NB2H6emQlLQ7if6kX1n1qQVXY/PVF3AHEiO/iBuT
	 Wdy9ZiTW4GN7qAAIzNCPO3ZDYdNJA0eQammkJZkq1P/mh1D5WNUo2Kize2B6werqoK
	 Ns1vApAg2iMWf4jvcDUGQ5fGrteLncNXqpZvBHrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+57e3e98f7e3b80f64d56@syzkaller.appspotmail.com,
	Dongliang Mu <mudongliangabcd@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Muchun Song <songmuchun@bytedance.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Theodore Tso" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 445/567] fs: hfsplus: fix UAF issue in hfsplus_put_super
Date: Tue,  7 Mar 2023 18:03:01 +0100
Message-Id: <20230307165925.199477256@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit 07db5e247ab5858439b14dd7cc1fe538b9efcf32 upstream.

The current hfsplus_put_super first calls hfs_btree_close on
sbi->ext_tree, then invokes iput on sbi->hidden_dir, resulting in an
use-after-free issue in hfsplus_release_folio.

As shown in hfsplus_fill_super, the error handling code also calls iput
before hfs_btree_close.

To fix this error, we move all iput calls before hfsplus_btree_close.

Note that this patch is tested on Syzbot.

Link: https://lkml.kernel.org/r/20230226124948.3175736-1-mudongliangabcd@gmail.com
Reported-by: syzbot+57e3e98f7e3b80f64d56@syzkaller.appspotmail.com
Tested-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hfsplus/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -295,11 +295,11 @@ static void hfsplus_put_super(struct sup
 		hfsplus_sync_fs(sb, 1);
 	}
 
+	iput(sbi->alloc_file);
+	iput(sbi->hidden_dir);
 	hfs_btree_close(sbi->attr_tree);
 	hfs_btree_close(sbi->cat_tree);
 	hfs_btree_close(sbi->ext_tree);
-	iput(sbi->alloc_file);
-	iput(sbi->hidden_dir);
 	kfree(sbi->s_vhdr_buf);
 	kfree(sbi->s_backup_vhdr_buf);
 	unload_nls(sbi->nls);


