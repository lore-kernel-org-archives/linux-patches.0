Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7CC76905;
	Wed, 21 Feb 2024 13:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522106; cv=none; b=erZ00h5lcBE9ADf/EsAfOYZtZX/iI9m4FiohWH1Ot0ZdN7dzvLq277GNn+/f0y1S9/aN1xDvVUstpfrNMm/gA83FyxW/BwBn/v4GbRWjsWgzZs/oGxz87v9UINbjmG94Z9bsn91urSjbD75omYyAbn/Dbf4hpmMcN7IVIFcf4dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522106; c=relaxed/simple;
	bh=deiQw16pclw6uXBqeqZUb4pqNUZ6ENcCvMY6BaJw/ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bgd7QYEwE0xMzCnhtVHmMZn4nz0s+2LYI+3xzsH17EajWGow05tNMWZ61Xa5EuJYQ6HJeHecATgMoeJ65CuS/4LGu2lfa4pPpIt25Zu5rt5RV7YcGrWpY/Cm/WndCppTA8Leh91GHZaH72mTWAmgSBXAA01C4KOp2FzjVUA8y4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIhGPhzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIhGPhzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1E9C433F1;
	Wed, 21 Feb 2024 13:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522105;
	bh=deiQw16pclw6uXBqeqZUb4pqNUZ6ENcCvMY6BaJw/ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OIhGPhzfQFlfLatWdvIFNOnP1h0o74eRyckVWyr5aqp07GzjefCbUR6rM6rnH8DZS
	 H+icuSobSd0UpU3r18KvbulORwZmFVEnYk9mWApmH6eIaLXqbWgja32jNrYb9IRTBp
	 bBgoLECszjiW5sKxSKpPu12U7qiODFpMRfqpCqQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 080/476] btrfs: defrag: reject unknown flags of btrfs_ioctl_defrag_range_args
Date: Wed, 21 Feb 2024 14:02:11 +0100
Message-ID: <20240221130010.941720086@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit 173431b274a9a54fc10b273b46e67f46bcf62d2e upstream.

Add extra sanity check for btrfs_ioctl_defrag_range_args::flags.

This is not really to enhance fuzzing tests, but as a preparation for
future expansion on btrfs_ioctl_defrag_range_args.

In the future we're going to add new members, allowing more fine tuning
for btrfs defrag.  Without the -ENONOTSUPP error, there would be no way
to detect if the kernel supports those new defrag features.

CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c           |    4 ++++
 include/uapi/linux/btrfs.h |    3 +++
 2 files changed, 7 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3183,6 +3183,10 @@ static int btrfs_ioctl_defrag(struct fil
 				ret = -EFAULT;
 				goto out;
 			}
+			if (range.flags & ~BTRFS_DEFRAG_RANGE_FLAGS_SUPP) {
+				ret = -EOPNOTSUPP;
+				goto out;
+			}
 			/* compression requires us to start the IO */
 			if ((range.flags & BTRFS_DEFRAG_RANGE_COMPRESS)) {
 				range.flags |= BTRFS_DEFRAG_RANGE_START_IO;
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -578,6 +578,9 @@ struct btrfs_ioctl_clone_range_args {
  */
 #define BTRFS_DEFRAG_RANGE_COMPRESS 1
 #define BTRFS_DEFRAG_RANGE_START_IO 2
+#define BTRFS_DEFRAG_RANGE_FLAGS_SUPP	(BTRFS_DEFRAG_RANGE_COMPRESS |		\
+					 BTRFS_DEFRAG_RANGE_START_IO)
+
 struct btrfs_ioctl_defrag_range_args {
 	/* start of the defrag operation */
 	__u64 start;


