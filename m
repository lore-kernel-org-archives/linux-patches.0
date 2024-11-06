Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3651DB37C;
	Wed,  6 Nov 2024 13:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898465; cv=none; b=VHpQm0+c3jaFq7xyt9KwBStNrAXoN3AJfpEgoShBUIfEcklYP+UV8Qwz75t2MBUyeJeJmejoFTiAcoX4VyGLnEfQM8k89uH3FCiAQu6Cay9HVbz+R/O8LkQoK4yJJuBVUZuyficYj4UOSvCMAfAirlCT4r73crZkPAo3eMJb74U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898465; c=relaxed/simple;
	bh=51M5keCoHaFJFBHA8BjzvUpnex5OI4YbCLrU529rMC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddWhp3iWBI6tzl3KHI5vJG/TU74RnMXaHcb7rnIhmi1TJGKmK7DRio4UOnBlmAmNERAQGZIUGWIElghWo7lyNjl1qUu+Z9gzxPINZUPCyxydPNJ9rSBPjmXUpNlDwAcrZVYVN+n5j5Ex2ZZJnS/D1lgIQG5imJ5edD9BnwJ2fmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjOj62GP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjOj62GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CDDC4CECD;
	Wed,  6 Nov 2024 13:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898465;
	bh=51M5keCoHaFJFBHA8BjzvUpnex5OI4YbCLrU529rMC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjOj62GPSw8BGeF1kbK3os8Za8e8wORkqVR/1YhJXLnJmm9cY9jv0htZYRox3kP2c
	 RGVzUhbjH8FktdVLTq9nE52MpRUD+7Aa96LRNuHbn+r476gckyPTnkjENHQhV70ONm
	 U2kcm9pfZximjvRFSViw69NRowdzvZdJZEAvkiBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 247/462] ext4: propagate errors from ext4_find_extent() in ext4_insert_range()
Date: Wed,  6 Nov 2024 13:02:20 +0100
Message-ID: <20241106120337.626815859@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5741,6 +5741,7 @@ int ext4_insert_range(struct inode *inod
 	path = ext4_find_extent(inode, offset_lblk, NULL, 0);
 	if (IS_ERR(path)) {
 		up_write(&EXT4_I(inode)->i_data_sem);
+		ret = PTR_ERR(path);
 		goto out_stop;
 	}
 


