Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0253113CA93;
	Thu, 12 Dec 2024 17:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024127; cv=none; b=pHOaiq5KsIfjNq65V/E3u5MuMi3mSW4Cf1tUdPTBZ1juP4KFJeIkxfSFSQ4MqKA39SkjAU49tgqzf0GCuYkyQjPMl6uxGIycl5NrgYtt3NdEGW2pcZrzxKrtPgEEwSJTI4pqxVfgXYKQpoodjFOi0GJX5DIzBYRH6/13XoMqYVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024127; c=relaxed/simple;
	bh=dnxX8ymgGZt4+djkZmV6y6dHaRwqX5Av/rep8Yu45BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhmoQ2++H61s/6PyDtrgwJka//yEFS1IeXmwFXepHDpCMDUQ7+/y4z3o++nylvJb9HKRYmOIVhEQyf/Pt4UL2V8sGRIe/FyQwBKujLMvYv6vRIUYwaiy076MWs4nsdYX2guc8acKSx9lqKXCkADHcDtVzFp0LeWmuzuFfnpUZxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iU8XRmJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iU8XRmJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B50EC4CECE;
	Thu, 12 Dec 2024 17:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024126;
	bh=dnxX8ymgGZt4+djkZmV6y6dHaRwqX5Av/rep8Yu45BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iU8XRmJVGJykuYetpq+bSDJIl1QfaThVNx69aJyiPr9eEDF6odZTeZif8/t4hcmkH
	 7OYBroEOsLydRpaIbIuI5pcrx4I3TReoEl3inRrY/Zoup1wZiRx5ypfY9rlj1LkUoi
	 ZN/WcasLhOdUhEl88Ki8X49ZeMdwwoH2MnJEh9cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LongPing Wei <weilongping@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/459] f2fs: fix the wrong f2fs_bug_on condition in f2fs_do_replace_block
Date: Thu, 12 Dec 2024 15:58:53 +0100
Message-ID: <20241212144301.270568141@linuxfoundation.org>
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
index 6fcc83637b153..a37f88cc7c485 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3617,8 +3617,8 @@ void f2fs_do_replace_block(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 		}
 	}
 
-	f2fs_bug_on(sbi, !IS_DATASEG(type));
 	curseg = CURSEG_I(sbi, type);
+	f2fs_bug_on(sbi, !IS_DATASEG(curseg->seg_type));
 
 	mutex_lock(&curseg->curseg_mutex);
 	down_write(&sit_i->sentry_lock);
-- 
2.43.0



