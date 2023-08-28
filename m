Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966E211C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1793CC433C7;
	Mon, 28 Aug 2023 10:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218546;
	bh=gM62mdnJkOJxFNGu1ow9lbDPIzWweJ6X0EFgY3Tp17Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILhVzSPylevKFTf/nvLlZEZjXQJZiWKqXG4etVLkb51T5dC1F70ZW1RSlnPxGd3xq
	 +lGay9P+69FaVCavB197WGqecgCyFXHCRXFXhVGN7Z7v+yntXKEfu8t0yaCfn2sUW3
	 /AFNULhBrCGWgKpG9l+IryWH1Q+G6Jb7QFz/jcaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Wang <wangzhu9@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 127/129] scsi: core: raid_class: Remove raid_component_add()
Date: Mon, 28 Aug 2023 12:13:41 +0200
Message-ID: <20230828101157.839797565@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Wang <wangzhu9@huawei.com>

commit 60c5fd2e8f3c42a5abc565ba9876ead1da5ad2b7 upstream.

The raid_component_add() function was added to the kernel tree via patch
"[SCSI] embryonic RAID class" (2005). Remove this function since it never
has had any callers in the Linux kernel. And also raid_component_release()
is only used in raid_component_add(), so it is also removed.

Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
Link: https://lore.kernel.org/r/20230822015254.184270-1-wangzhu9@huawei.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Fixes: 04b5b5cb0136 ("scsi: core: Fix possible memory leak if device_add() fails")
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/raid_class.c  |   48 ---------------------------------------------
 include/linux/raid_class.h |    4 ---
 2 files changed, 52 deletions(-)

--- a/drivers/scsi/raid_class.c
+++ b/drivers/scsi/raid_class.c
@@ -210,54 +210,6 @@ raid_attr_ro_state(level);
 raid_attr_ro_fn(resync);
 raid_attr_ro_state_fn(state);
 
-static void raid_component_release(struct device *dev)
-{
-	struct raid_component *rc =
-		container_of(dev, struct raid_component, dev);
-	dev_printk(KERN_ERR, rc->dev.parent, "COMPONENT RELEASE\n");
-	put_device(rc->dev.parent);
-	kfree(rc);
-}
-
-int raid_component_add(struct raid_template *r,struct device *raid_dev,
-		       struct device *component_dev)
-{
-	struct device *cdev =
-		attribute_container_find_class_device(&r->raid_attrs.ac,
-						      raid_dev);
-	struct raid_component *rc;
-	struct raid_data *rd = dev_get_drvdata(cdev);
-	int err;
-
-	rc = kzalloc(sizeof(*rc), GFP_KERNEL);
-	if (!rc)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&rc->node);
-	device_initialize(&rc->dev);
-	rc->dev.release = raid_component_release;
-	rc->dev.parent = get_device(component_dev);
-	rc->num = rd->component_count++;
-
-	dev_set_name(&rc->dev, "component-%d", rc->num);
-	list_add_tail(&rc->node, &rd->component_list);
-	rc->dev.class = &raid_class.class;
-	err = device_add(&rc->dev);
-	if (err)
-		goto err_out;
-
-	return 0;
-
-err_out:
-	put_device(&rc->dev);
-	list_del(&rc->node);
-	rd->component_count--;
-	put_device(component_dev);
-	kfree(rc);
-	return err;
-}
-EXPORT_SYMBOL(raid_component_add);
-
 struct raid_template *
 raid_class_attach(struct raid_function_template *ft)
 {
--- a/include/linux/raid_class.h
+++ b/include/linux/raid_class.h
@@ -78,7 +78,3 @@ DEFINE_RAID_ATTRIBUTE(enum raid_state, s
 	
 struct raid_template *raid_class_attach(struct raid_function_template *);
 void raid_class_release(struct raid_template *);
-
-int __must_check raid_component_add(struct raid_template *, struct device *,
-				    struct device *);
-


