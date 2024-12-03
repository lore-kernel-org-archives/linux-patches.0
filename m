Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA221E3DF9;
	Tue,  3 Dec 2024 15:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238044; cv=none; b=tUylpPDiXakioCW4y5gci82Yd/EKHi+7koqYGaSbp9e9UxnJpZ5iVNUXOhZYJ/Cv9JB8IKpExZlBva6bHKcKiVieJP++FCLWLkJzw4y9477H3IQKaVfQmBpLD8cZvq/J2c8GNo4ReeYBmC918zqc+3qxl9QEutHXyqzX5rZV6ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238044; c=relaxed/simple;
	bh=aVncyru81RkUsL0++nNKCRJE60QBLxPUpVY7zZMhe6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t05vV87qm6wbx0X8hj1L9Z3kqy84++QQTosWST/D9La+cDA8UT/b1cVoGLTQ4V/0yLNY+956BgeXtleqeynBzDEtIyCKh8pkjxPoBI3othb+843wP4rI7G1+SvaWxALPe5rd8tnIGMXGBvxHCrH8W9bMWoFmdq6newaxZJtx9Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e06iKKMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e06iKKMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B4BC4CECF;
	Tue,  3 Dec 2024 15:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238044;
	bh=aVncyru81RkUsL0++nNKCRJE60QBLxPUpVY7zZMhe6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e06iKKMTMBm8bV6kaOdWqyyY2ZNOdFogOtp2r44oXod2d0trm4gPH8/TVlbF+YTjK
	 OA8XgVKXkZ37m3J3dA14ij/yYVc5pKlbTUhwt+Udluk5Dkzcww9giu/+Y62Ys/qdj6
	 mLaqHpQYKZX+WrvO63JUSRHFmFmg+qsbn4tU3OX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 144/817] drivers: soc: xilinx: add the missing kfree in xlnx_add_cb_for_suspend()
Date: Tue,  3 Dec 2024 15:35:16 +0100
Message-ID: <20241203144001.347092224@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index f529e1346247c..85df6b9c04ee6 100644
--- a/drivers/soc/xilinx/xlnx_event_manager.c
+++ b/drivers/soc/xilinx/xlnx_event_manager.c
@@ -188,8 +188,10 @@ static int xlnx_add_cb_for_suspend(event_cb_func_t cb_fun, void *data)
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



