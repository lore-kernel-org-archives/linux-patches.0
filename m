Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA76BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAC9C433D2;
	Tue,  7 Mar 2023 18:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213482;
	bh=uku7f55HZfT5K/ElFyp6Oo42annPS+DyVI9Dya6RfWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1FdJiodnUC+farfN5JZdTHzyJvh0Z/d+1BqeD7kLR6HwwGY6MjxG5sRwYTl5/h9e
	 u8BgEQJPx/a5HcexD8r71QxHAHus0qnaTQL+0NIzDNptGecmKntBuKGUQrlahPTfwH
	 E+F0Dnd1hJY3oW573XinRthkpU0xJI8Gxbvn/8hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 521/885] media: atomisp: Only set default_run_mode on first open of a stream/asd
Date: Tue,  7 Mar 2023 17:57:35 +0100
Message-Id: <20230307170025.101806953@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 60ec70a71a9f9975a5d2dd4a7d97c20da0e41976 ]

Calling v4l2_ctrl_s_ctrl(asd->run_mode, pipe->default_run_mode) when
the stream is already active (through another /dev/video# node) causes
the stream to stop.

Move the call to set the default run-mode so that it is only done
on the first open of one of the 4 /dev/video# nodes of one of
the 2 streams (atomisp-sub-devices / asd-s).

Fixes: 2c45e343c581 ("media: atomisp: set per-device's default mode")
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_fops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp_fops.c
index 84a84e0cdeef7..5fa2e2596a818 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_fops.c
@@ -741,13 +741,13 @@ static int atomisp_open(struct file *file)
 		goto done;
 
 	atomisp_subdev_init_struct(asd);
+	/* Ensure that a mode is set */
+	v4l2_ctrl_s_ctrl(asd->run_mode, pipe->default_run_mode);
 
 done:
 	pipe->users++;
 	mutex_unlock(&isp->mutex);
 
-	/* Ensure that a mode is set */
-	v4l2_ctrl_s_ctrl(asd->run_mode, pipe->default_run_mode);
 
 	return 0;
 
-- 
2.39.2



