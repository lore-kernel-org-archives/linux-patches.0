Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140301F4276;
	Tue,  3 Dec 2024 15:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240424; cv=none; b=TmHHNB5NmVarVToTLi0Zliyn9JOXpaorzRpF01UysveQsCupz7dW+oz70As6pTn1mmmPQCI5KX2htJ6JiI0etzz5A1hGIykm1QOyI/n261MFWOJZwKtwQ637LdWVqqLK5TiDd5PfL3d0aqM+8iKUIjGARLvTfWf/n32XF/yu1yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240424; c=relaxed/simple;
	bh=vSK8w4DK0+IOYJxovd6W2QsExpb4lJektqbs/Y8K/Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlqesrHleqHAP4akriN6kZLNG8lwiCLqphPDYxdyvurQsa+Ay/8RKMsg60Ndi4mKrL2Od6LDg0tB7H3vgC+DumbrbKqj1zD48H12L7huiRONfeGTQrkbS0Ggv4XonspdQPmfN4W6wV0a5UG7HNNCB2uAYg4f993uKVHD+kcO+lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DK9jpzCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DK9jpzCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8830CC4CECF;
	Tue,  3 Dec 2024 15:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240423;
	bh=vSK8w4DK0+IOYJxovd6W2QsExpb4lJektqbs/Y8K/Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DK9jpzCzctqyBYGrxfP7Tlt8Z7BHIgXhN/bvv0mYoDU/0U8iNZYYpY0YL4x2u8zXX
	 nXlhoQ5KG5WdE0Idl0W8lrcsH+VgIeW5zdmYNXVaGvU2PrfnKXBLZmy9gNkuYD9SpY
	 FaD8mf8W+IELcPgpGpGoOkQVpuUf1kAXjI9xLbtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/826] drivers: soc: xilinx: add the missing kfree in xlnx_add_cb_for_suspend()
Date: Tue,  3 Dec 2024 15:37:10 +0100
Message-ID: <20241203144747.752086403@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



