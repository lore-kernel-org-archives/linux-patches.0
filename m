Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ACB1F4FC4;
	Wed,  6 Nov 2024 12:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897679; cv=none; b=V+6pTDTZcdQR1Mrxfj31LwKpcjQo09O/KqZ/adg8LGnZV1b8sLeWM0aIpyqFc7ZzhcbqiGC5iZjNKM6towPwSMzGCoNznARRHCS1Cd75K4R7ksSrhhA4BubqGLCfqHNVHjZ6Ya6HONVtGRCH37JTk4INYjVyfnD2vtU6dOlqAgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897679; c=relaxed/simple;
	bh=pBLZwon3VTf454YYCbZ16MFhlW/5YUDmu7Au+/uPyS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMQgo+JylPOLhCaL9DEwUwFrfbSPoX/+2EPI5IN3DTookiQDrb44SbTV8A7CEPUpQafZ6AZjgdVqJcf9miJHUx4iBERO6yHIdKb7vZ/bDbkJOyiv2d3n9FhJkOOQM2I9Cfgxsoks8FBhVWMIvN1QZFp6A6h2mcoMW9RMqW0mtcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKMcm7FC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKMcm7FC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86533C4CECD;
	Wed,  6 Nov 2024 12:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897678;
	bh=pBLZwon3VTf454YYCbZ16MFhlW/5YUDmu7Au+/uPyS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKMcm7FCVcecH60dweppGKHuV1hZCcJw5XUOi2iwaVpFBEge3iJz5kYUUZPiyYAZg
	 UJQ+8vyJo43taynZu3vz2OCzhBugCPf4zfbbaOka8q7GgYP0RJKUSVjR+5T1uxoz/c
	 mBdTVlHv/ghSG+ItG4CC+QbcUDTjV8B8NWrs6oF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@maxima.ru>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/151] nvmet-auth: assign dh_key to NULL after kfree_sensitive
Date: Wed,  6 Nov 2024 13:05:22 +0100
Message-ID: <20241106120312.544703197@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Vitaliy Shevtsov <v.shevtsov@maxima.ru>

[ Upstream commit d2f551b1f72b4c508ab9298419f6feadc3b5d791 ]

ctrl->dh_key might be used across multiple calls to nvmet_setup_dhgroup()
for the same controller. So it's better to nullify it after release on
error path in order to avoid double free later in nvmet_destroy_auth().

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 7a277c37d352 ("nvmet-auth: Diffie-Hellman key exchange support")
Cc: stable@vger.kernel.org
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@maxima.ru>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/auth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index aacc05ec00c2b..74791078fdebc 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -101,6 +101,7 @@ int nvmet_setup_dhgroup(struct nvmet_ctrl *ctrl, u8 dhgroup_id)
 			pr_debug("%s: ctrl %d failed to generate private key, err %d\n",
 				 __func__, ctrl->cntlid, ret);
 			kfree_sensitive(ctrl->dh_key);
+			ctrl->dh_key = NULL;
 			return ret;
 		}
 		ctrl->dh_keysize = crypto_kpp_maxsize(ctrl->dh_tfm);
-- 
2.43.0



