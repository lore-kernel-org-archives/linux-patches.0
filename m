Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A4F1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B492EC433C7;
	Tue,  1 Aug 2023 09:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883299;
	bh=f8g8BzD3wSQbWC97+iyPFgUoqTGX9tkOF6SPvGLXdlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrt+BWFTXbmIYHluUCvafO/AiGV9rH6bLJLSqXMNdyfSuCumhiECr1/dDrP29O8kJ
	 5xLKYJipMlHBAphXW2n8I8pOlFqEeEuLnwyalnT889LUGz1VXaP7whyMZh/dTrPRIm
	 cjrEfArHGN0NBylQW5eHhkbwnh+AtkX57fpu2ik8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.4 185/239] btrfs: zoned: do not enable async discard
Date: Tue,  1 Aug 2023 11:20:49 +0200
Message-ID: <20230801091932.350512990@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 95ca6599a589ee84c69f02d0e1d928c8d1367fb1 upstream.

The zoned mode need to reset a zone before using it. We rely on btrfs's
original discard functionality (discarding unused block group range) to do
the resetting.

While the commit 63a7cb130718 ("btrfs: auto enable discard=async when
possible") made the discard done in an async manner, a zoned reset do not
need to be async, as it is fast enough.

Even worth, delaying zone rests prevents using those zones again. So, let's
disable async discard on the zoned mode.

Fixes: 63a7cb130718 ("btrfs: auto enable discard=async when possible")
CC: stable@vger.kernel.org # 6.3+
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ update message text ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    7 ++++++-
 fs/btrfs/zoned.c   |    3 +++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3692,11 +3692,16 @@ int __cold open_ctree(struct super_block
 	 * For devices supporting discard turn on discard=async automatically,
 	 * unless it's already set or disabled. This could be turned off by
 	 * nodiscard for the same mount.
+	 *
+	 * The zoned mode piggy backs on the discard functionality for
+	 * resetting a zone. There is no reason to delay the zone reset as it is
+	 * fast enough. So, do not enable async discard for zoned mode.
 	 */
 	if (!(btrfs_test_opt(fs_info, DISCARD_SYNC) ||
 	      btrfs_test_opt(fs_info, DISCARD_ASYNC) ||
 	      btrfs_test_opt(fs_info, NODISCARD)) &&
-	    fs_info->fs_devices->discardable) {
+	    fs_info->fs_devices->discardable &&
+	    !btrfs_is_zoned(fs_info)) {
 		btrfs_set_and_info(fs_info, DISCARD_ASYNC,
 				   "auto enabling async discard");
 	}
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -804,6 +804,9 @@ int btrfs_check_mountopts_zoned(struct b
 		return -EINVAL;
 	}
 
+	btrfs_clear_and_info(info, DISCARD_ASYNC,
+			"zoned: async discard ignored and disabled for zoned mode");
+
 	return 0;
 }
 


