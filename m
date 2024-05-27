Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B0617E90E;
	Mon, 27 May 2024 19:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837139; cv=none; b=kesDL1F3L8CZ7/pFqt7A9nAGXQyUupv5j4IBg1TOCWN2piXJqn0hKgZzys33KIi1lUMfDvHw/rBk/eJHx9U9xnGzpoeitF8FJeyLTTc1FuC5mno4XYYiDIQ6X+oz0pCM7dwI0LSky31VQH2ks4YykOvGzlqU++TKZzZrvPblMFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837139; c=relaxed/simple;
	bh=R6FtZxAw9RvuBK7TGmgK/elqnRpniGnun2+Bf5/8+hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOvuN6V9LyJtTHMcWQYe8BQM9JUL4oVubS1l3KutOhrc4I3Ms+0xhluWHuMZNvpeHvcDVmDq9DDLyUaQpCw87zk29oNpD9GifDelNym+007jc1kC6cX6prOr8XcsKUNg35PBU2lFX8NWFNH4YWXtQmZfd09m9N+9pw+N70gnwVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/UcJF8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/UcJF8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354E0C32782;
	Mon, 27 May 2024 19:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837139;
	bh=R6FtZxAw9RvuBK7TGmgK/elqnRpniGnun2+Bf5/8+hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/UcJF8uCexZnm8yRZpofzBXG8F9TyDiobg3gedCt50l4B0cjlezWje1DgmhN+Bef
	 iSS9bPEt7y231dH98n6OCgDi0KHSAdOD97lrbiLQ/aO03Qwp3OUp/S6WStBF4GrCSe
	 DGTnRzOUX67uyCxo6ya/XaBQWs7tAX83x8nTBsYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 326/427] media: atomisp: ssh_css: Fix a null-pointer dereference in load_video_binaries
Date: Mon, 27 May 2024 20:56:13 +0200
Message-ID: <20240527185631.943969931@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 938a4ea89c590..8c30191b21a77 100644
--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -4690,6 +4690,7 @@ static int load_video_binaries(struct ia_css_pipe *pipe)
 						  sizeof(struct ia_css_binary),
 						  GFP_KERNEL);
 		if (!mycs->yuv_scaler_binary) {
+			mycs->num_yuv_scaler = 0;
 			err = -ENOMEM;
 			return err;
 		}
-- 
2.43.0



