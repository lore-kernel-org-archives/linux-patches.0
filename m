Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3193FA93C;
	Tue, 13 Feb 2024 17:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707846040; cv=none; b=bNiXsP5aye82wLHYgxXnm1WAijpcK+OJw882701KdLzODCLf8b+SnSPhHnPZtoQ0mDeBw4MvGRulJMWXDtLf8lLuIMHU8xgJOwx2/OzBvyTv/CYhmGx0oN0QWrauoeNaqSmiK1VEENaj1YEekT2VS16Y0irmPz808u4b1x/r+EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707846040; c=relaxed/simple;
	bh=AykGsEVLnIfiOL4OuFTBBm2/YXEbnRZ6Mcv3om3Jf/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYGK0emZGpyScnjwiOV9XNMRcL31JZZ6Gb4iDdM8NTUGUtXLq6wzDnjnZptEhMpCQXT2buBHtfebGhoBl5yq0Yfjb5BEEPfqJbB62nk8wNr+nQqUjatZI/A1tFktTTyhlJClsHc3LiL1cXGH/v5ejqDD2clFHrH0DTKDO0ChH/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bDqxnx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bDqxnx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F971C433C7;
	Tue, 13 Feb 2024 17:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707846040;
	bh=AykGsEVLnIfiOL4OuFTBBm2/YXEbnRZ6Mcv3om3Jf/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bDqxnx9XJWZMquQ9P1CgWWmIxa3aUVU0u5NZ/Mp3GoX9nUY1ckBjws2jApUZKfXJ
	 ddXfEixkTTeMCa36XTE1D1emB1NOaHm+iO+SL8gDv2QAkz/BvRkY0cLC6V23yo36Uo
	 v2Pl+QzbJNQiQmroPhhqpr9pmcug0KSksGm37bVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoyu Ou <benogy@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.7 119/124] bcachefs: unlock parent dir if entry is not found in subvolume deletion
Date: Tue, 13 Feb 2024 18:22:21 +0100
Message-ID: <20240213171857.204704923@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoyu Ou <benogy@gmail.com>

commit 6bb3f7f4c3f4da8e09de188f2f63e8f741bba3bd upstream.

Parent dir is locked by user_path_locked_at() before validating the
required dentry. It should be unlocked if we can not perform the
deletion.

This fixes the problem:

$ bcachefs subvolume delete not-exist-entry
BCH_IOCTL_SUBVOLUME_DESTROY ioctl error: No such file or directory
$ bcachefs subvolume delete not-exist-entry

the second will stuck because the parent dir is locked in the previous
deletion.

Signed-off-by: Guoyu Ou <benogy@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/fs-ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -463,6 +463,7 @@ static long bch2_ioctl_subvolume_destroy
 	if (IS_ERR(victim))
 		return PTR_ERR(victim);
 
+	dir = d_inode(path.dentry);
 	if (victim->d_sb->s_fs_info != c) {
 		ret = -EXDEV;
 		goto err;
@@ -471,14 +472,13 @@ static long bch2_ioctl_subvolume_destroy
 		ret = -ENOENT;
 		goto err;
 	}
-	dir = d_inode(path.dentry);
 	ret = __bch2_unlink(dir, victim, true);
 	if (!ret) {
 		fsnotify_rmdir(dir, victim);
 		d_delete(victim);
 	}
-	inode_unlock(dir);
 err:
+	inode_unlock(dir);
 	dput(victim);
 	path_put(&path);
 	return ret;


