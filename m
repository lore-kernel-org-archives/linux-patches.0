Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718381170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D6AC433C7;
	Mon, 11 Sep 2023 14:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442294;
	bh=frl/p3tOpteIvwr/V9ZrKQ+8c1icHAdKwnFP5ijGTuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2E/shmUWOzFUuUd/Bgt6Il+XFIoX7WEKxYAh5cSHWqdO0r+pVyP+46YwxlXZUcZd
	 QdWNr5+X2voZR5TmzPZw7C6sNuRAxeBqdtokSfvQ579uKWjCkMSQkFTq/UxGx59Z2e
	 PSE2HrG7chd4GNvG83bmu4wVR+Qg/8vRBsRG9f38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: [PATCH 6.5 715/739] s390/dcssblk: fix kernel crash with list_add corruption
Date: Mon, 11 Sep 2023 15:48:34 +0200
Message-ID: <20230911134711.056986504@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit c8f40a0bccefd613748d080147469a4652d6e74c upstream.

Commit fb08a1908cb1 ("dax: simplify the dax_device <-> gendisk
association") introduced new logic for gendisk association, requiring
drivers to explicitly call dax_add_host() and dax_remove_host().

For dcssblk driver, some dax_remove_host() calls were missing, e.g. in
device remove path. The commit also broke error handling for out_dax case
in device add path, resulting in an extra put_device() w/o the previous
get_device() in that case.

This lead to stale xarray entries after device add / remove cycles. In the
case when a previously used struct gendisk pointer (xarray index) would be
used again, because blk_alloc_disk() happened to return such a pointer, the
xa_insert() in dax_add_host() would fail and go to out_dax, doing the extra
put_device() in the error path. In combination with an already flawed error
handling in dcssblk (device_register() cleanup), which needs to be
addressed in a separate patch, this resulted in a missing device_del() /
klist_del(), and eventually in the kernel crash with list_add corruption on
a subsequent device_add() / klist_add().

Fix this by adding the missing dax_remove_host() calls, and also move the
put_device() in the error path to restore the previous logic.

Fixes: fb08a1908cb1 ("dax: simplify the dax_device <-> gendisk association")
Cc: <stable@vger.kernel.org> # 5.17+
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dcssblk.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -412,6 +412,7 @@ removeseg:
 	}
 	list_del(&dev_info->lh);
 
+	dax_remove_host(dev_info->gd);
 	kill_dax(dev_info->dax_dev);
 	put_dax(dev_info->dax_dev);
 	del_gendisk(dev_info->gd);
@@ -707,9 +708,9 @@ dcssblk_add_store(struct device *dev, st
 	goto out;
 
 out_dax_host:
+	put_device(&dev_info->dev);
 	dax_remove_host(dev_info->gd);
 out_dax:
-	put_device(&dev_info->dev);
 	kill_dax(dev_info->dax_dev);
 	put_dax(dev_info->dax_dev);
 put_dev:
@@ -789,6 +790,7 @@ dcssblk_remove_store(struct device *dev,
 	}
 
 	list_del(&dev_info->lh);
+	dax_remove_host(dev_info->gd);
 	kill_dax(dev_info->dax_dev);
 	put_dax(dev_info->dax_dev);
 	del_gendisk(dev_info->gd);


