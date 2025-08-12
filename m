Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2323D2DBF5E;
	Tue, 12 Aug 2025 18:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022848; cv=none; b=KeWz2sNQWRW2F6gNe9yscRVgPv74JGIo4YX2TZdJqz1FZrM1Xtc4Sg8YqrgWHy3C7q5KLdvhKqbsRKNkp7kWV/bbS+usI+ZYtw23YpTji+IgyoBMBNEfttX1bQR8uJXSDg9apFTHunrI/FRf33qRPLr1806PwX3gJS1F8DaSXVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022848; c=relaxed/simple;
	bh=OToJF4gaRfRbxYvgA4rj1ecG7bzZ0MA64jct9Z1Ncz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCtGT6KJiQDoVSa6IlrQVNAyy+9Vy/yL29QDOs4D6veFxoGtWRylgUxRVDxQmgi2gMlkqRtDXMHZboFiQPpDSKsUY3qoej+ISq0Cu3tua+M0X0H93lrjnZ6aKzFhuigEb+sWTIo6kyS19ah54/fwSr/p95oDbGBCBDQs7I0hSZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3yxEqKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3yxEqKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A05C4CEF6;
	Tue, 12 Aug 2025 18:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022848;
	bh=OToJF4gaRfRbxYvgA4rj1ecG7bzZ0MA64jct9Z1Ncz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3yxEqKzanXr/KD9IRhmTaEdHCpFsevkqHmi3I4tpTWDyK9llkyYR+NUFFE9GGcmf
	 UBpIbBgGtVseOUbioXz+3pF8Ei0+NS+asSVPh4duo7b0PCZEBUdtDgKDFSQW3mFc9z
	 Or/fsmPHRWhfXmk1zieloV5JsiTxmpQWK/SHSwwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 249/369] f2fs: turn off one_time when forcibly set to foreground GC
Date: Tue, 12 Aug 2025 19:29:06 +0200
Message-ID: <20250812173024.129852096@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 8142daf8a53806689186ee255cc02f89af7f8890 ]

one_time mode is only for background GC. So, we need to set it back to
false when foreground GC is enforced.

Fixes: 9748c2ddea4a ("f2fs: do FG_GC when GC boosting is required for zoned devices")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index cd56c0e66657..c0e43d6056a0 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1899,6 +1899,7 @@ int f2fs_gc(struct f2fs_sb_info *sbi, struct f2fs_gc_control *gc_control)
 	/* Let's run FG_GC, if we don't have enough space. */
 	if (has_not_enough_free_secs(sbi, 0, 0)) {
 		gc_type = FG_GC;
+		gc_control->one_time = false;
 
 		/*
 		 * For example, if there are many prefree_segments below given
-- 
2.39.5



