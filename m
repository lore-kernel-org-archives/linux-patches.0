Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7986E17727;
	Mon, 27 May 2024 19:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838560; cv=none; b=f0fmj8srwM+83gtqBhrxmmzZ76sC08WHBYIQgbbckMlbZwLUHb2QD4BYUw2B5XPxI6nZa+YK5tIXTDFrJOfaNVqOYJhCtUOCLrn7zSAdlqz7PXgV7AL44fEv0VjkdMWnOdXf4zTuRi+Fi2JqN5nNeWHp/kwg2CkB1/oH2ZEgFy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838560; c=relaxed/simple;
	bh=Kldm/8m25KEy11mhGXUeXo7uCFuV9Lb1bqkpDt6BHbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAOT8b8KdCNtxa8ooualRSsjzLrROMzde6p0yEDunyD1J3zmLc8NN1eXP2ukZbbX30GWakh80csVnN8gHkjNT0kcUvuC5eioxU9JXHxh2HdW97Hvs4gv715ygfD/PdE8WmaYydnhxrKIQUVkqNW7koNwo5vfvSNAL+Ugl9HtcHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reU2V3If; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reU2V3If"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C151C2BBFC;
	Mon, 27 May 2024 19:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838560;
	bh=Kldm/8m25KEy11mhGXUeXo7uCFuV9Lb1bqkpDt6BHbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=reU2V3IfnlSs/gv8wBpKNsWj8B3I5+uI0E2JOqgwGC7l1WTapbhI64cMI5iE1GX9i
	 WXF/J1bp18GzLy7zcMt1HDBvBipQyrYCx7fobVyJPdSmR5laQKWzdiMxZCYCg0Ojp4
	 zj0VVDRLp40JvkxsFbOt8fJsiaN7ZEjD/as0zd8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 400/493] media: atomisp: ssh_css: Fix a null-pointer dereference in load_video_binaries
Date: Mon, 27 May 2024 20:56:42 +0200
Message-ID: <20240527185643.362529757@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 3b621e9e9e148c0928ab109ac3d4b81487469acb ]

The allocation failure of mycs->yuv_scaler_binary in load_video_binaries()
is followed with a dereference of mycs->yuv_scaler_binary after the
following call chain:

sh_css_pipe_load_binaries()
  |-> load_video_binaries(mycs->yuv_scaler_binary == NULL)
  |
  |-> sh_css_pipe_unload_binaries()
        |-> unload_video_binaries()

In unload_video_binaries(), it calls to ia_css_binary_unload with argument
&pipe->pipe_settings.video.yuv_scaler_binary[i], which refers to the
same memory slot as mycs->yuv_scaler_binary. Thus, a null-pointer
dereference is triggered.

Link: https://lore.kernel.org/r/20240118151303.3828292-1-alexious@zju.edu.cn

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/sh_css.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/pci/sh_css.c b/drivers/staging/media/atomisp/pci/sh_css.c
index f35c90809414c..638f08b3f21be 100644
--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -4719,6 +4719,7 @@ static int load_video_binaries(struct ia_css_pipe *pipe)
 						  sizeof(struct ia_css_binary),
 						  GFP_KERNEL);
 		if (!mycs->yuv_scaler_binary) {
+			mycs->num_yuv_scaler = 0;
 			err = -ENOMEM;
 			return err;
 		}
-- 
2.43.0



