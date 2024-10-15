Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554341D95A2;
	Tue, 15 Oct 2024 12:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993757; cv=none; b=FM5+ipjhX4Cov61g8HK9VDTOAQz38eT3Kk1ruR104zAivsFKm8O3vm6OV6nG6WyJT1qdrn96tlSuGoORGmtjUSYAxC3yBXjZINcg1mSPrv05uXw0yA+owKBjLmwMUHGgqNjUWZaP9KY2htChIZGV1Lm5wTmqGc7pPJ0Ar4drApw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993757; c=relaxed/simple;
	bh=oYVP2TL2qPd1Zu13WlBg2/DhhbdkryPlwP6OvzR93vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjpV8ZN3LL5rqtbK7u41DN+fXn/aueC2ZchjJ6i4+cbI9PPUUtBT1KGZuY5J4bylO2QxKjde4plU/0gpZxKH70LQyMs6Tu5tIDUIWJHRvQ8liiXXC6CrABwKSwCFePg4dJbBsbfP2jRW+yPMNyotkTTIAZCc1ZkE9PA6RC56Edo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1uSyqMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1uSyqMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64B9C4CEC6;
	Tue, 15 Oct 2024 12:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993757;
	bh=oYVP2TL2qPd1Zu13WlBg2/DhhbdkryPlwP6OvzR93vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1uSyqMP5O0ywb+d10FuGEFkKBEeuJEKC3sUkGPz7qXqGN4w3D4BFyRosL7zJvboS
	 TGig88f4RYrZQYWrH8T1cjuWourTs0giUr/FbEFs/2yyYwG0Q7TPoeyeEP/IJa4uTe
	 cw23ZQA0qJvVwEFuUbKTvMFipqSZ/x5PPD0jUwsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 506/691] ext4: propagate errors from ext4_find_extent() in ext4_insert_range()
Date: Tue, 15 Oct 2024 13:27:34 +0200
Message-ID: <20241015112500.425426471@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5574,6 +5574,7 @@ static int ext4_insert_range(struct file
 	path = ext4_find_extent(inode, offset_lblk, NULL, 0);
 	if (IS_ERR(path)) {
 		up_write(&EXT4_I(inode)->i_data_sem);
+		ret = PTR_ERR(path);
 		goto out_stop;
 	}
 


