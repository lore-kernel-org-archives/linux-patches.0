Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B21380616;
	Wed, 21 Feb 2024 14:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524671; cv=none; b=tXmqemsEvxwra2hfQtwLvn1FxqWuICw7ppVba3WeTU6lVUz7DQZWRFsb///dwyTWD6ISSRJ7b1KoTsAecysuQk9dzZYbjQdc//V8bq/o92GFrUHr2OzdkPs5ZL3oeJo2MZIq9OjPx23RPalR4eL0rQdGAM11J552qRfKl4pBEEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524671; c=relaxed/simple;
	bh=qsGcm/MjQ4sHs5Wkk6DT5zBObVpA2l7f9tif2sdzb+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtU7RPdzjIM0IcdKjsXJBATRS2eoqriZOMIWYqeu3rDyQpb1ZyGoOrz430MtNBBYu+ouh/th9KEBsgrIoUx53mpwjjinRCTaDbd8Q3d+xqO+oH2N8nH+mQvIrhM3hd+O6QZKXFWw9F6ymtRymM9f5eVhJaVoEGO1t6jLEcI9ey4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Axs1R1Ql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Axs1R1Ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BCBC433F1;
	Wed, 21 Feb 2024 14:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524671;
	bh=qsGcm/MjQ4sHs5Wkk6DT5zBObVpA2l7f9tif2sdzb+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Axs1R1QlGyWT4ybITXRGxalRVTliN9Px2GoxLG6iMq+ZzZGfO27Oq57Fy53abVyab
	 do1Dm1uJY2I112uRXa9jlvnqOp6KH5VxTFTkioPpEuLJNwd+a4/nxVxuRmz3zghLqu
	 o+/IJbjMHzmL3i2isz1qEYIW9DWWp5n8LiYteqP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 286/379] btrfs: forbid creating subvol qgroups
Date: Wed, 21 Feb 2024 14:07:45 +0100
Message-ID: <20240221130003.369630068@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

commit 0c309d66dacddf8ce939b891d9ead4a8e21ad6f0 upstream.

Creating a qgroup 0/subvolid leads to various races and it isn't
helpful, because you can't specify a subvol id when creating a subvol,
so you can't be sure it will be the right one. Any requirements on the
automatic subvol can be gratified by using a higher level qgroup and the
inheritance parameters of subvol creation.

Fixes: cecbb533b5fc ("btrfs: record simple quota deltas in delayed refs")
CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4325,6 +4325,11 @@ static long btrfs_ioctl_qgroup_create(st
 		goto out;
 	}
 
+	if (sa->create && is_fstree(sa->qgroupid)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);


