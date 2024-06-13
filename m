Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC7F1448C9;
	Thu, 13 Jun 2024 12:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281078; cv=none; b=dQfV7yAfqJNkNRbP1EJ1d1/abXcoom3qqo7f+ZDQ5JGPS96PUFleiwskeSqxB+t8qmgakwK1rXOncb9oyGAfWJsX0tQPlLIqLHE9EgdyiSVDSyRlSYooFUvXE4Wf9Gx0pmwhhvT7lr/O7TrrMgYAsWZRLHM+UbqTOKsQtal04vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281078; c=relaxed/simple;
	bh=gI5pSYMvRstDZa52PYuwPskDxaDY6L/qL/BQsp9eecM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgPdXAnWqOwYS9RNTBXtPPxA4bwgiQiTSygnV/ws64fHpEQAJVXJY5XK3U6w2NEqArgApafnSuYpLM7KzeFiHRqic6Tp8DN//uKMyiBD/mX7AurpAlzLVlHna/YNc2Ys+QwyXh8Z0gq5gAhRw8WREp2pnVqwetXLDDEjM5gbl1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjFBZ7tI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjFBZ7tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70994C2BBFC;
	Thu, 13 Jun 2024 12:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281077;
	bh=gI5pSYMvRstDZa52PYuwPskDxaDY6L/qL/BQsp9eecM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjFBZ7tIFvuzXHvUtGjPoyf+UnbOJVY5KBP6pEbMsxQCSROZf9eW3mwl5qDViIfyJ
	 LAT8kHAET6Qk/U+LJEs306BhaNoDg+OGD+1AzESB9GxPzuijP148VfHx3k+5ALi+6f
	 8VghrgX61p4bOSKdN+q1e2YQuEn00yUJLcPU3sYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/317] media: atomisp: ssh_css: Fix a null-pointer dereference in load_video_binaries
Date: Thu, 13 Jun 2024 13:32:01 +0200
Message-ID: <20240613113251.534685860@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 54a18921fbd15..cb03545203602 100644
--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -5477,6 +5477,7 @@ static int load_video_binaries(struct ia_css_pipe *pipe)
 		mycs->yuv_scaler_binary = kzalloc(cas_scaler_descr.num_stage *
 						  sizeof(struct ia_css_binary), GFP_KERNEL);
 		if (!mycs->yuv_scaler_binary) {
+			mycs->num_yuv_scaler = 0;
 			err = -ENOMEM;
 			return err;
 		}
-- 
2.43.0



