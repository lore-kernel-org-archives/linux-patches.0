Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B26926E145;
	Tue,  8 Apr 2025 12:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115862; cv=none; b=fuLEO8t9YQ8JC6LxDpcnBK1q1T0c9sQhQpagiRfC2q2nIUhz+3CnWeD32H5Vewkwj3iTWQXmMoTt4TDf+t9mnoQezdJhsxnc6dbH1APyrp6nX2LAWS/cd8lKPuraiP6xtjmDVnR0hO/wC2qIq/QeJgtZQtqeU3p+uLKYM0Ex/9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115862; c=relaxed/simple;
	bh=zzXCVHfEtTfbe7oex4QxNJJ3ZAbAxXHGjvO78mnxU8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LupjxiGNtPrcjULJpPy1cukKP8x1yoeVX00iim/wJRL228uRMkMotCw+gHyv6NEpbgjZHnTY4gmnFl9jGSSaG6g3ganIOlbl+ScHZANAtBGj1tXSbfPMTa2navDu8JrtOjNmjiiXJSozWVsUDpYXvUdlAcIZJYiK0IuYLg7hTbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3JLsZwr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3JLsZwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D029C4CEE5;
	Tue,  8 Apr 2025 12:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115862;
	bh=zzXCVHfEtTfbe7oex4QxNJJ3ZAbAxXHGjvO78mnxU8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3JLsZwr1F5eDAI9Ekns02IpDc3BzHuMdQy1bTo6g3vmB1FZEUhb2JlTW4+MAa5cC
	 ylaLkjVOSsCiNzWHMpwmAKyQ4Fj/6RxQLsj0nk3xGDV2Ls5maRJnuMiNRBb04+BAGl
	 4Ub7a2GA3nWLrX5sNdxXv5nSKQ0h0ZZWiW31RHbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Tatham <anakin@pobox.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/204] affs: dont write overlarge OFS data block size fields
Date: Tue,  8 Apr 2025 12:51:03 +0200
Message-ID: <20250408104824.202833423@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

From: Simon Tatham <anakin@pobox.com>

[ Upstream commit 011ea742a25a77bac3d995f457886a67d178c6f0 ]

If a data sector on an OFS floppy contains a value > 0x1e8 (the
largest amount of data that fits in the sector after its header), then
an Amiga reading the file can return corrupt data, by taking the
overlarge size at its word and reading past the end of the buffer it
read the disk sector into!

The cause: when affs_write_end_ofs() writes data to an OFS filesystem,
the new size field for a data block was computed by adding the amount
of data currently being written (into the block) to the existing value
of the size field. This is correct if you're extending the file at the
end, but if you seek backwards in the file and overwrite _existing_
data, it can lead to the size field being larger than the maximum
legal value.

This commit changes the calculation so that it sets the size field to
the max of its previous size and the position within the block that we
just wrote up to.

Signed-off-by: Simon Tatham <anakin@pobox.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/affs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index a7c9538214878..52d11931025cf 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -724,7 +724,8 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
 		tmp = min(bsize - boff, to - from);
 		BUG_ON(boff + tmp > bsize || tmp > bsize);
 		memcpy(AFFS_DATA(bh) + boff, data + from, tmp);
-		be32_add_cpu(&AFFS_DATA_HEAD(bh)->size, tmp);
+		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(
+			max(boff + tmp, be32_to_cpu(AFFS_DATA_HEAD(bh)->size)));
 		affs_fix_checksum(sb, bh);
 		mark_buffer_dirty_inode(bh, inode);
 		written += tmp;
-- 
2.39.5



