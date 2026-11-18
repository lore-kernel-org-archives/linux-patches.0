Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054063;
	b=v9IDJt7UUSzf4fnMBy81EBIl8KNlYccWSU7vj3YbvJjjxY/+SywaSSJpOPlnEOVeunBm
	 NXE6uAq+xDRL7U/G3hZWWeSooOhNfDWPujS7CEu/7vXBEzEyD/9x/TTkprFZT9qNvdpZN
	 cO3CIAhAA1IYUHFYnsafUIChQpuQTFOOSaaIEgo//foqFjScck0RxVHOIEQKhJgL8Syho
	 lQ1xujyr8xbZ9nrgXmwardIOYQvZugDfnv/aVrJdAWINFX1q/4q04cBQmSp7mef3jLBYr
	 dHpzSB9p7kQCsyMfftjoD1/G0zF2gOysTSeaqiOVx32wl0/INZYuBjkELrNs2qEF+kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FCQDHixJLo+atN/OpsWtc2l4VtE6n36aN34fSZzErSg=;
	b=JuVthiT5bmgUKDQC14Cjs67lUmuZZuXu4nNAVwe1MWFGiIay55meFAtwvzUvFelUYcpw
	 IYeDoA+mFbosDS/ADi5T7+p69ujF0dIPGRdj6cNkbNQx2ZuG/DZbGw69guDAtvn1L+YeC
	 vpk7OQLHnnjs+g4iT18ObtQj6ovMECN+Z23YjzI/+En/LHnvHdOuJRfYZLDyyPB07Ryxh
	 rtRr/lRjbzspJn3U2aV4j5v2GeV34s0Vx4xXhBYdOWONLGEiYXlABX01tSx6WhtzNCqG6
	 Hgf0CpbnEkpt+mJGujy2zfIArTZnbcnwlpAaW4DJ1++VibF117bp44vGz2nYCRig1ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EdSZH0iu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69342606A31C;
	Thu, 19 Nov 2026 02:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EdSZH0iu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821B61F000C4;
	Thu, 19 Nov 2026 02:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054063;
	bh=FCQDHixJLo+atN/OpsWtc2l4VtE6n36aN34fSZzErSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdSZH0iu2mr8BPVGMbXm8srVngtjdBHqFyQy5oqOZOyr0caWas6b35mdnr3cJA1d/
	 ghc5ijwMIVfcAvIipbV5H/cBFG6YwF77aejDpcagS13jYuE0QbajA4WZ+calNQC/hA
	 vLg34Pfoa7MhVdJ9YjEUJliJQ8QGLtlL2gCwpTt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1140/2214] ext4: commit super block if fs record error when journal record without error
Date: Wed, 18 Nov 2026 15:46:56 +0100
Message-ID: <20261118150057.630506961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit eee00237fa5ec8f704f7323b54e48cc34e2d9168 ]

Now, 'es->s_state' maybe covered by recover journal. And journal errno
maybe not recorded in journal sb as IO error. ext4_update_super() only
update error information when 'sbi->s_add_error_count' large than zero.
Then 'EXT4_ERROR_FS' flag maybe lost.
To solve above issue just recover 'es->s_state' error flag after journal
replay like error info.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230307061703.245965-2-yebin@huaweicloud.com
Stable-dep-of: e1a881ea4674 ("ext4: fix fast commit replay failing on a read-only mount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c89e460180b82..ae0509f6936e8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5400,6 +5400,7 @@ static int ext4_load_journal(struct super_block *sb,
 		err = jbd2_journal_wipe(journal, !really_read_only);
 	if (!err) {
 		char *save = kmalloc(EXT4_S_ERR_LEN, GFP_KERNEL);
+
 		if (save)
 			memcpy(save, ((char *) es) +
 			       EXT4_S_ERR_START, EXT4_S_ERR_LEN);
@@ -5408,6 +5409,14 @@ static int ext4_load_journal(struct super_block *sb,
 			memcpy(((char *) es) + EXT4_S_ERR_START,
 			       save, EXT4_S_ERR_LEN);
 		kfree(save);
+		es->s_state |= cpu_to_le16(EXT4_SB(sb)->s_mount_state &
+					   EXT4_ERROR_FS);
+		/* Write out restored error information to the superblock */
+		if (!bdev_read_only(sb->s_bdev)) {
+			int err2;
+			err2 = ext4_commit_super(sb);
+			err = err ? : err2;
+		}
 	}
 
 	if (err) {
-- 
2.53.0



