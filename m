Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3046AFC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87568C433EF;
	Mon, 15 May 2023 17:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172276;
	bh=fammJWTdQomjL+iBvJ/ioWCAPk90kenJvHU21B78cqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfYFElnrJ7xv6oXUtWAuMXfmWjY4ged1Z9tH/RBj0W0EEI70qJmBRXJ6vMpoYF/oP
	 wPhybwTNRVGheXCeRsGH2hhVvK1javQm7AK6a2g/lOig8f9PLjJy4Ai7OVCNGvc+E5
	 uwmTPQdHtpBJNy2fFwOut1TW3x3O0pbba2a9PbiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+aafb3f37cfeb6534c4ac@syzkaller.appspotmail.com
Subject: [PATCH 5.10 071/381] erofs: stop parsing non-compact HEAD index if clusterofs is invalid
Date: Mon, 15 May 2023 18:25:22 +0200
Message-Id: <20230515161740.027969203@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit cc4efd3dd2ac9f89143e5d881609747ecff04164 ]

Syzbot generated a crafted image [1] with a non-compact HEAD index of
clusterofs 33024 while valid numbers should be 0 ~ lclustersize-1,
which causes the following unexpected behavior as below:

 BUG: unable to handle page fault for address: fffff52101a3fff9
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 23ffed067 P4D 23ffed067 PUD 0
 Oops: 0000 [#1] PREEMPT SMP KASAN
 CPU: 1 PID: 4398 Comm: kworker/u5:1 Not tainted 6.3.0-rc6-syzkaller-g09a9639e56c0 #0
 Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023
 Workqueue: erofs_worker z_erofs_decompressqueue_work
 RIP: 0010:z_erofs_decompress_queue+0xb7e/0x2b40
 ...
 Call Trace:
  <TASK>
  z_erofs_decompressqueue_work+0x99/0xe0
  process_one_work+0x8f6/0x1170
  worker_thread+0xa63/0x1210
  kthread+0x270/0x300
  ret_from_fork+0x1f/0x30

Note that normal images or images using compact indexes are not
impacted.  Let's fix this now.

[1] https://lore.kernel.org/r/000000000000ec75b005ee97fbaa@google.com

Reported-and-tested-by: syzbot+aafb3f37cfeb6534c4ac@syzkaller.appspotmail.com
Fixes: 02827e1796b3 ("staging: erofs: add erofs_map_blocks_iter")
Fixes: 152a333a5895 ("staging: erofs: add compacted compression indexes support")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20230410173714.104604-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 14d2de35110cc..f18194fd8d770 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -179,6 +179,10 @@ static int legacy_load_cluster_from_disk(struct z_erofs_maprecorder *m,
 	case Z_EROFS_VLE_CLUSTER_TYPE_PLAIN:
 	case Z_EROFS_VLE_CLUSTER_TYPE_HEAD:
 		m->clusterofs = le16_to_cpu(di->di_clusterofs);
+		if (m->clusterofs >= 1 << vi->z_logical_clusterbits) {
+			DBG_BUGON(1);
+			return -EFSCORRUPTED;
+		}
 		m->pblk = le32_to_cpu(di->di_u.blkaddr);
 		break;
 	default:
-- 
2.39.2



