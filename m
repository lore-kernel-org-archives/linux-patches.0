Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1BE13CA93;
	Thu, 12 Dec 2024 17:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024442; cv=none; b=rtmfQXmULK8tvufMASg6KVufcOk/lr3/vzG6m/JyZ23ZgWcPZmKlnQAiuHyLDbWhjGQvCucao6IrCod/xe8Y2s3xEmCbfi6Se4NOstol9yvcWo1phxl4S07A9R++3N15jYZ8ypo231AXc6CHpexu2MpJ9Kau+Mkpheh7e2EctRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024442; c=relaxed/simple;
	bh=5NGBwdTsU/h9e8CO/7oXUaQ0c/S415CkXe+RV19WNDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzR6JSjkaLVM+/FGEqrtSu1Rz+4t29T1FJmyKIVNgmyGmPVyQJb6oNlE2cEIDwV+MkBazfp2koKbF0nJ/P3MDsH+0pAr5Ez+U17KleDQFTA+LiGUAjsP9c2OnixfLuqo7rezQdtbecqUWa8nKJQU6xp7aO54YGC5gi217SUVKMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rs5R5FpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rs5R5FpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3993C4CED0;
	Thu, 12 Dec 2024 17:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024442;
	bh=5NGBwdTsU/h9e8CO/7oXUaQ0c/S415CkXe+RV19WNDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rs5R5FpXiZR5hgZP4TLEWNrFaQsnh7FzuN5ifOLShHMe+KinjRyyozmACPdmdMfSF
	 zpLFFj/12W3+Nr3k+765aBFDcMWy5e3Oyii6ImmI7y00S/jWIven1Rjq0Q3BmIsdxS
	 s/ME56amBoy/VgiIc/NgsBow5qnaiSYe8c15skSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@siflower.com.cn>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 298/459] jffs2: fix use of uninitialized variable
Date: Thu, 12 Dec 2024 16:00:36 +0100
Message-ID: <20241212144305.414282345@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



