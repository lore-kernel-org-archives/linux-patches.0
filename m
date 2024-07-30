Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1960717D8BB;
	Tue, 30 Jul 2024 16:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358748; cv=none; b=Yv4jJFV4eBPm0aGfPA1csWZxNRrVdKyUZqHU96AQh+/Y1UFJV9HDWVbqMP5WOW/85xdVwKWL6F9mTw1yUdNXGeKkgRlSfw3w0xJL1ABabmcb+Jqlc6RpNCdQ3Ehu61nhsugk/IMq9nZRahkdN1vtFMd64vDdOeJ/t30TfdRED0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358748; c=relaxed/simple;
	bh=f06Xkzmeal5EvaiI34vuKSVZWzT1uNvb8nYmLbWlHfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egt3l50dLR7Cl/7+DPF62PFyou1jZaLq8es3s9s3RRxTIGsE6PMKD49A7SkeAkMaQA9Ho07Jv49yuORhm4GJ2Zjinr8I8Uyp3aCXSHkas4rhek4oKZHuUjsTOCuLySvRPuyikkCop2Rpm66I681kvWfcvlv88+5bGJUAmnGwBW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8ip2RXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8ip2RXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B9BC32782;
	Tue, 30 Jul 2024 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358747;
	bh=f06Xkzmeal5EvaiI34vuKSVZWzT1uNvb8nYmLbWlHfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8ip2RXkW06dY/4Ntkje+WU8ZMLji7a2mlECNl3hFgPiwCjCa7hELfKJqexpYcQe4
	 FZV3kkg/LE+GhpU72IjFJVl3eE5yuss7a/aNP9NMvP7sO/BAWatEDG6CnLY0uf96Xp
	 0VyzX2sZZX7PGp9xRpeep12a489aDXDGdutagYuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 400/440] f2fs: fix start segno of large section
Date: Tue, 30 Jul 2024 17:50:33 +0200
Message-ID: <20240730151631.424791626@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aa9ad85e0901d..17d1723d98a0b 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -373,7 +373,8 @@ static inline unsigned int get_ckpt_valid_blocks(struct f2fs_sb_info *sbi,
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



