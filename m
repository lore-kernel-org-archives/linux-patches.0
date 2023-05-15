Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913F8FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E797DC433A4;
	Mon, 15 May 2023 16:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169064;
	bh=Xg/MrrGvGViuDrTDd7I2LrFSyCR9VlaUO9b0Bw+g1NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2b5f/IfKP3Rg7Vsn3+q51bjv7XnikpUDJuKeZy/Wzo9A0c3Dll8Z0fOf8U0BZVAS6
	 odDlgeAomLPWiJHuny+yjwo837GgkBYLT63icrpaNC8RAzJ4GpQkJKLILeDU6RDml0
	 ieVN8qGoOGsl74tOKiU6Q8LnU8u9HLKVX76jwmqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 131/191] btrfs: scrub: reject unsupported scrub flags
Date: Mon, 15 May 2023 18:26:08 +0200
Message-Id: <20230515161712.119424816@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qu Wenruo <wqu@suse.com>

commit 604e6681e114d05a2e384c4d1e8ef81918037ef5 upstream.

Since the introduction of scrub interface, the only flag that we support
is BTRFS_SCRUB_READONLY.  Thus there is no sanity checks, if there are
some undefined flags passed in, we just ignore them.

This is problematic if we want to introduce new scrub flags, as we have
no way to determine if such flags are supported.

Address the problem by introducing a check for the flags, and if
unsupported flags are set, return -EOPNOTSUPP to inform the user space.

This check should be backported for all supported kernels before any new
scrub flags are introduced.

CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c           |    5 +++++
 include/uapi/linux/btrfs.h |    1 +
 2 files changed, 6 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4722,6 +4722,11 @@ static long btrfs_ioctl_scrub(struct fil
 	if (IS_ERR(sa))
 		return PTR_ERR(sa);
 
+	if (sa->flags & ~BTRFS_SCRUB_SUPPORTED_FLAGS) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	if (!(sa->flags & BTRFS_SCRUB_READONLY)) {
 		ret = mnt_want_write_file(file);
 		if (ret)
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -162,6 +162,7 @@ struct btrfs_scrub_progress {
 };
 
 #define BTRFS_SCRUB_READONLY	1
+#define BTRFS_SCRUB_SUPPORTED_FLAGS	(BTRFS_SCRUB_READONLY)
 struct btrfs_ioctl_scrub_args {
 	__u64 devid;				/* in */
 	__u64 start;				/* in */


