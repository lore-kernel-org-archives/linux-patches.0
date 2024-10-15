Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D9A205E26;
	Tue, 15 Oct 2024 13:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998172; cv=none; b=fa+WYtXXfgbhPnKCxPri5Y9PPBRcFN3FZunj8AGL3OOvLC+G+CQTOq6+tA0tROd5xGFTMxvdvFPgMmjBkLBoNixok0EwM5koIiAzNq5diajUjuhWxT6SYB6L/MakGvitF0i0oV5Z1N7KwNvm768jDMLNu/+s9Q+z5WgbNZsuQ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998172; c=relaxed/simple;
	bh=U8Yi44pYv/A9mRoPkDj+KtdYsXKEBHCCV24L82w7zoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/HXiqNl5KekN8TnrpS2fQQ6l/vQVYq3l8Gg2rubkpcnWHha6f43RBI/4VlR8xnpK+P1MdRFoxSAvYAGbs/DisL1xwQisZh9kzIj3cEgdhbqD+Wucr30/UDw89sIpHfftAwtWgI+U/2biZv2mhQ5a7bCLqpUXEdBecBtWeZAy9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yf01NaLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yf01NaLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1C6C4CEC6;
	Tue, 15 Oct 2024 13:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998171;
	bh=U8Yi44pYv/A9mRoPkDj+KtdYsXKEBHCCV24L82w7zoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yf01NaLswuKJjD9teKbMQ3aMS3ZbW0tWQ0XquwyzwjrkpcZIjJ6gc8eM7YEO1xRRK
	 FMLjh/fA++fxZn2hD6Dtan4yXCPqAj14nBZJA0CHj3wfhnf2uYXsgthpav3laNcKwW
	 D+q8VeRdZxOS2cHOgZ5VCNRmvsklt9+3Zuq70xe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 372/518] ext4: propagate errors from ext4_find_extent() in ext4_insert_range()
Date: Tue, 15 Oct 2024 14:44:36 +0200
Message-ID: <20241015123931.330364996@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5566,6 +5566,7 @@ static int ext4_insert_range(struct file
 	path = ext4_find_extent(inode, offset_lblk, NULL, 0);
 	if (IS_ERR(path)) {
 		up_write(&EXT4_I(inode)->i_data_sem);
+		ret = PTR_ERR(path);
 		goto out_stop;
 	}
 


