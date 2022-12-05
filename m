Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9486D15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15340C433C1;
	Mon,  5 Dec 2022 19:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268172;
	bh=LyMXvAbYuYMYC3Oo/cQWcOcEi2Vdvp+mqF8hNX9AJEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6a+O+/0HRjmopCkTHMrqDE8k9+bxElrRAoq5yxUfi9swDdYiyp8QKtyb3CPUvgvB
	 QxNjdLORuYWsJr/cgroBcrZX7ZCtfEp+fmJ2CJF6Yn7dctH2v9HFd/0VhexD2n54/n
	 Cvivc0gnvjNWo2xs7uCOeI1EFQrJfglcxAAXe/qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 099/105] nvme: restrict management ioctls to admin
Date: Mon,  5 Dec 2022 20:10:11 +0100
Message-Id: <20221205190806.456959866@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

commit 23e085b2dead13b51fe86d27069895b740f749c0 upstream.

The passthrough commands already have this restriction, but the other
operations do not. Require the same capabilities for all users as all of
these operations, which include resets and rescans, can be disruptive.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/nvme/host/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2675,11 +2675,17 @@ static long nvme_dev_ioctl(struct file *
 	case NVME_IOCTL_IO_CMD:
 		return nvme_dev_user_cmd(ctrl, argp);
 	case NVME_IOCTL_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		dev_warn(ctrl->device, "resetting controller\n");
 		return nvme_reset_ctrl_sync(ctrl);
 	case NVME_IOCTL_SUBSYS_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		return nvme_reset_subsystem(ctrl);
 	case NVME_IOCTL_RESCAN:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		nvme_queue_scan(ctrl);
 		return 0;
 	default:


