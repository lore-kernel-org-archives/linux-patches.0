Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2171200BA
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FP42yc+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64928C433C7;
	Mon,  6 Nov 2023 13:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276568;
	bh=8vmI0vCoI7cr86jiryB4BJkNabliJuSlpVlft2f3VG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FP42yc+oAmAU/kFC7WTbTUH7Nw0ouYgm6NPLzsyua9Ysgl/FpVxjYji7KiqeXb52G
	 h7+LVW3zTu1XOwdpoOOAWTRdK6QZa9zJy5c/BP49OSThBfnj9qNAYl8v62Z/qjXzy3
	 JK+xJh4KXEJGug4zdjWhzxlipzPdj1X99L3pU9ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 24/88] fs/ntfs3: Add more info into /proc/fs/ntfs3/<dev>/volinfo
Date: Mon,  6 Nov 2023 14:03:18 +0100
Message-ID: <20231106130306.672560246@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit d27e202b9ac416e52093edf8789614d93dbd6231 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 9124d74ea676b..d699819c70a14 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -453,15 +453,23 @@ static struct proc_dir_entry *proc_info_root;
  * ntfs3.1
  * cluster size
  * number of clusters
+ * total number of mft records
+ * number of used mft records ~= number of files + folders
+ * real state of ntfs "dirty"/"clean"
+ * current state of ntfs "dirty"/"clean"
 */
 static int ntfs3_volinfo(struct seq_file *m, void *o)
 {
 	struct super_block *sb = m->private;
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
 
-	seq_printf(m, "ntfs%d.%d\n%u\n%zu\n", sbi->volume.major_ver,
-		   sbi->volume.minor_ver, sbi->cluster_size,
-		   sbi->used.bitmap.nbits);
+	seq_printf(m, "ntfs%d.%d\n%u\n%zu\n\%zu\n%zu\n%s\n%s\n",
+		   sbi->volume.major_ver, sbi->volume.minor_ver,
+		   sbi->cluster_size, sbi->used.bitmap.nbits,
+		   sbi->mft.bitmap.nbits,
+		   sbi->mft.bitmap.nbits - wnd_zeroes(&sbi->mft.bitmap),
+		   sbi->volume.real_dirty ? "dirty" : "clean",
+		   (sbi->volume.flags & VOLUME_FLAG_DIRTY) ? "dirty" : "clean");
 
 	return 0;
 }
-- 
2.42.0



