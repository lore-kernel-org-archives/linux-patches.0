Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2111495C2;
	Thu, 30 Nov 2023 16:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JcPwZz3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BB6C433C7;
	Thu, 30 Nov 2023 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361461;
	bh=mnLdTYIh0yYlKg0IQFsdooYIsDNyvU3GkHnPOVUeKEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JcPwZz3/yxe8t5hOP7MggyzOswSbH+Uc1nFzZx/pk34AGVzJy4pJjrNfqhOzHiNvd
	 ye51u/1i4GPHR9aXNTv//A9IdFvVYW4inX+Lp4rlck9aFMSdqLE4NlvUbjSWAZFbxN
	 uWmbC7fOrmws+9gpJnJSQdfwTI0Ik2zlcwYCvz7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/112] block: update the stable_writes flag in bdev_add
Date: Thu, 30 Nov 2023 16:21:11 +0000
Message-ID: <20231130162141.086403021@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1898efcdbed32bb1c67269c985a50bab0dbc9493 ]

Propagate the per-queue stable_write flags into each bdev inode in bdev_add.
This makes sure devices that require stable writes have it set for I/O
on the block device node as well.

Note that this doesn't cover the case of a flag changing on a live device
yet.  We should handle that as well, but I plan to cover it as part of a
more general rework of how changing runtime paramters on block devices
works.

Fixes: 1cb039f3dc16 ("bdi: replace BDI_CAP_STABLE_WRITES with a queue and a sb flag")
Reported-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231025141020.192413-3-hch@lst.de
Tested-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/bdev.c b/block/bdev.c
index f3b13aa1b7d42..04dba25b0019e 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -425,6 +425,8 @@ void bdev_set_nr_sectors(struct block_device *bdev, sector_t sectors)
 
 void bdev_add(struct block_device *bdev, dev_t dev)
 {
+	if (bdev_stable_writes(bdev))
+		mapping_set_stable_writes(bdev->bd_inode->i_mapping);
 	bdev->bd_dev = dev;
 	bdev->bd_inode->i_rdev = dev;
 	bdev->bd_inode->i_ino = dev;
-- 
2.42.0



