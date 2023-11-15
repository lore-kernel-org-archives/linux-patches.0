Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C6D43ADC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDD3KFkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7179FC4E779;
	Wed, 15 Nov 2023 20:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081822;
	bh=oPmD1YP4CNjw5hx5Io0Q6IaOqqF0/1PsK8dA75b0epQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDD3KFkBMOyVSQfoPGBGCzC47AFdytLRAJRgEQ24VxkhkJ9GTDMcOeJfghCNaeufZ
	 RCSwmJdRXGH4orB8eDXBi8KOdpx2b+ovqGG37am3m2yL1kTe5bmIck/hWQDD4ekQGA
	 WghLz7rewYqZFSJnug5GXVmHW+3+Nl1lWFzOsTuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/191] i3c: Fix potential refcount leak in i3c_master_register_new_i3c_devs
Date: Wed, 15 Nov 2023 15:47:03 -0500
Message-ID: <20231115204653.388424612@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit cab63f64887616e3c4e31cfd8103320be6ebc8d3 ]

put_device() needs to be called on failure of device_register()
to give up the reference initialized in it to avoid refcount leak.

Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20230921082410.25548-1-dinghao.liu@zju.edu.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 1c6b78ad5ade4..828fb236a63ae 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1509,9 +1509,11 @@ i3c_master_register_new_i3c_devs(struct i3c_master_controller *master)
 			desc->dev->dev.of_node = desc->boardinfo->of_node;
 
 		ret = device_register(&desc->dev->dev);
-		if (ret)
+		if (ret) {
 			dev_err(&master->dev,
 				"Failed to add I3C device (err = %d)\n", ret);
+			put_device(&desc->dev->dev);
+		}
 	}
 }
 
-- 
2.42.0



