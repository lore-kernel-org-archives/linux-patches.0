Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0581E25E4;
	Tue,  3 Dec 2024 14:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236869; cv=none; b=r+pX5S4jtAKMsZPqHwHRZadCAo5tF0cD6RYPEb6xCRM/f5F803UZKynWAlxKDO3IN3CUTAokpmJzbph1eY8mwFMYM14/EFwtkw1HVZCKoWWmVNSyI9FtXWo5xB7YzBphJlCtD3j5ekVse2aqHWDMslRonGbihyzmq6hcc/PMyAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236869; c=relaxed/simple;
	bh=gaa6dVixT/XHbWMwQ1EPtMf1AUH0FJNaejB9eRxSw5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBVKiKGNmziAPLHQMyx1eJ0wgPESegCFNe7TMWvD8TBSFjIjpKwrXiDid+JBYUpu9Gi9IX2a2BmmsIeJuO0bPYU44o7LqLYBSyFwoZRYim+kMVfTT6hcfUbVu3sVQLaMIzeHliT8qtF5lXHCTG/4XXlCrgZRCpewufrxf7hTI+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NT/K56kQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NT/K56kQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E26C4CED9;
	Tue,  3 Dec 2024 14:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236869;
	bh=gaa6dVixT/XHbWMwQ1EPtMf1AUH0FJNaejB9eRxSw5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NT/K56kQ/WrZel6mY19zDMPW2Somor/sapDfIS7ZFzld5PlApKDeyMSBS5xAK8t5o
	 IJ+d9xrbW5UGWBf9S9bJPV+/2l6+aDXx43rNodHMbpxAzO/E+YYYLRJfztp6PUGxH6
	 J1LfjHsgRwnWWLa8yMItShTjVnFeK5zNgoWU+/cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@siflower.com.cn>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 133/138] jffs2: fix use of uninitialized variable
Date: Tue,  3 Dec 2024 15:32:42 +0100
Message-ID: <20241203141928.656065530@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang Deng <qingfang.deng@siflower.com.cn>

[ Upstream commit 3ba44ee966bc3c41dd8a944f963466c8fcc60dc8 ]

When building the kernel with -Wmaybe-uninitialized, the compiler
reports this warning:

In function 'jffs2_mark_erased_block',
    inlined from 'jffs2_erase_pending_blocks' at fs/jffs2/erase.c:116:4:
fs/jffs2/erase.c:474:9: warning: 'bad_offset' may be used uninitialized [-Wmaybe-uninitialized]
  474 |         jffs2_erase_failed(c, jeb, bad_offset);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fs/jffs2/erase.c: In function 'jffs2_erase_pending_blocks':
fs/jffs2/erase.c:402:18: note: 'bad_offset' was declared here
  402 |         uint32_t bad_offset;
      |                  ^~~~~~~~~~

When mtd->point() is used, jffs2_erase_pending_blocks can return -EIO
without initializing bad_offset, which is later used at the filebad
label in jffs2_mark_erased_block.
Fix it by initializing this variable.

Fixes: 8a0f572397ca ("[JFFS2] Return values of jffs2_block_check_erase error paths")
Signed-off-by: Qingfang Deng <qingfang.deng@siflower.com.cn>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jffs2/erase.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/jffs2/erase.c b/fs/jffs2/erase.c
index 7e9abdb897122..5fbaf6ab9f482 100644
--- a/fs/jffs2/erase.c
+++ b/fs/jffs2/erase.c
@@ -340,10 +340,9 @@ static int jffs2_block_check_erase(struct jffs2_sb_info *c, struct jffs2_erasebl
 		} while(--retlen);
 		mtd_unpoint(c->mtd, jeb->offset, c->sector_size);
 		if (retlen) {
-			pr_warn("Newly-erased block contained word 0x%lx at offset 0x%08tx\n",
-				*wordebuf,
-				jeb->offset +
-				c->sector_size-retlen * sizeof(*wordebuf));
+			*bad_offset = jeb->offset + c->sector_size - retlen * sizeof(*wordebuf);
+			pr_warn("Newly-erased block contained word 0x%lx at offset 0x%08x\n",
+				*wordebuf, *bad_offset);
 			return -EIO;
 		}
 		return 0;
-- 
2.43.0



