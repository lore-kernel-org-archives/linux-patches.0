Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B3AFBE0;
	Mon, 11 Dec 2023 18:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+efys7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAE1C433CC;
	Mon, 11 Dec 2023 18:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319679;
	bh=LhMD8eeS8TWSGObLHV3Gswfmd9kXx72MlyIYNKFMVNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+efys7GFuv5X3OvVD+Ia3ELMXukKXKaGInIsZ8MdllV1xFgVaBS29d02aTpoe5nJ
	 +z2+iAlaEtC8UTaUsnqp3oijXyniOSO1BYoRbTE4/bJMRpHsCJ6R85ZslaQY5lJs7f
	 BZLn0HmC7gQN1My3yVLWB1KbKJ1+p+JCD5rh9dGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 194/244] coresight: ultrasoc-smb: Fix uninitialized before use buf_hw_base
Date: Mon, 11 Dec 2023 19:21:27 +0100
Message-ID: <20231211182054.631990164@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit 862c135bde8bc185e8aae2110374175e6a1b6ed5 ]

In smb_reset_buffer, the sdb->buf_hw_base variable is uninitialized
before use, which initializes it in smb_init_data_buffer. And the SMB
regiester are set in smb_config_inport.
So move the call after smb_config_inport.

Fixes: 06f5c2926aaa ("drivers/coresight: Add UltraSoc System Memory Buffer driver")
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20231114133346.30489-4-hejunhao3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/ultrasoc-smb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/ultrasoc-smb.c b/drivers/hwtracing/coresight/ultrasoc-smb.c
index 2f2aba90a5148..6e32d31a95fe0 100644
--- a/drivers/hwtracing/coresight/ultrasoc-smb.c
+++ b/drivers/hwtracing/coresight/ultrasoc-smb.c
@@ -477,7 +477,6 @@ static int smb_init_data_buffer(struct platform_device *pdev,
 static void smb_init_hw(struct smb_drv_data *drvdata)
 {
 	smb_disable_hw(drvdata);
-	smb_reset_buffer(drvdata);
 
 	writel(SMB_LB_CFG_LO_DEFAULT, drvdata->base + SMB_LB_CFG_LO_REG);
 	writel(SMB_LB_CFG_HI_DEFAULT, drvdata->base + SMB_LB_CFG_HI_REG);
@@ -587,6 +586,7 @@ static int smb_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	smb_reset_buffer(drvdata);
 	platform_set_drvdata(pdev, drvdata);
 	spin_lock_init(&drvdata->spinlock);
 	drvdata->pid = -1;
-- 
2.42.0



