Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FD51F75B9;
	Tue,  3 Dec 2024 16:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241719; cv=none; b=uYug0wgNQJUMkLl/QVTUWoISfqwelPEcDBauPlAWEBC4ClVnwRKKntCfFsko2bKnF7rLyLRhzRg6805/lfOLlkRn+Y8ueXXAzv0wgnUVhUyVO/Zm3V4qEXcmik1CdlOASNgEVpNDkijiX4wDxL1IPQeYleRW87u6lQ2eHMfJX80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241719; c=relaxed/simple;
	bh=6jfyDwk7LwRd9mZtFsuBhevq4+y3l1SXkSJFbUzCaB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORjhigUaw+bXWi69299ArBDQyh7voi5xaysKqTz7XYPzP/fjklHjUkKrWTGMb6MpHlpktg6Ij19tm9CBX1FSJzskOI2kaKlPClWljnkKoyEpLde1SzmnGp1KLd9Y2dYP1iU6t0n483KsN6oFb3n8t7sXVszPpfW82EgXHdlUiZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emgbrYiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emgbrYiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A33C4CECF;
	Tue,  3 Dec 2024 16:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241719;
	bh=6jfyDwk7LwRd9mZtFsuBhevq4+y3l1SXkSJFbUzCaB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emgbrYiEArDol3EGJe0vpjdbGglrZAj1OEOs2IhRDQSbAqU48Pt/KDtzGdFoV0CJW
	 88IeUgYj/AhcK34ZAHHUMnSo02aB88SS4QhQJ9TfCK5Z0sdi+47LmebU1Qhz+4UEPa
	 1ussvBskBFXyDaKL+QuVWaX7MkEyawv3ldkwksGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LongPing Wei <weilongping@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 497/826] f2fs: fix the wrong f2fs_bug_on condition in f2fs_do_replace_block
Date: Tue,  3 Dec 2024 15:43:44 +0100
Message-ID: <20241203144803.142205903@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1766254279d24..7b54b1851d346 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3977,8 +3977,8 @@ void f2fs_do_replace_block(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 		}
 	}
 
-	f2fs_bug_on(sbi, !IS_DATASEG(type));
 	curseg = CURSEG_I(sbi, type);
+	f2fs_bug_on(sbi, !IS_DATASEG(curseg->seg_type));
 
 	mutex_lock(&curseg->curseg_mutex);
 	down_write(&sit_i->sentry_lock);
-- 
2.43.0



