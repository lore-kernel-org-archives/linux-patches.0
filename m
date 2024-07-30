Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6753B1A76A5;
	Tue, 30 Jul 2024 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359522; cv=none; b=HCqxiK8Qgq+VmYB+E+wdtdNMimGj0Ix87iVmWjmXD4dyuzkmOyHaQHdTTtwdS0HLD+gpet8qCs2k2r6JMAFXGxIt1Py/RIyBed6dhftvOJEZKh+pazaFI/tpmPpLgs9cOxw23xRjeJ0xJhjIMpAHoaLqJu6bzKqIO/f+nj9lL5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359522; c=relaxed/simple;
	bh=tUpKNQOHqy2rPtM6UFSxOUKDEw/ClKOGtx/4rirR1p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeh6/RZSXZb+wFOfNkL5don3eMJH/9H7s5lZwCH5km7jIJB8qgpWh1vu9zE0ePg1BTcLO41e+iM045o46ztkz818678s6doXGKEG4ez9Mg5nmzr/V8ARWTC/HtWllTKZZwBGoiXfHioUvF9Yri6dpUswuxm7oeoRHGA7CLqZwjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2/iCqh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2/iCqh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC84FC4AF0A;
	Tue, 30 Jul 2024 17:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359522;
	bh=tUpKNQOHqy2rPtM6UFSxOUKDEw/ClKOGtx/4rirR1p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2/iCqh2UBBrXch/7jHkNz31m/g/k6k+lhbcn2Lzpt8zi5ufcXiVYWTT1oJS+VPDT
	 7Fmr+qW+hI/TWQeTjc0P5JkV113Eg3bDCN/j3eOXoECBTH4wvH4biZz+M/Yfz2UI5B
	 9O0qox2vjBlYtX7TnsEMnhJ12ewsnFH08jPruyfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 496/809] fs/ntfs3: Correct undo if ntfs_create_inode failed
Date: Tue, 30 Jul 2024 17:46:12 +0200
Message-ID: <20240730151744.327749621@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit f28d0866d8ff798aa497971f93d0cc58f442d946 ]

Clusters allocated for Extended Attributes, must be freed
when rolling back inode creation.

Fixes: 82cae269cfa95 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index bef3b4a36b750..9559d72f86606 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1668,7 +1668,9 @@ int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 	 * The packed size of extended attribute is stored in direntry too.
 	 * 'fname' here points to inside new_de.
 	 */
-	ntfs_save_wsl_perm(inode, &fname->dup.ea_size);
+	err = ntfs_save_wsl_perm(inode, &fname->dup.ea_size);
+	if (err)
+		goto out6;
 
 	/*
 	 * update ea_size in file_name attribute too.
@@ -1712,6 +1714,12 @@ int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 	goto out2;
 
 out6:
+	attr = ni_find_attr(ni, NULL, NULL, ATTR_EA, NULL, 0, NULL, NULL);
+	if (attr && attr->non_res) {
+		/* Delete ATTR_EA, if non-resident. */
+		attr_set_size(ni, ATTR_EA, NULL, 0, NULL, 0, NULL, false, NULL);
+	}
+
 	if (rp_inserted)
 		ntfs_remove_reparse(sbi, IO_REPARSE_TAG_SYMLINK, &new_de->ref);
 
-- 
2.43.0



