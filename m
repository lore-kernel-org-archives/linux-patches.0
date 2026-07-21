Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5C64195C9;
	Tue, 21 Jul 2026 19:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660460; cv=none; b=dwMbRjcUS5NDHWifSEjEk+XjTMqKpxbImxitZgJqbFCf8/PV46d3m24/GPb6UuN60Rvr8P8K3Aa3/9Ahr6VBr7babYoTrn0nBAyFhYSa2SLrh9QAUU7kMi/a1TCGbQ499NOsqlraI+DfohnVkhX1QwGxCiJ9CyRuBji65svNEg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660460; c=relaxed/simple;
	bh=kHNZ2nNWc/IH+gOYA3hd5q94npz/ZgB5togCgJlEeps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bx4kObyo4p1qeRJUMpxMMRS6ngtpSWnTXqzqzLHn/DuWpvVSwDoDZbxvShcJyfOd0fR4iQpNLcMT2MMqSoUNg2afe4xahr0dKLcApJ4HE4qwNGvREPDS4y11FqSlyFWttwAky+Zbsdp6JcGI3cT570PAG00vkuoCUkBRoQWKuWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIvalmuX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIvalmuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFEC1F00A3E;
	Tue, 21 Jul 2026 19:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660430;
	bh=/Wyhr8VzLyd4CjdPSW03ug0HGZAkQx6jVQSOnCYUdZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gIvalmuXDRQp4pNix80Ov5RJKHENbF3eb1F+pK8w4zagQ09ndaGvY7T5PoRydopzM
	 SyY5qn9hq4Me651ih0PhJj2jAC/vIgpCU44Lyj1+q50i5fEln0NRI6ui+grzeHQE+9
	 c7a3yrEW/Z2Pbh6s1P7MqyQjOVMq3zhymqzUP0O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c2cfe997245202e46f10@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0978/2077] fs/ntfs3: prevent potential lcn remains uninitialized
Date: Tue, 21 Jul 2026 17:10:51 +0200
Message-ID: <20260721152615.887217729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 57ac2831c8e0f168090d38e3de758c6a59db44db ]

The target VCN being sought was not found within runs[0], causing
run_lookup() to return false. This causes run_lookup_entry() to return
false, which in turn results in a len value of 0, and the new parameter
passed to attr_data_get_block() is NULL. Collectively, these factors
ultimately cause attr_data_get_block_locked() to exit prematurely without
initializing lcn, thereby triggering [1].

To prevent [1], the clen check within ni_seek_data_or_hole() has been
moved to occur before the lcn check.

[1]
BUG: KMSAN: uninit-value in ni_seek_data_or_hole+0x24f/0x5f0 fs/ntfs3/frecord.c:2862
 ni_seek_data_or_hole+0x24f/0x5f0 fs/ntfs3/frecord.c:2862
 ntfs_llseek+0x22a/0x4a0 fs/ntfs3/file.c:1530
 vfs_llseek fs/read_write.c:391 [inline]

Fixes: c61326967728 ("fs/ntfs3: implement llseek SEEK_DATA/SEEK_HOLE by scanning data runs")
Reported-by: syzbot+c2cfe997245202e46f10@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c2cfe997245202e46f10
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index bb3348f256d997..974c55ae2c0145 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2859,6 +2859,11 @@ loff_t ni_seek_data_or_hole(struct ntfs_inode *ni, loff_t offset, bool data)
 			return err;
 		}
 
+		if (!clen) {
+			/* Corrupted file. */
+			return -EINVAL;
+		}
+
 		if (lcn == RESIDENT_LCN) {
 			/* clen - resident size in bytes. clen == ni->vfs_inode.i_size */
 			if (offset >= clen) {
@@ -2909,10 +2914,6 @@ loff_t ni_seek_data_or_hole(struct ntfs_inode *ni, loff_t offset, bool data)
 			}
 		}
 
-		if (!clen) {
-			/* Corrupted file. */
-			return -EINVAL;
-		}
 	}
 }
 
-- 
2.53.0



