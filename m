Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E678481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F8FC433D2;
	Fri, 10 Mar 2023 14:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457235;
	bh=mpqJt5zJ7CPvSkDyBW2VufNE4cqUl48yhJW3ZkM8w90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UsChGZcNzaQma3c1cFIqHkDGQf8mAHUMSMkKC76/1nNsJ1tEf49N9VPLpQ1ujYF6n
	 oZlg7QNW+Z936cNq2MZxszjnMRgrKOXfx1F6vRLEua7meItjmo6KZDD5FnGfaLhhnS
	 5qy4AapjPJBfehSlc5CkiEgDluVw5z1bihDutqHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/200] ubi: Fix possible null-ptr-deref in ubi_free_volume()
Date: Fri, 10 Mar 2023 14:37:22 +0100
Message-Id: <20230310133718.132008476@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit c15859bfd326c10230f09cb48a17f8a35f190342 ]

It willl cause null-ptr-deref in the following case:

uif_init()
  ubi_add_volume()
    cdev_add() -> if it fails, call kill_volumes()
    device_register()

kill_volumes() -> if ubi_add_volume() fails call this function
  ubi_free_volume()
    cdev_del()
    device_unregister() -> trying to delete a not added device,
			   it causes null-ptr-deref

So in ubi_free_volume(), it delete devices whether they are added
or not, it will causes null-ptr-deref.

Handle the error case whlie calling ubi_add_volume() to fix this
problem. If add volume fails, set the corresponding vol to null,
so it can not be accessed in kill_volumes() and release the
resource in ubi_add_volume() error path.

Fixes: 801c135ce73d ("UBI: Unsorted Block Images")
Suggested-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/build.c |  1 +
 drivers/mtd/ubi/vmt.c   | 12 ++++++------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 2178eb4115b36..7f65af1697519 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -468,6 +468,7 @@ static int uif_init(struct ubi_device *ubi)
 			err = ubi_add_volume(ubi, ubi->volumes[i]);
 			if (err) {
 				ubi_err(ubi, "cannot add volume %d", i);
+				ubi->volumes[i] = NULL;
 				goto out_volumes;
 			}
 		}
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 9fbc64b997cef..2c867d16f89f7 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -582,6 +582,7 @@ int ubi_add_volume(struct ubi_device *ubi, struct ubi_volume *vol)
 	if (err) {
 		ubi_err(ubi, "cannot add character device for volume %d, error %d",
 			vol_id, err);
+		vol_release(&vol->dev);
 		return err;
 	}
 
@@ -592,15 +593,14 @@ int ubi_add_volume(struct ubi_device *ubi, struct ubi_volume *vol)
 	vol->dev.groups = volume_dev_groups;
 	dev_set_name(&vol->dev, "%s_%d", ubi->ubi_name, vol->vol_id);
 	err = device_register(&vol->dev);
-	if (err)
-		goto out_cdev;
+	if (err) {
+		cdev_del(&vol->cdev);
+		put_device(&vol->dev);
+		return err;
+	}
 
 	self_check_volumes(ubi);
 	return err;
-
-out_cdev:
-	cdev_del(&vol->cdev);
-	return err;
 }
 
 /**
-- 
2.39.2



