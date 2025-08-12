Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304B82E3B06;
	Tue, 12 Aug 2025 18:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022790; cv=none; b=LvoDK5pk0zG3/5C9HH05B4KFYEkBv9QomLRmSS7oZg9mLY0FH+hEIc+Gmbl4QkFJL/e1vCYrBEEm7EoqU4q1qbhUhaWLVCpDewnHpY0GqCmGVmPADc7fwf0Dn6KCrhN0UjPuINYIkIU/kewFuFHR6daX3p7fCjLAE1EwMsMkt4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022790; c=relaxed/simple;
	bh=Ti/oF/SWK/4S4kFWSERqZTymOvJAFHqawvUWcjn7RvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJDIybFuNIAcygIZlewSQuAEgQoTNbeU9Hpny9pbE4iyI1aEDYlh6hiJxbYtrXEZw0tFYx11dqqtvTPzfQxcFNeP1/QCyjhkZQrVvmTUf+Xm3gqO56Z3InvAjn7AmRCOrTbSmdN37VlNQymyOyry7MdxaIvMJhdhEhYuh8qjKz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsZWGBi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsZWGBi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DB2C4CEF6;
	Tue, 12 Aug 2025 18:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022790;
	bh=Ti/oF/SWK/4S4kFWSERqZTymOvJAFHqawvUWcjn7RvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsZWGBi7PNDX/4Jdwq6nTpyP4eDvAtMxC3fn9pZAvoF0/3/g+irFCT9frYYZQsL2b
	 vRGh5zJtUNrt7UkOIYOMPGksZgMIwXlwwaMtbcFBw+fn3em0VXFDWojGYz+S+bjFMd
	 Qej7BaafMqymd2r6epYYIrp8pWot/s3VHYS7cgNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 260/369] f2fs: fix to update upper_p in __get_secs_required() correctly
Date: Tue, 12 Aug 2025 19:29:17 +0200
Message-ID: <20250812173024.545243349@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 6840faddb65683b4e7bd8196f177b038a1e19faf ]

Commit 1acd73edbbfe ("f2fs: fix to account dirty data in __get_secs_required()")
missed to calculate upper_p w/ data_secs, fix it.

Fixes: 1acd73edbbfe ("f2fs: fix to account dirty data in __get_secs_required()")
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 52bb1a281935..7d7d709b55ff 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -636,7 +636,7 @@ static inline void __get_secs_required(struct f2fs_sb_info *sbi,
 	if (lower_p)
 		*lower_p = node_secs + dent_secs + data_secs;
 	if (upper_p)
-		*upper_p = node_secs + dent_secs +
+		*upper_p = node_secs + dent_secs + data_secs +
 			(node_blocks ? 1 : 0) + (dent_blocks ? 1 : 0) +
 			(data_blocks ? 1 : 0);
 	if (curseg_p)
-- 
2.39.5



