Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99E479C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C27C433F2;
	Thu, 12 Jan 2023 14:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534157;
	bh=dIihYNA1092HaGQzjHPSIWV5NehWwXLfys5dzNJkMVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDAYnJZP5JJGOd762JbrKZ999xUmYYWJ3sEDx3QcC35wXwUYMExX9STNKa7NDSN4A
	 QUn1+tjNaQgzyAiPrv5Rk2XIPoLo4wQxnSanKfcmf3zR7wIsny/EZ7zQtbQMcbDPLk
	 URs+IX+cergvQ58pIvSLIFhjWKol4/toiwcy41Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 715/783] ext4: fix leaking uninitialized memory in fast-commit journal
Date: Thu, 12 Jan 2023 14:57:11 +0100
Message-Id: <20230112135557.518429332@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 594bc43b410316d70bb42aeff168837888d96810 ]

When space at the end of fast-commit journal blocks is unused, make sure
to zero it out so that uninitialized memory is not leaked to disk.

Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221106224841.279231-4-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/fast_commit.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 3b2d6106a703..eaa26477bceb 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -628,6 +628,9 @@ static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 		*crc = ext4_chksum(sbi, *crc, tl, sizeof(*tl));
 	if (pad_len > 0)
 		ext4_fc_memzero(sb, tl + 1, pad_len, crc);
+	/* Don't leak uninitialized memory in the unused last byte. */
+	*((u8 *)(tl + 1) + pad_len) = 0;
+
 	ext4_fc_submit_bh(sb);
 
 	ret = jbd2_fc_get_buf(EXT4_SB(sb)->s_journal, &bh);
@@ -684,6 +687,8 @@ static int ext4_fc_write_tail(struct super_block *sb, u32 crc)
 	dst += sizeof(tail.fc_tid);
 	tail.fc_crc = cpu_to_le32(crc);
 	ext4_fc_memcpy(sb, dst, &tail.fc_crc, sizeof(tail.fc_crc), NULL);
+	dst += sizeof(tail.fc_crc);
+	memset(dst, 0, bsize - off); /* Don't leak uninitialized memory. */
 
 	ext4_fc_submit_bh(sb);
 
-- 
2.35.1



