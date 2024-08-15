Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D954363D5;
	Thu, 15 Aug 2024 14:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732478; cv=none; b=bd9jtQCzE31RcNCFQcd7KBDUIo4aaOXp1VDAyER8p/JPj0VUUzIYaGq90m0r8u9JlARYgow+yi5/o+6/Z+y61MhhdTEBDahMlj0ktzZEqS5XnWVetVRzMIyE6IDGS18fFCyjbB6Lj+IvjnwevuhKMM51hWWJfNB/uu79I+lU2LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732478; c=relaxed/simple;
	bh=9jJhwibwyA8K8RTLQAiZ5ii263MBrjbg1IwdlUSEQQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujHkcLgm6slHBLZcl80IEz/V7kMQqUdz0rTJPpS8tkTtfox1KqXmCsJ1t4fpj0I3mOLaMFirDCuctM7RdNMeMNBlK3/ylzKtYM+/Zo8ngHsID3UDTBjyEKslSwqcnArmoloax8C4VwTI4EphOxy454Q1cPgqQmYqSCLwMITpaNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GRPZRMP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GRPZRMP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4451C32786;
	Thu, 15 Aug 2024 14:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732478;
	bh=9jJhwibwyA8K8RTLQAiZ5ii263MBrjbg1IwdlUSEQQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRPZRMP67Iej8+Sf56Ks1bdpdTtmDchMJvgrjoaKlhYLqhmIC+RXWKgrRs0VfcaZh
	 8PQmPe3Pz9vGN8NeJ7LqckxDcK7L6gJCkaJ+OvezJXr2ruWJvW8ud/2xxp8MQg4w2n
	 MxhrbXO0gqq+XKs6LorjmbwpGpyUrO6x0B5CTNI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/352] f2fs: fix start segno of large section
Date: Thu, 15 Aug 2024 15:24:18 +0200
Message-ID: <20240815131926.698186646@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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
index 979296b835b5a..665e0e186687d 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -371,7 +371,8 @@ static inline unsigned int get_ckpt_valid_blocks(struct f2fs_sb_info *sbi,
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



