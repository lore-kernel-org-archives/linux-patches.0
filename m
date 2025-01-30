Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFFE1E3DC8;
	Thu, 30 Jan 2025 14:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246780; cv=none; b=V/VRy8kIe3mHJV8Qe4CBay0fzzq3/l+pahsfGW4d5cnxU58Sdasvkvl2RZ44L7FU2mDnem2vk7ecYmz1PKWwwACaQDxIINFlVkM2bhGjQMNED+UHeMhnzTQaf7CUe4jCf30hXGFYEfTFq6rWKPJ1e/J1NofwzbXZIZMTQYJiM4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246780; c=relaxed/simple;
	bh=bE2Phy68xNFw9n128IntgrF/wRygMzxazV6jLh8TnEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7EvU5QNWKuBWltvWbk9B3g8gSOtQnbKiAS5sbDziw4Vlr7W3ia88e3f0HHhH0u9tXCEEdNaSJPV6VinWGWfdph9lCaG+K+23g8KfYJOLxPfHLRCrZ4ygO5wFGBbMZyVi4Oqb8qMRjS5f+M3qTqv3legLS6EVYHs8LVwEPrJoTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLe+eDo2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLe+eDo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E75C4CED2;
	Thu, 30 Jan 2025 14:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246779;
	bh=bE2Phy68xNFw9n128IntgrF/wRygMzxazV6jLh8TnEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLe+eDo2S2b5qQQiiHGndER/rb9v1+GJjatt3hBLh83xT/MoRy8eAG7cW81GpLqF9
	 w3s+zJ5nYajvEPu4vuE/a65lg3ncwcMMTDJJiWwj366ZZtpu/XNr5iNupcX8D1a07y
	 NB7f1dHkAPMCajzs1rwvBuoHNFLWiqWYIsuobghA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2db3c7526ba68f4ea776@syzkaller.appspotmail.com,
	Leo Stone <leocstone@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 64/91] hfs: Sanity check the root record
Date: Thu, 30 Jan 2025 15:01:23 +0100
Message-ID: <20250130140136.250495423@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Stone <leocstone@gmail.com>

[ Upstream commit b905bafdea21a75d75a96855edd9e0b6051eee30 ]

In the syzbot reproducer, the hfs_cat_rec for the root dir has type
HFS_CDR_FIL after being read with hfs_bnode_read() in hfs_super_fill().
This indicates it should be used as an hfs_cat_file, which is 102 bytes.
Only the first 70 bytes of that struct are initialized, however,
because the entrylength passed into hfs_bnode_read() is still the length of
a directory record. This causes uninitialized values to be used later on,
when the hfs_cat_rec union is treated as the larger hfs_cat_file struct.

Add a check to make sure the retrieved record has the correct type
for the root directory (HFS_CDR_DIR), and make sure we load the correct
number of bytes for a directory record.

Reported-by: syzbot+2db3c7526ba68f4ea776@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2db3c7526ba68f4ea776
Tested-by: syzbot+2db3c7526ba68f4ea776@syzkaller.appspotmail.com
Tested-by: Leo Stone <leocstone@gmail.com>
Signed-off-by: Leo Stone <leocstone@gmail.com>
Link: https://lore.kernel.org/r/20241201051420.77858-1-leocstone@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index bcf820ce0e02e..f82444fbbedcb 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -419,11 +419,13 @@ static int hfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto bail_no_root;
 	res = hfs_cat_find_brec(sb, HFS_ROOT_CNID, &fd);
 	if (!res) {
-		if (fd.entrylength > sizeof(rec) || fd.entrylength < 0) {
+		if (fd.entrylength != sizeof(rec.dir)) {
 			res =  -EIO;
 			goto bail_hfs_find;
 		}
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset, fd.entrylength);
+		if (rec.type != HFS_CDR_DIR)
+			res = -EIO;
 	}
 	if (res)
 		goto bail_hfs_find;
-- 
2.39.5



