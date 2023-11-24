Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF072C1BA;
	Fri, 24 Nov 2023 18:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jar+OSK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A27C433C8;
	Fri, 24 Nov 2023 18:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848935;
	bh=3E9FmljrmNiSWLrVAHG/IYTHgJ3CCVKFJzPFibh01y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jar+OSK+zL/A2ik8fL3O6uOP1C8BKMDTunI3KmRsUMf+PTdbfPEXPNqfdSUd6Whkh
	 wiNsmjsPZ8v6ADYUuR8HpFH0I7tQuA05jvZ9E5EwxaqA6Bj3PPIIhoNDu/7AYwgt92
	 Y0HOuYOgStKy0EEpqtTBYPaK+9UHYDaBnQv1S+ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e27f3dbdab04e43b9f73@syzkaller.appspotmail.com,
	Rajeshwar R Shinde <coolrrsh@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 23/57] media: gspca: cpia1: shift-out-of-bounds in set_flicker
Date: Fri, 24 Nov 2023 17:50:47 +0000
Message-ID: <20231124171931.124237637@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171930.281665051@linuxfoundation.org>
References: <20231124171930.281665051@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajeshwar R Shinde <coolrrsh@gmail.com>

[ Upstream commit 099be1822d1f095433f4b08af9cc9d6308ec1953 ]

Syzkaller reported the following issue:
UBSAN: shift-out-of-bounds in drivers/media/usb/gspca/cpia1.c:1031:27
shift exponent 245 is too large for 32-bit type 'int'

When the value of the variable "sd->params.exposure.gain" exceeds the
number of bits in an integer, a shift-out-of-bounds error is reported. It
is triggered because the variable "currentexp" cannot be left-shifted by
more than the number of bits in an integer. In order to avoid invalid
range during left-shift, the conditional expression is added.

Reported-by: syzbot+e27f3dbdab04e43b9f73@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/20230818164522.12806-1-coolrrsh@gmail.com
Link: https://syzkaller.appspot.com/bug?extid=e27f3dbdab04e43b9f73
Signed-off-by: Rajeshwar R Shinde <coolrrsh@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/gspca/cpia1.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/gspca/cpia1.c b/drivers/media/usb/gspca/cpia1.c
index e91d00762e94b..bf34479a87cc5 100644
--- a/drivers/media/usb/gspca/cpia1.c
+++ b/drivers/media/usb/gspca/cpia1.c
@@ -28,6 +28,7 @@
 
 #include <linux/input.h>
 #include <linux/sched/signal.h>
+#include <linux/bitops.h>
 
 #include "gspca.h"
 
@@ -1032,6 +1033,8 @@ static int set_flicker(struct gspca_dev *gspca_dev, int on, int apply)
 			sd->params.exposure.expMode = 2;
 			sd->exposure_status = EXPOSURE_NORMAL;
 		}
+		if (sd->params.exposure.gain >= BITS_PER_TYPE(currentexp))
+			return -EINVAL;
 		currentexp = currentexp << sd->params.exposure.gain;
 		sd->params.exposure.gain = 0;
 		/* round down current exposure to nearest value */
-- 
2.42.0



