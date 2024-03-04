Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9354F7BAE6;
	Mon,  4 Mar 2024 21:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587873; cv=none; b=Au5evyqt+Vm9rpMZkttU94alxrpanG1N7lmSEE2cxkuHSo4jIPssjd1MZAu25mCxNJ7SRQb1cnTt4QAmt1dbymlGfR63xWQmiZbK6TT3DDoO65Kpo+BjuVd9oyqrSGGnwtc+p+q6u3OWtGTHwheCj1NLJzHgCHQCJRsr0PKp2S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587873; c=relaxed/simple;
	bh=2v1nPBZH4rD/xNQ4PA2C7dIct5MMBkNNAgkL5JJmkos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3ghQ4r6iJYmtCeatOXgl8Zxu82CB3UTbPII/1q3LsjJIZOYVuWjvld6PzPDpjLU9LXICgn6mX33thrxUAna7xWrzXGirVD7FujdyWcvfhJsuTARvFsmZdg9jXwz7rFQ3ONk/mi0NWuvcjBES5j2m4+GKFMnAC3TMN755NmGu3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLBOCCST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLBOCCST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B25C433F1;
	Mon,  4 Mar 2024 21:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587873;
	bh=2v1nPBZH4rD/xNQ4PA2C7dIct5MMBkNNAgkL5JJmkos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLBOCCSTPC+szrP6hQ3qyUREY6Z1PpL/EnoobPTbydWK3K0ZZAf8WywEsdob6Inb8
	 7kqBRUjEBKffiG/Q1c1DiMiyMTkawd31JoHW8c8lA35e4gQq/adIMWWDHr2Zv4DQbN
	 YRB5J3AYP8dleuzKqPY056Wh+d98U7sz55Rc/I8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	syzbot+33f23b49ac24f986c9e8@syzkaller.appspotmail.com
Subject: [PATCH 6.7 088/162] btrfs: dev-replace: properly validate device names
Date: Mon,  4 Mar 2024 21:22:33 +0000
Message-ID: <20240304211554.650144641@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

commit 9845664b9ee47ce7ee7ea93caf47d39a9d4552c4 upstream.

There's a syzbot report that device name buffers passed to device
replace are not properly checked for string termination which could lead
to a read out of bounds in getname_kernel().

Add a helper that validates both source and target device name buffers.
For devid as the source initialize the buffer to empty string in case
something tries to read it later.

This was originally analyzed and fixed in a different way by Edward Adam
Davis (see links).

Link: https://lore.kernel.org/linux-btrfs/000000000000d1a1d1060cc9c5e7@google.com/
Link: https://lore.kernel.org/linux-btrfs/tencent_44CA0665C9836EF9EEC80CB9E7E206DF5206@qq.com/
CC: stable@vger.kernel.org # 4.19+
CC: Edward Adam Davis <eadavis@qq.com>
Reported-and-tested-by: syzbot+33f23b49ac24f986c9e8@syzkaller.appspotmail.com
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/dev-replace.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -727,6 +727,23 @@ leave:
 	return ret;
 }
 
+static int btrfs_check_replace_dev_names(struct btrfs_ioctl_dev_replace_args *args)
+{
+	if (args->start.srcdevid == 0) {
+		if (memchr(args->start.srcdev_name, 0,
+			   sizeof(args->start.srcdev_name)) == NULL)
+			return -ENAMETOOLONG;
+	} else {
+		args->start.srcdev_name[0] = 0;
+	}
+
+	if (memchr(args->start.tgtdev_name, 0,
+		   sizeof(args->start.tgtdev_name)) == NULL)
+	    return -ENAMETOOLONG;
+
+	return 0;
+}
+
 int btrfs_dev_replace_by_ioctl(struct btrfs_fs_info *fs_info,
 			    struct btrfs_ioctl_dev_replace_args *args)
 {
@@ -739,10 +756,9 @@ int btrfs_dev_replace_by_ioctl(struct bt
 	default:
 		return -EINVAL;
 	}
-
-	if ((args->start.srcdevid == 0 && args->start.srcdev_name[0] == '\0') ||
-	    args->start.tgtdev_name[0] == '\0')
-		return -EINVAL;
+	ret = btrfs_check_replace_dev_names(args);
+	if (ret < 0)
+		return ret;
 
 	ret = btrfs_dev_replace_start(fs_info, args->start.tgtdev_name,
 					args->start.srcdevid,


