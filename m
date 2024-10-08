Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B221DE8A0;
	Tue,  8 Oct 2024 13:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392435; cv=none; b=IkYhHgdAHI0/mrQMFDt4a2r5PPHqkWVK9yMmhiys9+hyyRVZQzESDS1SHMnpx4QISGUoUcL/yRCZaS8e2VLgwn485jMwwFKxalq1snwVQ2mQpUQd1AyWsGYrltAzRbSSZ6QbTdhEePGYK4JbqIBgF8wIBerZipMMseQqgqGvoJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392435; c=relaxed/simple;
	bh=Gad+J1+tyX4JCq7pZ1t7csQaquNpQPhSl4+I4uYFVKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kc+XUrWmcD720AwufcVNhmpk+rMfLrdqDNzLnwj91BFj1wsuEIVL2BiVVWSYK9HMs9QLlOYxA90864gjrVbIdTAavzZvhLNE9ma+8zlE5vITDtr3yhwmCq8a027DcsxI7Vr9qAFklLgI6PpAWjMriMWfAFCi2ovC0qSaEKE2R6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5Bxir3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5Bxir3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC36C4CEC7;
	Tue,  8 Oct 2024 13:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392434;
	bh=Gad+J1+tyX4JCq7pZ1t7csQaquNpQPhSl4+I4uYFVKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5Bxir3AoLunwFpaG5t7AHQnZQXpB/YXD++k0pWk9SwQzkT83A3taBu47EUZ915Vo
	 bHf74sRb9gWl8D11mVSs0K4Jb0b48EgqhirddwHJG10foIFasfXPEMtXGBu36RcoLv
	 +rK/+T6Dhzjksjxn4bjp9gHL4AyLTYEOAOkxGqjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.11 383/558] ext4: propagate errors from ext4_find_extent() in ext4_insert_range()
Date: Tue,  8 Oct 2024 14:06:53 +0200
Message-ID: <20241008115717.359899025@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 


