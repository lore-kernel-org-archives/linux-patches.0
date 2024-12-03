Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BC61F669E;
	Tue,  3 Dec 2024 15:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239177; cv=none; b=l3k3p4nsD7Hx34W3JT3NbTfX1723ZlO+vUklyjLfozF1vNMfkwO5YHqSmS7xvSC968FRz3f7AK7W4NyC7E7Vf6VtpCmaKo3NdMPkJSvdXxab1t4ml9jN/Te4ASB27nnctIt1fPRBBffDkWYOnQ+hJmz0tVzxnCHv8RDU0HvIb8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239177; c=relaxed/simple;
	bh=rz3vYfYpoannZ3mnl13ENbQPt/KNQQeBWEMNRjb9iAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkARZqxaE4r2vz649IZhc/DopUEXgFEn7TTpt4Axj/Ny37xO+woVr8BztkiU8ZhrdNIw50/MhacBC2761g3riRdsU7EWByExKF0GbUYTWiADNlZitPnMq0W8gVfmMGCL5Y7bLBU/CglDdCan5QeVsoL0TTEQNxF2zMBnjeEI30s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRvhwZ92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRvhwZ92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AC8C4CED8;
	Tue,  3 Dec 2024 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239176;
	bh=rz3vYfYpoannZ3mnl13ENbQPt/KNQQeBWEMNRjb9iAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRvhwZ92+stworbdfa+EMNwseJWo7vK/8k+bmUsX1Dfvzc+YNJT+kFzdUqJg2tuc4
	 F24VFm2TY9VwSlnqd1+TG4bcMC16rey+RAf7W8bFtw9D6xl3bj2TNGMc5XLUW2N6HF
	 RicaAlKQLo0CtNdmucJEeSzMlQG+s9Ta+nO3K+XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LongPing Wei <weilongping@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 508/817] f2fs: fix the wrong f2fs_bug_on condition in f2fs_do_replace_block
Date: Tue,  3 Dec 2024 15:41:20 +0100
Message-ID: <20241203144015.701571982@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index c9320c98cb142..3f49a9e0ec642 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3974,8 +3974,8 @@ void f2fs_do_replace_block(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 		}
 	}
 
-	f2fs_bug_on(sbi, !IS_DATASEG(type));
 	curseg = CURSEG_I(sbi, type);
+	f2fs_bug_on(sbi, !IS_DATASEG(curseg->seg_type));
 
 	mutex_lock(&curseg->curseg_mutex);
 	down_write(&sit_i->sentry_lock);
-- 
2.43.0



