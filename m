Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272B411C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA8DC433C8;
	Mon, 28 Aug 2023 10:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218079;
	bh=91qeNnNHuDWmx+AxHkIBov4XrfVHp98ZP97pA9wjO/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DlPV2dtlSwloh+X1CZv+pZxv2M64FOYL32SmV8zHdyWhmlyAiBaY+h0+KavIXXlfu
	 D1fa+tUv3n2ML0MDlXCbd/VsAJ69WGn9+N962vSgtyKTLfPEvDG8BYzWX0M9pfKd99
	 63f1PC4zu04gYv9a4vkllOez9+HmAAoA1FMGS+eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+0ad741797f4565e7e2d2@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 088/129] nilfs2: fix general protection fault in nilfs_lookup_dirty_data_buffers()
Date: Mon, 28 Aug 2023 12:12:47 +0200
Message-ID: <20230828101200.282396340@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit f83913f8c5b882a312e72b7669762f8a5c9385e4 upstream.

A syzbot stress test reported that create_empty_buffers() called from
nilfs_lookup_dirty_data_buffers() can cause a general protection fault.

Analysis using its reproducer revealed that the back reference "mapping"
from a page/folio has been changed to NULL after dirty page/folio gang
lookup in nilfs_lookup_dirty_data_buffers().

Fix this issue by excluding pages/folios from being collected if, after
acquiring a lock on each page/folio, its back reference "mapping" differs
from the pointer to the address space struct that held the page/folio.

Link: https://lkml.kernel.org/r/20230805132038.6435-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+0ad741797f4565e7e2d2@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/0000000000002930a705fc32b231@google.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/segment.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -725,6 +725,11 @@ static size_t nilfs_lookup_dirty_data_bu
 		struct folio *folio = fbatch.folios[i];
 
 		folio_lock(folio);
+		if (unlikely(folio->mapping != mapping)) {
+			/* Exclude folios removed from the address space */
+			folio_unlock(folio);
+			continue;
+		}
 		head = folio_buffers(folio);
 		if (!head) {
 			create_empty_buffers(&folio->page, i_blocksize(inode), 0);


