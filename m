Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7825A279915;
	Tue, 12 Aug 2025 17:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021003; cv=none; b=RYtk5jaI+Us4/619u0EHxf08KAJpok26gF18Cfdcz3POgLQ95eBtb0pApdsWk8Q2GRcxrFaaIofSkzGG/pgDqbeQXSiYWNgcA5BPoOb0aXpTB2i+c2EAtrSsP+vYum1l/eTLfnBfd1fjFn8TELDIsP5zVjQ5yDuRA7fetpj67NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021003; c=relaxed/simple;
	bh=i7579eaHYR9MmV2CBviSzJsIge3z1DOwWsG7LqZb6JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2hHta95ICkTDC3i/dUMu8Syp2DJngK870E6Z2f6BPQiVzIeb4I3Mp0ToH92u/YsQf4UQPkpL7+RInNspMpw7fUmK94ZiWNb8p8b3+M9bAazlvZXdun8SrB6rwDr4ZeqO3ktnaFpw0aqwt8mx3/+FB7UH3QrIKTaYoejmUL1VnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UE1ZeMa3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UE1ZeMa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7CFC4CEF6;
	Tue, 12 Aug 2025 17:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021003;
	bh=i7579eaHYR9MmV2CBviSzJsIge3z1DOwWsG7LqZb6JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UE1ZeMa3OKVFgbF7b5Duxr0tpi88NT5TD+NDtOyc8ZNCBO5x/CtzLsnBVMvi6R1by
	 8CFOOMi1L3nd17gPI382GHm+fyil+WZAwKcnxfUP0IQvobwyslKNiiswFupq5lcciT
	 GQJt2QKTHwSyfpH/SHbJ5dlnFh3fivB9XhgK/T9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 198/253] f2fs: fix to update upper_p in __get_secs_required() correctly
Date: Tue, 12 Aug 2025 19:29:46 +0200
Message-ID: <20250812172957.229740328@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5ef5a88f47a0..3f1d6cdd4ae0 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -635,7 +635,7 @@ static inline void __get_secs_required(struct f2fs_sb_info *sbi,
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



