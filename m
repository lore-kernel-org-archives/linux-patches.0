Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE8A268C72;
	Tue,  8 Apr 2025 11:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111504; cv=none; b=fyEqJ5WoXBQM7G8ymeDiYStsFJuG9qtOxXnI8qYbOu4o58tg1mNXYb9Fieej7Rx5oCaFQwXGTibTx5euFbfsmSCc8UPTnLexlNky8NEEuO6LSvNiPKCOlWIu5VCpq4yraLQIJHo2/P8j4WeCxYG8GE3yPaNeEzx8FNhrl0eGgi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111504; c=relaxed/simple;
	bh=+xa3eLpnwNQa4q12RNTp+uYb9wqDLfu5TWmAnS81Tks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYdbmBG3E+dh8IP5gTfoedAnjgCKHR/cdyxZjcjpj0ewMqDq7FZ8X4RV3Fn3CZT5nd1pW74N7H/NBf58cOOyF5AEAfEzDgOliVLEq+I1N2m963LOP+c9OYXflcg26M/ytJqOZwD74Oa6bgAIyDYQTTWPlsnU26IKHi7FRRo/3vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rK9TVsYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rK9TVsYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB0DC4CEEA;
	Tue,  8 Apr 2025 11:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111504;
	bh=+xa3eLpnwNQa4q12RNTp+uYb9wqDLfu5TWmAnS81Tks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rK9TVsYEGGlLZBGrN5pwIE8a6n8ZixMrODaMFo2TWp/AC4vWlLXfICQTyffpDUOki
	 KJMoBVyz9D2fZsrIGjMNGh95heNWFPPSow8mXKNlTZHKmf/g7eG5NX+z5vLrkVuTJY
	 FV7DRV+VNQu4bMrsx0KSzDRGt5r+Hf1tzv/8wi6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+812641c6c3d7586a1613@syzkaller.appspotmail.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 454/731] isofs: fix KMSAN uninit-value bug in do_isofs_readdir()
Date: Tue,  8 Apr 2025 12:45:51 +0200
Message-ID: <20250408104924.839796608@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

[ Upstream commit 81a82e8f33880793029cd6f8a766fb13b737e6a7 ]

In do_isofs_readdir() when assigning the variable
"struct iso_directory_record *de" the b_data field of the buffer_head
is accessed and an offset is added to it, the size of b_data is 2048
and the offset size is 2047, meaning
"de = (struct iso_directory_record *) (bh->b_data + offset);"
yields the final byte of the 2048 sized b_data block.

The first byte of the directory record (de_len) is then read and
found to be 31, meaning the directory record size is 31 bytes long.
The directory record is defined by the structure:

	struct iso_directory_record {
		__u8 length;                     // 1 byte
		__u8 ext_attr_length;            // 1 byte
		__u8 extent[8];                  // 8 bytes
		__u8 size[8];                    // 8 bytes
		__u8 date[7];                    // 7 bytes
		__u8 flags;                      // 1 byte
		__u8 file_unit_size;             // 1 byte
		__u8 interleave;                 // 1 byte
		__u8 volume_sequence_number[4];  // 4 bytes
		__u8 name_len;                   // 1 byte
		char name[];                     // variable size
	} __attribute__((packed));

The fixed portion of this structure occupies 33 bytes. Therefore, a
valid directory record must be at least 33 bytes long
(even without considering the variable-length name field).
Since de_len is only 31, it is insufficient to contain
the complete fixed header.

The code later hits the following sanity check that
compares de_len against the sum of de->name_len and
sizeof(struct iso_directory_record):

	if (de_len < de->name_len[0] + sizeof(struct iso_directory_record)) {
		...
	}

Since the fixed portion of the structure is
33 bytes (up to and including name_len member),
a valid record should have de_len of at least 33 bytes;
here, however, de_len is too short, and the field de->name_len
(located at offset 32) is accessed even though it lies beyond
the available 31 bytes.

This access on the corrupted isofs data triggers a KASAN uninitialized
memory warning. The fix would be to first verify that de_len is at least
sizeof(struct iso_directory_record) before accessing any
fields like de->name_len.

Reported-by: syzbot <syzbot+812641c6c3d7586a1613@syzkaller.appspotmail.com>
Tested-by: syzbot <syzbot+812641c6c3d7586a1613@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=812641c6c3d7586a1613
Fixes: 2deb1acc653c ("isofs: fix access to unallocated memory when reading corrupted filesystem")
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250211195900.42406-1-qasdev00@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index eb2f8273e6f15..09df40b612fbf 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -147,7 +147,8 @@ static int do_isofs_readdir(struct inode *inode, struct file *file,
 			de = tmpde;
 		}
 		/* Basic sanity check, whether name doesn't exceed dir entry */
-		if (de_len < de->name_len[0] +
+		if (de_len < sizeof(struct iso_directory_record) ||
+		    de_len < de->name_len[0] +
 					sizeof(struct iso_directory_record)) {
 			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
 			       " in block %lu of inode %lu\n", block,
-- 
2.39.5



