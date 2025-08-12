Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508BC28505A;
	Tue, 12 Aug 2025 19:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026505; cv=none; b=i9fKXChKGVX/wUUK1NS9ODKOR9y9UUf0jgFgEsFKtRBzkBKn3TuekbiiXm/1r9gqN/EBnpsG024N+CGGtftIMjuBTsZg1FRzOfG3EYV+/NfIihRznr10JYhohxQW6uDtG1pYBiJlC+S22/2oHOjDg6Aw0iCEtD6O4qFoc0t5m74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026505; c=relaxed/simple;
	bh=cdgK03atgl29ZPWQHXXJ3EGoCkEV9DsOTNuJvZOtPE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxDe+twHIXG9kZspIpBB5+wkc4/8v9riCtlHo9EpBG/XMexTPDkIdiqIwJRk//fKvnP9WYGoshKDVaI+wuoJBxzA08P2CMffO3SqpXFYq0Ub00fmeWzvtlTD9LGk34vG5X77wI4s9aCBtCvZyDLgmT9/S8tSNATRET9q6n0G3OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehBit2cu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehBit2cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACF0C4CEF0;
	Tue, 12 Aug 2025 19:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026505;
	bh=cdgK03atgl29ZPWQHXXJ3EGoCkEV9DsOTNuJvZOtPE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehBit2cuBPRF/I/f4yH7FbxSi/xRhbB3EcAaOR31g1wSL3e+x4uYZbx+QSl3QQbuu
	 6Dw4nuqkzpAMyEP2CpjOh6UnOAdouQAzP2VMZzfB8INQ5crVBk5csw4L3z0mQ91/F4
	 yGDgvAx0Twmx/QH1TzLXUecpYX9v2YsCZinGGMBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 357/480] f2fs: fix to update upper_p in __get_secs_required() correctly
Date: Tue, 12 Aug 2025 19:49:25 +0200
Message-ID: <20250812174412.159122103@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 503f6df690bf..4c3a0d54be7e 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -633,7 +633,7 @@ static inline void __get_secs_required(struct f2fs_sb_info *sbi,
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



