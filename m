Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5307B15B30B;
	Mon, 29 Jan 2024 17:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548581; cv=none; b=r0uh5kBnClc8zIT4/TofBmirqN0FUpTxfaeJZQJK57HijPqx50YaqtGZz+DydG+bRnNPk/eF1McnoKRijhG52KpXaQxx7HfSFgwqVYF8xMwy7u42JqsbEy58I6WyKwxMamn515FhEDJkrLXKm6uHo3oqNRxQ43T/u04Z4RtllYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548581; c=relaxed/simple;
	bh=VbdtgJ+Q0X/5gHhLBOF3sMoOYkcxaDv3uSJAexAS9wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnAK7GWrETslsUZPwKiwyPDinuDoPQ3YaZ0QHXFbSOXJwf1SFd94kxeDNry5GI6qRwBn+D1xEKmjsP+Uz4pC3hlc92QNM3So04iBV6YILcAb/ZyqncZVLZqREuZ5tGWUpbmp2w16ELX8C50Faxjw2WTnEzndEQurK/qQsdMcUcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWZ8nN2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWZ8nN2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6ECC433C7;
	Mon, 29 Jan 2024 17:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548581;
	bh=VbdtgJ+Q0X/5gHhLBOF3sMoOYkcxaDv3uSJAexAS9wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWZ8nN2+/4FKrpdPLj/AoY2ieq5l5yOZsxiTccPA0t1Y79a5xLQQYcvQty9cAJXFL
	 OxNIyex7BAh4wv09/Ut7ploK//+pokiFYZWopo4iFvv5CwIse+XRlWyRwDCaOSIvb1
	 6VzaS6FT/8/fG3NZctWqbKjd4ORaKFFmvl9dyrY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 236/331] btrfs: defrag: reject unknown flags of btrfs_ioctl_defrag_range_args
Date: Mon, 29 Jan 2024 09:05:00 -0800
Message-ID: <20240129170021.784905021@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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
@@ -612,6 +612,9 @@ struct btrfs_ioctl_clone_range_args {
  */
 #define BTRFS_DEFRAG_RANGE_COMPRESS 1
 #define BTRFS_DEFRAG_RANGE_START_IO 2
+#define BTRFS_DEFRAG_RANGE_FLAGS_SUPP	(BTRFS_DEFRAG_RANGE_COMPRESS |		\
+					 BTRFS_DEFRAG_RANGE_START_IO)
+
 struct btrfs_ioctl_defrag_range_args {
 	/* start of the defrag operation */
 	__u64 start;


