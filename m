Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EA11DFE03;
	Tue,  8 Oct 2024 13:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393712; cv=none; b=cEsdysYMgtoXA69kln7yyQ/aJDs29e2g9aHXboDCui6TBPppA7E1VM0M7Fj2EUVba7X4h0rFEFW8B+oM1VMIOdqtOjcVC8eD4I2ZyydJ/7ACmahA7bVoC3DzPBfvDBUl5dq1EEgLTbcWF/G4CwQZP3i8iiyjr2fwQUyKgGgSZGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393712; c=relaxed/simple;
	bh=bmH37kTLOABJ/nXhVYWYiF8Q7SrrA7hlddJHSX/wurM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4d0zmLwQem+K8XtNc+ZNLSwO55zXmEksNSzRrQwc9RFGACouIn9htHNmZ6VUk9fJikEJ4jv1dsFoKT280Tp9fJtE5tlsil19nrwwmkreZbfJxW//c47B/k7dswr4cjE47LVzTccE2NHIN5Qt2uwdg2Ck1KT4HP8+6FBkiF9Umg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxK7vmXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxK7vmXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C455C4CECE;
	Tue,  8 Oct 2024 13:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393711;
	bh=bmH37kTLOABJ/nXhVYWYiF8Q7SrrA7hlddJHSX/wurM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxK7vmXzlpWa80jPYDl4hF1qS1pubey5H1OFmuh4kTW7fKrgVzNNcwTyejUPRYcNA
	 4NNBO4kX3HObIMgDzvsm3C8PHFVRsgWXjRphpfuXvY9vqyfSBNTLBqjDZSxeM5DUhW
	 f4YR3/MwHFUValJAJM58Mpxd87DwPlUEkfjIFhJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 234/386] ext4: propagate errors from ext4_find_extent() in ext4_insert_range()
Date: Tue,  8 Oct 2024 14:07:59 +0200
Message-ID: <20241008115638.609681110@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5549,6 +5549,7 @@ static int ext4_insert_range(struct file
 	path = ext4_find_extent(inode, offset_lblk, NULL, 0);
 	if (IS_ERR(path)) {
 		up_write(&EXT4_I(inode)->i_data_sem);
+		ret = PTR_ERR(path);
 		goto out_stop;
 	}
 


