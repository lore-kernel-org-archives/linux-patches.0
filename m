Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BD61DDA36;
	Tue,  8 Oct 2024 12:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390560; cv=none; b=QdHrT4Ae8THHJS4HlQXoSRwow/o7ZKcNjW9K0Xk8nXcDUmg5trLp3NmRH5N/aC7QhZxfDwptvpiQlv8GAqO1ET7awJv2FkDwwGOb2whGFop5UYQYJtcdhnejZX7D4/W8VZlGGLeaTKH2k2qxhIFfn8A18fNjEF1KYqwByKdq/VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390560; c=relaxed/simple;
	bh=wYGeDDVI20hhLsLaZETg9dmGJAZq+ksmQ0dFkoL4DMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCTGcVtJALLlK2Jd60FE64Wal/N5sTJpOd3DaDQ7CceklCvbkprI54zGRTBLBHFXt0BPx+dpvu/C1gDr2dhzIZ67He51OSOxyGsfR0LpM8uRDXzwYzgCD8jJOJznKwXD7wNloodVu/5N10P1iLAt+4yJQ5EjmwBcLYaMHRGonzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hUzOgB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hUzOgB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E08C4CEC7;
	Tue,  8 Oct 2024 12:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390560;
	bh=wYGeDDVI20hhLsLaZETg9dmGJAZq+ksmQ0dFkoL4DMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hUzOgB+/FJig/4njYqZCCBiXQESOm1WbbJPPvapRIqn1L73+720PY7dV8o4iZtOK
	 yzGG0HuMMV7XGICAXOGlN/wgktXquMMPZarod2fTRogXzfRhqHfsYM69ZJqWSR7yLR
	 XP7DXbITj/TKfQqyozRx7Exrc51LEZEkrA2v1Gu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yao.ly" <yao.ly@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.10 323/482] ext4: correct encrypted dentry name hash when not casefolded
Date: Tue,  8 Oct 2024 14:06:26 +0200
Message-ID: <20241008115701.138512250@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: yao.ly <yao.ly@linux.alibaba.com>

commit 70dd7b573afeba9b8f8a33f2ae1e4a9a2ec8c1ec upstream.

EXT4_DIRENT_HASH and EXT4_DIRENT_MINOR_HASH will access struct
ext4_dir_entry_hash followed ext4_dir_entry. But there is no ext4_dir_entry_hash
followed when inode is encrypted and not casefolded

Signed-off-by: yao.ly <yao.ly@linux.alibaba.com>
Link: https://patch.msgid.link/1719816219-128287-1-git-send-email-yao.ly@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/dir.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -279,12 +279,20 @@ static int ext4_readdir(struct file *fil
 					struct fscrypt_str de_name =
 							FSTR_INIT(de->name,
 								de->name_len);
+					u32 hash;
+					u32 minor_hash;
+
+					if (IS_CASEFOLDED(inode)) {
+						hash = EXT4_DIRENT_HASH(de);
+						minor_hash = EXT4_DIRENT_MINOR_HASH(de);
+					} else {
+						hash = 0;
+						minor_hash = 0;
+					}
 
 					/* Directory is encrypted */
 					err = fscrypt_fname_disk_to_usr(inode,
-						EXT4_DIRENT_HASH(de),
-						EXT4_DIRENT_MINOR_HASH(de),
-						&de_name, &fstr);
+						hash, minor_hash, &de_name, &fstr);
 					de_name = fstr;
 					fstr.len = save_len;
 					if (err)


