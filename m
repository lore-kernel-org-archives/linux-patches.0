Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC007BB02;
	Wed, 21 Feb 2024 13:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523933; cv=none; b=ZyZe3FMnNOknujf/OxKKzMV7TjnFUDINrLATTLT2fBJU5yUQ/OCLgpC6PEj+gVUGAh6TH1hnr8bA38Xiqi+iwlmEvj6EiB7ceD8BxcP0T3vRCup57GxyK9Jf4xa0WBDsZQYa3IDo/RnDTXriwkE0FEKHa1NsVDXFfO5OBkNwgn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523933; c=relaxed/simple;
	bh=1HIuLgnk/nqyS6Ujs2aQJYwAmH2uM65ZFzI/AduT14o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJFb6ciSqQVV6PetkfLr59I/FGXOHHGbmFYQSBfgO9KLk3HztXBh2K4hMAarG01+ou9K++oX1MK44ejlgSgi35W5fYX3+RXyaQ/s8X0OXDj2edVzmNMAi69MqZNvLSakCeWuQGzrQIexQNM8hMxHYMctk5Em+pqcyqkbTTaQ7ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htLJ9evo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htLJ9evo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6721C433F1;
	Wed, 21 Feb 2024 13:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523933;
	bh=1HIuLgnk/nqyS6Ujs2aQJYwAmH2uM65ZFzI/AduT14o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htLJ9evoyKMcNuIV7PLuci+WCzxXCLSB1GZop/p6AFgKHXccbiR4aPJHSosPMoNpP
	 n4UmC5d75Mv8MQC3hc4G6M2mwWZUJ/nWe21nHowaMIXQghSIyQ84QOAjSxehKqv18q
	 2/IG77wCUE0qmHzEuUoBtEAtkRdBji5kral91E/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 065/379] btrfs: defrag: reject unknown flags of btrfs_ioctl_defrag_range_args
Date: Wed, 21 Feb 2024 14:04:04 +0100
Message-ID: <20240221125956.836300056@linuxfoundation.org>
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
@@ -3190,6 +3190,10 @@ static int btrfs_ioctl_defrag(struct fil
 				kfree(range);
 				goto out;
 			}
+			if (range->flags & ~BTRFS_DEFRAG_RANGE_FLAGS_SUPP) {
+				ret = -EOPNOTSUPP;
+				goto out;
+			}
 			/* compression requires us to start the IO */
 			if ((range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)) {
 				range->flags |= BTRFS_DEFRAG_RANGE_START_IO;
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -576,6 +576,9 @@ struct btrfs_ioctl_clone_range_args {
  */
 #define BTRFS_DEFRAG_RANGE_COMPRESS 1
 #define BTRFS_DEFRAG_RANGE_START_IO 2
+#define BTRFS_DEFRAG_RANGE_FLAGS_SUPP	(BTRFS_DEFRAG_RANGE_COMPRESS |		\
+					 BTRFS_DEFRAG_RANGE_START_IO)
+
 struct btrfs_ioctl_defrag_range_args {
 	/* start of the defrag operation */
 	__u64 start;


