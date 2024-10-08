Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99BB1CEE8E;
	Tue,  8 Oct 2024 12:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390697; cv=none; b=lW+qeItJD5TUrB+vigr4DjZnLG7FjLBgrlHhvkaiWcsXe/fTjiyCKJHc+D+UtMaRQC5KPGTWa0nPAmzNdnZHeINdyM02L9Jz3Dc+JDO1AxRmufy0GwYEVtDGhjvHFM+AnaP8SYiEt3vYaEPGnGNEMwTp+gpobmbPWycNUmWXvaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390697; c=relaxed/simple;
	bh=UYypahXJ0DCQi0AJ34Yt+QqXOTEK5j4LHpUEEgsU3ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLI196PBSwK0GWO+EpONNvCLl1yetOiE0i9rGHDz0ykJbIldEFAAu51cst7rMxzHIDUaZ9AZ65o4gkMOhFLIjvaO6SOI6YyjB78QHDpr6OVwdaOt+mkor0GP9D1R4lSG6JlLbTYF8OjkiXyqQ4h0R9eWjEF3R8ZH2svxZp+2Grs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubR8efBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubR8efBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F278C4CEC7;
	Tue,  8 Oct 2024 12:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390697;
	bh=UYypahXJ0DCQi0AJ34Yt+QqXOTEK5j4LHpUEEgsU3ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubR8efBDMPkkBOQHh392Cdk4stPH3OyobalYuhbF97SYFJhoyr3/v9BsVR852rw4I
	 GTR0oMPM0Yrirl0RGC6QLyLQF4LoRGsM6qbGvc6zYgLd0AHSXqf9SmtJ9Z/I3n5/fJ
	 F3FydR9b5QEnM5a2OQOjfYLMMPClHgr1/IwWAUoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.10 325/482] ext4: propagate errors from ext4_find_extent() in ext4_insert_range()
Date: Tue,  8 Oct 2024 14:06:28 +0200
Message-ID: <20241008115701.217180821@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

commit 369c944ed1d7c3fb7b35f24e4735761153afe7b3 upstream.

Even though ext4_find_extent() returns an error, ext4_insert_range() still
returns 0. This may confuse the user as to why fallocate returns success,
but the contents of the file are not as expected. So propagate the error
returned by ext4_find_extent() to avoid inconsistencies.

Fixes: 331573febb6a ("ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-11-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5553,6 +5553,7 @@ static int ext4_insert_range(struct file
 	path = ext4_find_extent(inode, offset_lblk, NULL, 0);
 	if (IS_ERR(path)) {
 		up_write(&EXT4_I(inode)->i_data_sem);
+		ret = PTR_ERR(path);
 		goto out_stop;
 	}
 


