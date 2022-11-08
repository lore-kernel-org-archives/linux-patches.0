Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A1215CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B28AC433D6;
	Tue,  8 Nov 2022 13:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915694;
	bh=7XVdZUFEEdnFZv6/yyN8FubbZ0jx7jumF3zo8J9oKYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u41NbRWuLlu55gkZbghUQC6jyofhrzo097C4EScCaagG8ynJKEe4O8snPlwf1b/JZ
	 Wc6pxNcPwm86129f0VxOeoU1bMBEYeSO/LMAA3DvFX+hJKyTf8PVOfqJVZ2qrKnOVd
	 pATNXJZQUNLGLsK8lEoCdYx7dvzCjPt1WJZrQx28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Mike Christie <michael.christie@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/118] scsi: core: Restrict legal sdev_state transitions via sysfs
Date: Tue,  8 Nov 2022 14:39:03 +0100
Message-Id: <20221108133343.575191921@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uday Shankar <ushankar@purestorage.com>

[ Upstream commit 2331ce6126be8864b39490e705286b66e2344aac ]

Userspace can currently write to sysfs to transition sdev_state to RUNNING
or OFFLINE from any source state. This causes issues because proper
transitioning out of some states involves steps besides just changing
sdev_state, so allowing userspace to change sdev_state regardless of the
source state can result in inconsistencies; e.g. with ISCSI we can end up
with sdev_state == SDEV_RUNNING while the device queue is quiesced. Any
task attempting I/O on the device will then hang, and in more recent
kernels, iscsid will hang as well.

More detail about this bug is provided in my first attempt:

https://groups.google.com/g/open-iscsi/c/PNKca4HgPDs/m/CXaDkntOAQAJ

Link: https://lore.kernel.org/r/20220924000241.2967323-1-ushankar@purestorage.com
Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Suggested-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_sysfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 42db9c52208e..6cc4d0792e3d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -815,6 +815,14 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	}
 
 	mutex_lock(&sdev->state_mutex);
+	switch (sdev->sdev_state) {
+	case SDEV_RUNNING:
+	case SDEV_OFFLINE:
+		break;
+	default:
+		mutex_unlock(&sdev->state_mutex);
+		return -EINVAL;
+	}
 	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
 		ret = 0;
 	} else {
-- 
2.35.1



