Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B789148314;
	Fri,  6 Dec 2024 15:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497761; cv=none; b=OjAjU7UawCFjyyrMLZCCg2TrrvKUuQVzjFissvMHgPxSG+EFNvCvK6Edzy81YoXQri0+ZZ3C0UXtPAyW3M3ukuVwRO++/UEC2MRXA/aalGmIhpFkmOuF6Q+12R659nWPnKm6+NXaheMzPMtvRTeBXysVDR+Ppw0P1oV6rinNYEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497761; c=relaxed/simple;
	bh=ddM4yAw9tsspJGNK8RiyZP9dCBGKaPnvCeG+DAOCUFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVF/D+LcVkbB0wErXXrd7i9U+59JFsxgW71wCoUkXuRhpVst//ZiJQQu5xxSMZkY7yp3DBMB59Ev+ObmAU3p818T4cwLW4Lq+wqVWE+NWJti4OKapO0FbjYe45go9Rf0YkaD7lAtuHoLnHyxktaqTA+C675g/jxOKr+3yeQWbfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fD2ug/cy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fD2ug/cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C615C4CED1;
	Fri,  6 Dec 2024 15:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497761;
	bh=ddM4yAw9tsspJGNK8RiyZP9dCBGKaPnvCeG+DAOCUFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fD2ug/cypSpfUToV7FikNytakqHT+7KMIOtwxSRnc0h0tnlCGWfhU8OBvSDfgzoNj
	 EEVC9s6m3VIlhj079kNbj+irvDITFmqR51J6yoAr+J/khLLmnCMGplhGD14Unyg5GK
	 BrfQ/5eezKAqGkx7lsHOroKC26BOhnGnrxuy7JNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LongPing Wei <weilongping@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 354/676] f2fs: fix the wrong f2fs_bug_on condition in f2fs_do_replace_block
Date: Fri,  6 Dec 2024 15:32:53 +0100
Message-ID: <20241206143707.176058464@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: LongPing Wei <weilongping@oppo.com>

[ Upstream commit c3af1f13476ec23fd99c98d060a89be28c1e8871 ]

This f2fs_bug_on was introduced by commit 2c1905042c8c ("f2fs: check
segment type in __f2fs_replace_block") when there were only 6 curseg types.
After commit d0b9e42ab615 ("f2fs: introduce inmem curseg") was introduced,
the condition should be changed to checking curseg->seg_type.

Fixes: d0b9e42ab615 ("f2fs: introduce inmem curseg")
Signed-off-by: LongPing Wei <weilongping@oppo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index c0ba379a6d8f3..9ccff4f159c3b 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3757,8 +3757,8 @@ void f2fs_do_replace_block(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 		}
 	}
 
-	f2fs_bug_on(sbi, !IS_DATASEG(type));
 	curseg = CURSEG_I(sbi, type);
+	f2fs_bug_on(sbi, !IS_DATASEG(curseg->seg_type));
 
 	mutex_lock(&curseg->curseg_mutex);
 	down_write(&sit_i->sentry_lock);
-- 
2.43.0



