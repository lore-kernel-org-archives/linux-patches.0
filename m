Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF4719B3CA;
	Thu,  6 Jun 2024 14:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683374; cv=none; b=MvPQdEozIsYChYf6i6lJ9khUuC6ftG7L0K+SxMJ51Ek+yfzYrINB//iOfdQIYlsQtIbI2V0w4qdZbvZhA8gD1hbT785oFZk3CHuojjla2gQANoNU5w1gGlLeP1qyeVLvNyC4syfItfpnyVNZ6Mh9b3L0psGi9geFB9Z8so4O4Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683374; c=relaxed/simple;
	bh=EA2MTJmRdTqm0TS12Slc+Z5R7EfbfaENFRLAISels4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQSidBYkXOYTfY3LbkN8iajmVUtOYK10miQatF9Y5WLZC+U9Du8puMhykViHRtRSi0oZ9VqhVKx7okOiw7W6Mv4SM6I/Nfs8/inVMNQBiGxoXjEk8sfQsIedkM6VSoIRtzchPTnGSCvEKlQMLccCmgdnwWLdzoP9u8OicRTdfiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVFaTwo+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVFaTwo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE8BC2BD10;
	Thu,  6 Jun 2024 14:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683373;
	bh=EA2MTJmRdTqm0TS12Slc+Z5R7EfbfaENFRLAISels4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVFaTwo+WFwXvbXT1GfxmQS5ylJMFTzpJD5oDsxc4X3+UyBw+5yrbN8z2+xPCzFG9
	 ZxXcxy1FLWHETF/y6/sK4bEacPtiG4BZyI996x0Z/4XI+WOjtppLEjb6fZSToQhg/B
	 RMXsgAG95QjM9ujj29qcY8eUaBfDzKeT/RQzb/oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 315/744] media: atomisp: ssh_css: Fix a null-pointer dereference in load_video_binaries
Date: Thu,  6 Jun 2024 15:59:47 +0200
Message-ID: <20240606131742.528738147@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4b3fa6d93fe0a..d8a1d4a58db6a 100644
--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -4737,6 +4737,7 @@ static int load_video_binaries(struct ia_css_pipe *pipe)
 						  sizeof(struct ia_css_binary),
 						  GFP_KERNEL);
 		if (!mycs->yuv_scaler_binary) {
+			mycs->num_yuv_scaler = 0;
 			err = -ENOMEM;
 			return err;
 		}
-- 
2.43.0



