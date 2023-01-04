Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EB2AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CF1C433D2;
	Wed,  4 Jan 2023 16:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849367;
	bh=2z7DoMEGqCIdbfUET0488JU6eXbv/aFOkPPIdBMNGPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CulmPNCsE4O8X/z4/zw9wEVPPQkb6UO+id5Ypat4k4f0ix3hl3SXBh9p8XaH2SVVQ
	 L2ekzDUQ/1K0hr27NtTv7V/mrZu/xrDVK/uzoE+K6tKCmqeNi8mvYgPQCA062Wc/zt
	 sdihu7Xq29QRUvDvPwZl+6zjAfm8DhBixvfgiqqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 177/207] ext4: fix leaking uninitialized memory in fast-commit journal
Date: Wed,  4 Jan 2023 17:07:15 +0100
Message-Id: <20230104160517.475882807@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

commit 594bc43b410316d70bb42aeff168837888d96810 upstream.

When space at the end of fast-commit journal blocks is unused, make sure
to zero it out so that uninitialized memory is not leaked to disk.

Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221106224841.279231-4-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -737,6 +737,9 @@ static u8 *ext4_fc_reserve_space(struct
 		*crc = ext4_chksum(sbi, *crc, tl, EXT4_FC_TAG_BASE_LEN);
 	if (pad_len > 0)
 		ext4_fc_memzero(sb, tl + 1, pad_len, crc);
+	/* Don't leak uninitialized memory in the unused last byte. */
+	*((u8 *)(tl + 1) + pad_len) = 0;
+
 	ext4_fc_submit_bh(sb, false);
 
 	ret = jbd2_fc_get_buf(EXT4_SB(sb)->s_journal, &bh);
@@ -793,6 +796,8 @@ static int ext4_fc_write_tail(struct sup
 	dst += sizeof(tail.fc_tid);
 	tail.fc_crc = cpu_to_le32(crc);
 	ext4_fc_memcpy(sb, dst, &tail.fc_crc, sizeof(tail.fc_crc), NULL);
+	dst += sizeof(tail.fc_crc);
+	memset(dst, 0, bsize - off); /* Don't leak uninitialized memory. */
 
 	ext4_fc_submit_bh(sb, true);
 


