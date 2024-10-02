Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB5217B421;
	Wed,  2 Oct 2024 13:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877103; cv=none; b=b8pjLkeb2XmaiBbgn1diRnkhhQaPv9FhMh37iNg6vV88cbomertiHBtylZ5371BwpJDQwC/yO0CP1RgNf45Youq76lxC9oYEErl3bhQMrjRhj/ZLmih3emSF0RVAZXXXNOBDrUbnMrkFbMOohMgGZWUHhFdwkPkfOQfOGS6OgkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877103; c=relaxed/simple;
	bh=PUR+CE+inA4NfmHM5b/Rbkyj7c28+drytj/ugnttZCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5uVzHk/Fc4G7zzmMXagmOx+1UtSiOVd1cssAqAd8Z/e+Dckk+DopJtGvpGxuBqi+94BZkhKq86hmjBtm+ecLZok5/8x3lS23inFoWH4QclxJBpxeym3rl1Ud4k0zervQws/4YAVyMVIjI7YwhfnxRsr06Wf3B78YuxSJsmu6to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0+7YhBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0+7YhBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00436C4CEC2;
	Wed,  2 Oct 2024 13:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877103;
	bh=PUR+CE+inA4NfmHM5b/Rbkyj7c28+drytj/ugnttZCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0+7YhBJoTxTZMrsoA7F9daU1TPNy0XI1JQ4Am98JYp3c2Xn8bXx4GDq2vFZkMjTk
	 x1O4OdoioLcPz8oaUKzDnr8yam1XebwkvpXX/cFQUeEDYCO2QrSxJKKg3QdHBHPfcz
	 eMfd1rBNyxz1qcNESlH3srSgi5mfN61Ugr8/UCRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.11 634/695] f2fs: check discard support for conventional zones
Date: Wed,  2 Oct 2024 15:00:32 +0200
Message-ID: <20241002125847.823234814@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit 43aec4d01bd2ce961817a777b3846f8318f398e4 upstream.

As the helper function f2fs_bdev_support_discard() shows, f2fs checks if
the target block devices support discard by calling
bdev_max_discard_sectors() and bdev_is_zoned(). This check works well
for most cases, but it does not work for conventional zones on zoned
block devices. F2fs assumes that zoned block devices support discard,
and calls __submit_discard_cmd(). When __submit_discard_cmd() is called
for sequential write required zones, it works fine since
__submit_discard_cmd() issues zone reset commands instead of discard
commands. However, when __submit_discard_cmd() is called for
conventional zones, __blkdev_issue_discard() is called even when the
devices do not support discard.

The inappropriate __blkdev_issue_discard() call was not a problem before
the commit 30f1e7241422 ("block: move discard checks into the ioctl
handler") because __blkdev_issue_discard() checked if the target devices
support discard or not. If not, it returned EOPNOTSUPP. After the
commit, __blkdev_issue_discard() no longer checks it. It always returns
zero and sets NULL to the given bio pointer. This NULL pointer triggers
f2fs_bug_on() in __submit_discard_cmd(). The BUG is recreated with the
commands below at the umount step, where /dev/nullb0 is a zoned null_blk
with 5GB total size, 128MB zone size and 10 conventional zones.

$ mkfs.f2fs -f -m /dev/nullb0
$ mount /dev/nullb0 /mnt
$ for ((i=0;i<5;i++)); do dd if=/dev/zero of=/mnt/test bs=65536 count=1600 conv=fsync; done
$ umount /mnt

To fix the BUG, avoid the inappropriate __blkdev_issue_discard() call.
When discard is requested for conventional zones, check if the device
supports discard or not. If not, return EOPNOTSUPP.

Fixes: 30f1e7241422 ("block: move discard checks into the ioctl handler")
Cc: stable@vger.kernel.org
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/segment.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1290,6 +1290,13 @@ static int __submit_discard_cmd(struct f
 						wait_list, issued);
 			return 0;
 		}
+
+		/*
+		 * Issue discard for conventional zones only if the device
+		 * supports discard.
+		 */
+		if (!bdev_max_discard_sectors(bdev))
+			return -EOPNOTSUPP;
 	}
 #endif
 


