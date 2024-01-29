Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9576E15705B;
	Mon, 29 Jan 2024 17:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548182; cv=none; b=kIKsHtjSIuYZaVXU8bgyltZhOCLaeCHpXxF9wn/KyuN1ePWaesrgUKI0vHeV0qaghH04F3jKGNricjJrnO51bYXOtS+Rc9ghRWzte0HHbr1/MeShfmsvVVHH0qJrF2gd8Q8Cepl3wN31lVrGkwLfp7fSdieAns3C33xluLR627s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548182; c=relaxed/simple;
	bh=YAv5rFTwIiisnph3isEr4GChkT6dpcpFIAUKhIMY0Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYoOq3fcFCdpHGBb8Ysa3rz7qJZcR7uPnfRkagfUPEUu9VpOtu1bT9bUM6Af6W3ozymsqNWWrmpNVK4W0pgqdVi7KWSqfzMJIcfDOOD852ZI1zfTmMq209/aCGx1czdloKFGfr3lJ+MNm0wLvPds0bRotGEdGOk9V5qs1htpjlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09bd/q3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09bd/q3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601DFC433C7;
	Mon, 29 Jan 2024 17:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548182;
	bh=YAv5rFTwIiisnph3isEr4GChkT6dpcpFIAUKhIMY0Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09bd/q3Y1GthnFDJ5vAf9NI0iBunkZXL79VD9izQnEv2Lp45witlDEEVNEPbhjAmZ
	 Oqwy+79a1gbiUOS+aPhc1DIKsPAbJ9a9xEnh4jXef8Ptxn5Mq9wMZ2qLb/qvnkWWFj
	 3LBmmA4KULHqQ7Vfon4NfQiWbo8x+LCMgIkSSEsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.7 227/346] btrfs: defrag: reject unknown flags of btrfs_ioctl_defrag_range_args
Date: Mon, 29 Jan 2024 09:04:18 -0800
Message-ID: <20240129170023.074328908@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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
@@ -2608,6 +2608,10 @@ static int btrfs_ioctl_defrag(struct fil
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
@@ -614,6 +614,9 @@ struct btrfs_ioctl_clone_range_args {
  */
 #define BTRFS_DEFRAG_RANGE_COMPRESS 1
 #define BTRFS_DEFRAG_RANGE_START_IO 2
+#define BTRFS_DEFRAG_RANGE_FLAGS_SUPP	(BTRFS_DEFRAG_RANGE_COMPRESS |		\
+					 BTRFS_DEFRAG_RANGE_START_IO)
+
 struct btrfs_ioctl_defrag_range_args {
 	/* start of the defrag operation */
 	__u64 start;


