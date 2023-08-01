Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637171EA8F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5BFC433CA;
	Tue,  1 Aug 2023 09:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883452;
	bh=HsnQURv66rM9bSecLSeDJ24b70s03gW/1MsNquYAx5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMLNN56U9G2mttY0DnDe10nRvjHAeaFs6E7TBaBblpPk1kAjWCE/KnBb3mNZPloBe
	 I1r00Ks6hmOjdxur3inTgilq4FWkrGl+0ge9BmsqYD6M4IYHFQUDqclR09dKQrTKjn
	 3zwI+aYaHqGA3wCg8UPmScQyB3lgF6dO7nxBdXQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Haberland <sth@linux.ibm.com>,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.4 221/239] s390/dasd: fix hanging device after quiesce/resume
Date: Tue,  1 Aug 2023 11:21:25 +0200
Message-ID: <20230801091933.898556124@linuxfoundation.org>
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

From: Stefan Haberland <sth@linux.ibm.com>

commit 05f1d8ed03f547054efbc4d29bb7991c958ede95 upstream.

Quiesce and resume are functions that tell the DASD driver to stop/resume
issuing I/Os to a specific DASD.

On resume dasd_schedule_block_bh() is called to kick handling of IO
requests again. This does unfortunately not cover internal requests which
are used for path verification for example.

This could lead to a hanging device when a path event or anything else
that triggers internal requests occurs on a quiesced device.

Fix by also calling dasd_schedule_device_bh() which triggers handling of
internal requests on resume.

Fixes: 8e09f21574ea ("[S390] dasd: add hyper PAV support to DASD device driver, part 1")

Cc: stable@vger.kernel.org
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Link: https://lore.kernel.org/r/20230721193647.3889634-2-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -131,6 +131,7 @@ static int dasd_ioctl_resume(struct dasd
 	spin_unlock_irqrestore(get_ccwdev_lock(base->cdev), flags);
 
 	dasd_schedule_block_bh(block);
+	dasd_schedule_device_bh(base);
 	return 0;
 }
 


