Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5C1BE7F;
	Thu, 18 Jan 2024 11:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575710; cv=none; b=TvnbUly5BmrsimYspHLnGrPd8tQy0ODLjeR9/Us5uqUoHkA0E0z+KyfKRlmV4AmvdMcMzQbzwUJuydLYpUZIN54JffBc6kFWZtBDCilDaoFdoWoZ6wYQYFhWIM23wvECAvoI3vDy+n6vz70+5CT+dcDmdAaK2g6JujkUFu3tDO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575710; c=relaxed/simple;
	bh=r1jyXvpinvGOnwRlIaNNsH3/c4CiUUfVyrWMtXoN/Eo=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=WFVoh1msqcGh46475VckFOxFMIe9uUGhP60fhZ6FZVKuQcZ8DGf3LQrrYeedR6ZZSPk43G2wuaPVFEiYBVN3ily4q4C0FYmX8ugrglyX97tVWVmq6yvwLcqewacv9oWEaKHefMz4qC2SkQEmH+oCW1wf0DREwOaGws3VEdi0CEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ik5fAJ98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ik5fAJ98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A70DC433F1;
	Thu, 18 Jan 2024 11:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575709;
	bh=r1jyXvpinvGOnwRlIaNNsH3/c4CiUUfVyrWMtXoN/Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ik5fAJ989BvriMHq/xG6kkmRM5qg9lTLSSYyyfizJHtH/KrBCTbYBFAoESUhgPfEq
	 0Tt0OgPCg9dVDU7VLu9tH3YCWcXrfHq+pKzzzVXQGoJNRaSC+SlcjKvyxDwp37+M4F
	 cPd74MiIFPurZRdTgj9D+woplEtQJLbzp0ghcqRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suwan Kim <suwan.kim027@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/100] virtio_blk: fix snprintf truncation compiler warning
Date: Thu, 18 Jan 2024 11:49:26 +0100
Message-ID: <20240118104314.290347083@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Hajnoczi <stefanha@redhat.com>

[ Upstream commit b8e0792449928943c15d1af9f63816911d139267 ]

Commit 4e0400525691 ("virtio-blk: support polling I/O") triggers the
following gcc 13 W=1 warnings:

drivers/block/virtio_blk.c: In function ‘init_vq’:
drivers/block/virtio_blk.c:1077:68: warning: ‘%d’ directive output may be truncated writing between 1 and 11 bytes into a region of size 7 [-Wformat-truncation=]
 1077 |                 snprintf(vblk->vqs[i].name, VQ_NAME_LEN, "req_poll.%d", i);
      |                                                                    ^~
drivers/block/virtio_blk.c:1077:58: note: directive argument in the range [-2147483648, 65534]
 1077 |                 snprintf(vblk->vqs[i].name, VQ_NAME_LEN, "req_poll.%d", i);
      |                                                          ^~~~~~~~~~~~~
drivers/block/virtio_blk.c:1077:17: note: ‘snprintf’ output between 11 and 21 bytes into a destination of size 16
 1077 |                 snprintf(vblk->vqs[i].name, VQ_NAME_LEN, "req_poll.%d", i);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is a false positive because the lower bound -2147483648 is
incorrect. The true range of i is [0, num_vqs - 1] where 0 < num_vqs <
65536.

The code mixes int, unsigned short, and unsigned int types in addition
to using "%d" for an unsigned value. Use unsigned short and "%u"
consistently to solve the compiler warning.

Cc: Suwan Kim <suwan.kim027@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312041509.DIyvEt9h-lkp@intel.com/
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20231204140743.1487843-1-stefanha@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index efa5535a8e1d..3124837aa406 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -609,12 +609,12 @@ static void virtblk_config_changed(struct virtio_device *vdev)
 static int init_vq(struct virtio_blk *vblk)
 {
 	int err;
-	int i;
+	unsigned short i;
 	vq_callback_t **callbacks;
 	const char **names;
 	struct virtqueue **vqs;
 	unsigned short num_vqs;
-	unsigned int num_poll_vqs;
+	unsigned short num_poll_vqs;
 	struct virtio_device *vdev = vblk->vdev;
 	struct irq_affinity desc = { 0, };
 
@@ -658,13 +658,13 @@ static int init_vq(struct virtio_blk *vblk)
 
 	for (i = 0; i < num_vqs - num_poll_vqs; i++) {
 		callbacks[i] = virtblk_done;
-		snprintf(vblk->vqs[i].name, VQ_NAME_LEN, "req.%d", i);
+		snprintf(vblk->vqs[i].name, VQ_NAME_LEN, "req.%u", i);
 		names[i] = vblk->vqs[i].name;
 	}
 
 	for (; i < num_vqs; i++) {
 		callbacks[i] = NULL;
-		snprintf(vblk->vqs[i].name, VQ_NAME_LEN, "req_poll.%d", i);
+		snprintf(vblk->vqs[i].name, VQ_NAME_LEN, "req_poll.%u", i);
 		names[i] = vblk->vqs[i].name;
 	}
 
-- 
2.43.0



