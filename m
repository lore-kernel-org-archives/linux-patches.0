Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7AF46C4D8;
	Tue, 21 Jul 2026 17:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655350; cv=none; b=rPAynpg1SQsIzq8EdZPKCh6dVdaSc0wIQF8xyBAMyMtToYno+v1byKY1E20AfQb5794TaRBTbNbV4dUs/NbucTAFpuaH1cT1PwbZ8YumjPbNjQe4zTXxxT6VMJtNy9nTU16sbEZ+3O9+6OLAMN8Wcc8IZCVul1aqEdUFoCyeqls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655350; c=relaxed/simple;
	bh=zy1ucU1f3nfOfjMDs1dap07qig6C5k5dsJat1HN82xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAZfkAGC1/eeORniI11Q7ejys9+2GuT1md5MexyH5zEDIUrNPoJK+snTDVfmpOgtC9hB7qlXFVLHNTZWFvGQ7GYRxLNbvWlO4R1EiS99BmhqU05kk5H0kcXJKwVYH9ea1Z3T3mYwUOH/MmKg78WJ7s9wP62XOrXahwf+nFVsHp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ln5/V2D4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ln5/V2D4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEBD1F000E9;
	Tue, 21 Jul 2026 17:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655348;
	bh=9TOYunOO2zIwaTqFNVjiN3zNc+9TO4AOi4XvLwvc3s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ln5/V2D4urRts0Kli6/h+pfN6arT/hh5ulRESUCDA3DPQ5eWuc9SDwvNjRSaeFtKh
	 f1kI8x2d52OzYCSUrSVz9G6JX6li2OjIm1aNSxTfLo6ZMBq/OqcH9Of3ZsXsZrflMz
	 0Y3639m0jc7E7Hs8IKH3f+Amxi6gpLidJtak2X0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Keshav Verma <iganschel@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 2050/2077] f2fs: fix listxattr handling of corrupted xattr entries
Date: Tue, 21 Jul 2026 17:28:43 +0200
Message-ID: <20260721152641.054491929@linuxfoundation.org>
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

From: Keshav Verma <iganschel@gmail.com>

[ Upstream commit 5ef5bc304f23c3fe255d4936472378dcb74d0e94 ]

Validate the xattr entry before reading its fields in f2fs_listxattr().
Return -EFSCORRUPTED when the entry is outside the valid xattr storage
area instead of returning a successful partial result.

Fixes: 688078e7f36c ("f2fs: fix to avoid memory leakage in f2fs_listxattr")
Cc: stable@kernel.org
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Keshav Verma <iganschel@gmail.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/xattr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -581,8 +581,6 @@ ssize_t f2fs_listxattr(struct dentry *de
 		size_t prefix_len;
 		size_t size;
 
-		prefix = f2fs_xattr_prefix(entry->e_name_index, dentry);
-
 		if ((void *)(entry) + sizeof(__u32) > last_base_addr ||
 			(void *)XATTR_NEXT_ENTRY(entry) > last_base_addr) {
 			f2fs_err(F2FS_I_SB(inode), "list inode (%llu) has corrupted xattr",
@@ -590,9 +588,11 @@ ssize_t f2fs_listxattr(struct dentry *de
 			set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_FSCK);
 			f2fs_handle_error(F2FS_I_SB(inode),
 						ERROR_CORRUPTED_XATTR);
-			break;
+			error = -EFSCORRUPTED;
+			goto cleanup;
 		}
 
+		prefix = f2fs_xattr_prefix(entry->e_name_index, dentry);
 		if (!prefix)
 			continue;
 


