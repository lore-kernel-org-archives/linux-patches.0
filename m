Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3171AD9E2;
	Thu,  6 Jun 2024 14:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683338; cv=none; b=Pec20THhdUylGbZRurt/otCmdi9OqSsp4WOw9DKW26V/NMvT7G8PCoyB+qgoD1bqEjVlqjIFEEipWh2+caJka5w1nUw6wwTmnNZoH+EvIq88F5WmNlhHeBNjxK2DmFHS//Oto4oMfTDB6jG/Wz3zG6fgl3LMX51FnYkFWwbp7iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683338; c=relaxed/simple;
	bh=8XR7IMj23Lr4pKDGRtMtmkyv9XNsErYmUjd/uP2Vesg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cthLWOH7lDv6+MryDsXkA+7elTE+LU2YO7tmppZvzd0Ao1904si4aBlS/xFzse+ag0/5f5hMRPWKaPdtJGBY6LZCKR5rbZqDM0xwREBeG1yOyFbObkeGwFCmfwwSMvcmNEiNnaCeXr4GthdX+je4z1mZjMzPJnYO6ask2HFDjV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NyiIW2ra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NyiIW2ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E53FC2BD10;
	Thu,  6 Jun 2024 14:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683338;
	bh=8XR7IMj23Lr4pKDGRtMtmkyv9XNsErYmUjd/uP2Vesg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NyiIW2raA1Yl6zdnQeRqTbkSUnXPtmMfQSA5oMXBJ3sU+Ux7BLKKstzqKAo8PL7lx
	 aZXQ5FD+znzT/eJVYFrUTw/qRdEMa2mGAj8ZuNDUlULUKBPf0T0ehg2fJuFgrPUt7W
	 hCxejPMuRCu7UbH6fBRgUmofcdgZvQfFqYklOdY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 220/473] media: atomisp: ssh_css: Fix a null-pointer dereference in load_video_binaries
Date: Thu,  6 Jun 2024 16:02:29 +0200
Message-ID: <20240606131707.166220027@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index da96aaffebc19..738c0d634ea90 100644
--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -4972,6 +4972,7 @@ static int load_video_binaries(struct ia_css_pipe *pipe)
 						  sizeof(struct ia_css_binary),
 						  GFP_KERNEL);
 		if (!mycs->yuv_scaler_binary) {
+			mycs->num_yuv_scaler = 0;
 			err = -ENOMEM;
 			return err;
 		}
-- 
2.43.0



