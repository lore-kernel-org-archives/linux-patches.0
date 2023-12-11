Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069184F212;
	Mon, 11 Dec 2023 18:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7IORsU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A80C433C7;
	Mon, 11 Dec 2023 18:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319066;
	bh=FMyzI7x4DGZhDTNnvRl//7LqgH4YHz6+H+WeF0j4/SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7IORsU7vorVrZ3RZj+W8DxnvIj8q7P8p7mK8vVstiwT0sA6kJXJ/t8JLdUKgGUtT
	 hioazMwLMmDnboCaTupOJ7abdTJ+fNxb91EkH8V7JuAcR9MruVgb53jkDhBdRGoMf9
	 gEEEH9ZVdse+4Fzfqe4oF5gLYGSS2Ruv3Ln3Mi94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgeny Novikov <novikov@ispras.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/55] media: davinci: vpif_capture: fix potential double free
Date: Mon, 11 Dec 2023 19:21:15 +0100
Message-ID: <20231211182012.436414667@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182012.263036284@linuxfoundation.org>
References: <20231211182012.263036284@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 602649eadaa0c977e362e641f51ec306bc1d365d ]

In case of errors vpif_probe_complete() releases memory for vpif_obj.sd
and unregisters the V4L2 device. But then this is done again by
vpif_probe() itself. The patch removes the cleaning from
vpif_probe_complete().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/vpif_capture.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index a96f53ce80886..cf1d11e6dd8c4 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1489,8 +1489,6 @@ static int vpif_probe_complete(void)
 		/* Unregister video device */
 		video_unregister_device(&ch->video_dev);
 	}
-	kfree(vpif_obj.sd);
-	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 
 	return err;
 }
-- 
2.42.0



