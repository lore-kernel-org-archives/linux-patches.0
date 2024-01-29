Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24988161B65;
	Mon, 29 Jan 2024 17:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548357; cv=none; b=b++M6qMwOaCyrdObq9+LM7YVWv0aNsv6btPZArHal8iHppueG6bbOG0OSRuoqND3VrWLdOZVzbn2jw0xe5P4DvHDue+Dl+6Yca3VSt7Nkem1KJHHmoagY+Du7Mo4t9c9hmAJrXQpEigKSnnqEWVG6uSiJ/K/GRzT4D9FkwQp//U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548357; c=relaxed/simple;
	bh=GEWEQAZGwtdUEpe3umJfVPJNz+SZa+7l0zDc8a1/v+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpN7901Tg+bnNVHEqdrvntY/B99PHn7No+MApfZbR8EzvOpeSuwFEYd0ZzjxQM+HoiQLdUaSRUoyfyGDsO5+1xcLR9SiG+icXSKhwmi59Kd5AQWO+V/1qCbH9NYbdbHx0msCr08lrtrW8lrSqxIxPY3AIBbFOurRNiFey8mfhos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/qortU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/qortU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E376DC433F1;
	Mon, 29 Jan 2024 17:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548357;
	bh=GEWEQAZGwtdUEpe3umJfVPJNz+SZa+7l0zDc8a1/v+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/qortU5ciwN9yRiOhywGdI7lX32Z8FQ+Eomix9Nchot020LUC0WlfbzBuH9mty6X
	 A2lk568GJq1KfuLaWkANmgEs07MAeABy5UHQABQlcrYDLKdzOaDP+8K7S3sKIz8Mgx
	 I6a27jiQEI6o5P478qWtQScQMNeZTEKwRWODVzP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 119/185] btrfs: defrag: reject unknown flags of btrfs_ioctl_defrag_range_args
Date: Mon, 29 Jan 2024 09:05:19 -0800
Message-ID: <20240129170002.417682118@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3500,6 +3500,10 @@ static int btrfs_ioctl_defrag(struct fil
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
@@ -585,6 +585,9 @@ struct btrfs_ioctl_clone_range_args {
  */
 #define BTRFS_DEFRAG_RANGE_COMPRESS 1
 #define BTRFS_DEFRAG_RANGE_START_IO 2
+#define BTRFS_DEFRAG_RANGE_FLAGS_SUPP	(BTRFS_DEFRAG_RANGE_COMPRESS |		\
+					 BTRFS_DEFRAG_RANGE_START_IO)
+
 struct btrfs_ioctl_defrag_range_args {
 	/* start of the defrag operation */
 	__u64 start;


