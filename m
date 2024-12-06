Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530A114D29D;
	Fri,  6 Dec 2024 14:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496921; cv=none; b=torxBZnnKlRca/tYh3au6upftZ2DNkED/ZX+pgArR3Qt6448wKV/jvWPtwzfdNbsDl/m5buiK6rTAghbIlOXicD69QAC4ArWSnE90EoFYmHPNrArP0Nw5uuygEIJmzzUU5przr4ASI4uiyxM/ORB5vVIasBi/h3IGsX399oSdCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496921; c=relaxed/simple;
	bh=c1uCvZoHpBWVwebBjnWE5jpvFQa5yW7fzISvIs2DUxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ri9zaxK5ChgiHR/2q2nEhdpVf9o90Z42VKRauib2KIvMNJ+19zvwVA0313wXOLNSAgOpksJNS9v2iKBadrmKOOgbJJWuMlHJEIDIvnPBEKGiiRhdAlyJICv/9TJ6xj2RLRYM6EIPotGrTEt04m8u+2XCoUANhiDDM/aUAvusYu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvOSSpX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvOSSpX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E05C4CED1;
	Fri,  6 Dec 2024 14:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496921;
	bh=c1uCvZoHpBWVwebBjnWE5jpvFQa5yW7fzISvIs2DUxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvOSSpX7OBYCOEZQgL9qcfj/8p8CTdmN+phcP7S1+kFEBHt7t4H8bMVhPkT7ehPtG
	 HKno+YLJlWD6THoLUAoe+PuM2EoUphRTj23ua9mzlxFyvgg1O6yulvE0gU6RC1EEjb
	 IfM9ZY/I4GpVqBfr1Uj5B7Bufs9+f+0zqSGw+SBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/676] drivers: soc: xilinx: add the missing kfree in xlnx_add_cb_for_suspend()
Date: Fri,  6 Dec 2024 15:28:52 +0100
Message-ID: <20241206143657.773492892@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 44ed4f90a97ff6f339e50ac01db71544e0990efc ]

If we fail to allocate memory for cb_data by kmalloc, the memory
allocation for eve_data is never freed, add the missing kfree()
in the error handling path.

Fixes: 05e5ba40ea7a ("driver: soc: xilinx: Add support of multiple callbacks for same event in event management driver")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20240706065155.452764-1-cuigaosheng1@huawei.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/xilinx/xlnx_event_manager.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/xilinx/xlnx_event_manager.c b/drivers/soc/xilinx/xlnx_event_manager.c
index 098a2ecfd5c68..8f6a2614d8eb4 100644
--- a/drivers/soc/xilinx/xlnx_event_manager.c
+++ b/drivers/soc/xilinx/xlnx_event_manager.c
@@ -174,8 +174,10 @@ static int xlnx_add_cb_for_suspend(event_cb_func_t cb_fun, void *data)
 	INIT_LIST_HEAD(&eve_data->cb_list_head);
 
 	cb_data = kmalloc(sizeof(*cb_data), GFP_KERNEL);
-	if (!cb_data)
+	if (!cb_data) {
+		kfree(eve_data);
 		return -ENOMEM;
+	}
 	cb_data->eve_cb = cb_fun;
 	cb_data->agent_data = data;
 
-- 
2.43.0



