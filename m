Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24BE18454A;
	Tue, 30 Jul 2024 17:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359699; cv=none; b=GDM0vpmGd3Du2q49lx6L7XZz/Eog3EysgrdfOOLYeKP/BqFl+dYmNF4CIcxYZKwfbvDoPSiuhxSIc9m6pp5StrMsXSxw9ZI+H1eOJLz1oPut6XAhnNjIdgOnU7HA50dmYCGHVqV74+tsF8qSPdpVApLAzk1bUTmq9LLW5FbERkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359699; c=relaxed/simple;
	bh=92sXEXjpVGpTutLx/DWQ+GF2uIMM+u9q2T7zhtGHISg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cz8Su0Pa+iPQyVN5nHfqpCqQbzvfeRD4b6SFKr8SYdu7by4ocqfom0lAoIRM1vet4iFVosmQ3k6prsbWc0NCnbEcjwbGQ3i/wgwVCO0qrudM9qj32p5n1D/W/l0c2KZKnLfyh/6/V6JP7OnbVRLx2zmr2g/gbiH9qx+8gg4UPtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOf5/7KQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOf5/7KQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7EAC32782;
	Tue, 30 Jul 2024 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359699;
	bh=92sXEXjpVGpTutLx/DWQ+GF2uIMM+u9q2T7zhtGHISg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOf5/7KQmdQBiSkj2BbvYxYEg7oVMqBNaAwDmgKQOQ1zsG5mK/0vo5nl/+FpL4VdX
	 fjDVnLZborvwV8mQwKumVoNW75MHIoOW0f/nHspL5VoJTgyokbmXhnZh0TAu70+qEf
	 nAr6wm8JAwzabhJ85wLdhoNBSr0u8Cl9rHVRVMbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 524/568] f2fs: fix start segno of large section
Date: Tue, 30 Jul 2024 17:50:31 +0200
Message-ID: <20240730151700.641628793@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Sheng Yong <shengyong@oppo.com>

[ Upstream commit 8c409989678e92e4a737e7cd2bb04f3efb81071a ]

get_ckpt_valid_blocks() checks valid ckpt blocks in current section.
It counts all vblocks from the first to the last segment in the
large section. However, START_SEGNO() is used to get the first segno
in an SIT block. This patch fixes that to get the correct start segno.

Fixes: 61461fc921b7 ("f2fs: fix to avoid touching checkpointed data in get_victim()")
Signed-off-by: Sheng Yong <shengyong@oppo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 4595f1cc03828..952970166d5da 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -348,7 +348,8 @@ static inline unsigned int get_ckpt_valid_blocks(struct f2fs_sb_info *sbi,
 				unsigned int segno, bool use_section)
 {
 	if (use_section && __is_large_section(sbi)) {
-		unsigned int start_segno = START_SEGNO(segno);
+		unsigned int secno = GET_SEC_FROM_SEG(sbi, segno);
+		unsigned int start_segno = GET_SEG_FROM_SEC(sbi, secno);
 		unsigned int blocks = 0;
 		int i;
 
-- 
2.43.0



