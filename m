Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97499443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425E4C433C8;
	Sun, 13 Aug 2023 21:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961714;
	bh=LTLTGtzwLFCfMwDPkwvOE59epzWiH/L6gcAyHUc0PlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngM3dDXXpzvvNjJUVP1L5qNNUHZgUF0BFoV6bb3G5dVUkWKYKLPFKqYs1SFvusM9T
	 dYjiH2UbRw8lOLLcTOCHIphuyheT2VdS7IV+McE1lLsAxs3tsqo8vC1GZ3XVgNv0mw
	 rBCwohJc38a7pAol2koIt+3aWTZFt4xKRQ1yz+1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Wang <wangzhu9@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 25/26] scsi: core: Fix possible memory leak if device_add() fails
Date: Sun, 13 Aug 2023 23:19:18 +0200
Message-ID: <20230813211703.922069272@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211702.980427106@linuxfoundation.org>
References: <20230813211702.980427106@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhu Wang <wangzhu9@huawei.com>

commit 04b5b5cb0136ce970333a9c6cec7e46adba1ea3a upstream.

If device_add() returns error, the name allocated by dev_set_name() needs
be freed. As the comment of device_add() says, put_device() should be used
to decrease the reference count in the error path. So fix this by calling
put_device(), then the name can be freed in kobject_cleanp().

Fixes: ee959b00c335 ("SCSI: convert struct class_device to struct device")
Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
Link: https://lore.kernel.org/r/20230803020230.226903-1-wangzhu9@huawei.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/raid_class.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/raid_class.c
+++ b/drivers/scsi/raid_class.c
@@ -248,6 +248,7 @@ int raid_component_add(struct raid_templ
 	return 0;
 
 err_out:
+	put_device(&rc->dev);
 	list_del(&rc->node);
 	rd->component_count--;
 	put_device(component_dev);


