Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894D42253E3;
	Thu, 12 Dec 2024 15:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019113; cv=none; b=nJrYTrgB8Q/b5+K+NBw2c/a+vf4qqr/kbL1DTprhDMEAjNT8Y7TCD9ZnensMBA2q8AiHxJU/ZYzZUkyR1I3kgziDiPbFRbalKv1pD6TPrINyMoTLSO0T+yY4/csl4fSh4UegcI1/D2flqpGsn8q9Gcz5Swm0+umjqbBr0OIL290=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019113; c=relaxed/simple;
	bh=0M3PSSh/qCfM6mQ7jwBETFpwMK6lesbtsJLnCqp3eUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOQUHfobnVI5ywB6AQT51Pjld/oCGW2jLQj5h4wiQNFirs/g+QVY9juP6zbmeo3FQ49BF4YHudNSGlqKmoNMl3n4e8XT3ZBPuYWxYXzYmbKHqTVFOIEUlgpZDU7vJDYbLiN4guxqXUo/+W13YvvWCOSIOqbhKSyKhBgBtEMV5tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bv4gwIlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bv4gwIlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB38FC4CED0;
	Thu, 12 Dec 2024 15:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019113;
	bh=0M3PSSh/qCfM6mQ7jwBETFpwMK6lesbtsJLnCqp3eUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bv4gwIlb1xlrxVmMzKVOOsrJExKSwS38xgpnSUHXjuYHQ5LAJgxzFMr/6eFcOCpZ0
	 77RogUDrYRtcIzkOD+FFFCB+v0f+DzXaqIYiiAH2+TvxlcORT6MYZNVj4gcKFUDrd/
	 ymS2/1aA2dTanZxCERjNWebGygBqoPutLbH46Vvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/772] drivers: soc: xilinx: add the missing kfree in xlnx_add_cb_for_suspend()
Date: Thu, 12 Dec 2024 15:50:39 +0100
Message-ID: <20241212144353.823217223@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
index 82e3174740238..e5476010bb3d1 100644
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



