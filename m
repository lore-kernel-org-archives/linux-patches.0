Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E59466B5F;
	Wed, 20 May 2026 18:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303024; cv=none; b=Ci4sl9EgvsHusAlWIGVzbZCt7bZVPkEFTC4NX8pmvWZ1DzH2acLo0siphDCmk1L8X4OzBDjvGlLq37IjGSz3foR57yySqNBfpZs6klxzs4y6mHQGvpqo3T01o22Qv2dbdyNcEvFqcReRrlxkceWGqi30+foQ4AxZJEO7QEM8X6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303024; c=relaxed/simple;
	bh=kj1J8YUvgP+J2ucgsFEavRgvc6pq83tKqNfwGqrhCbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIs180zu/xhohlN5Hb76/1MFvpc7+GQ93iAv0hxePL3EX9KcvGySMuohvp/Vmf83iGkGTUrZYgosMc1jhGWV+FPmmhlLOz25AONHrCaAQrgb4hzg1P/Og3mA45EcomLhrc+NsKp+IK5RtGJeNxKdT6EWVtmCAk4Its2zLUKYgqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfRXP2zf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfRXP2zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDFE1F000E9;
	Wed, 20 May 2026 18:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303022;
	bh=dwp/Nc6QjdMeWoCHP01BkNusFTjel+GlnRKMH7KFBgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfRXP2zf16jsMLYSWnNj4Jy8K2eIDPGREq5HB/X46oEQ8Fr36Y3Ylv4h4jDqjecIm
	 fueC1p4EhWbsM6dABWG2rqy0Oc2ySbrmJmxNytB9e1EyBosMA0uk/0ilrdPWeOp9t5
	 p76g+Xr6sIxr331r8IZdouHxu8A1lblkiTaM4iEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 490/508] btrfs: use inode already stored in local variable at btrfs_rmdir()
Date: Wed, 20 May 2026 18:25:13 +0200
Message-ID: <20260520162109.212156798@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 9f82a4ed34d870b5719f9b95f7da4f74d3325a6f ]

There's no need to call d_inode(dentry) when calling btrfs_unlink_inode()
since we have already stored that in a local inode variable. So just use
the local variable to make the code less verbose.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 999757231c49 ("btrfs: fix missing last_unlink_trans update when removing a directory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4681,8 +4681,7 @@ static int btrfs_rmdir(struct inode *dir
 		goto out;
 
 	/* now the directory is empty */
-	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
-				 &fname.disk_name);
+	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(inode), &fname.disk_name);
 	if (!ret)
 		btrfs_i_size_write(BTRFS_I(inode), 0);
 out:


