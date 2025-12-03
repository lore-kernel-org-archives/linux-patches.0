Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29AA313E3D;
	Wed,  3 Dec 2025 15:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776873; cv=none; b=LwYjx6VJ90+bf5O+9InkvRVCHECt2nfwwYACMlqc/ciwdhXrRwegynAFDxWOLZ5t5XH0iSnBRk5MCevU/IsE6KwztkuRwCtpE1iPC0xxCx6hyduOYwxRft58YT5qvEXUxEr8NZHH3FbM+hUbLDQPWzYEK3eBTwClmMc/9sN8PkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776873; c=relaxed/simple;
	bh=vNAEegTBAQCzm9NNPvjhjnr4OpBHIlkIWV872rOqHzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GV6XIudTn9ynjAN5wOOLaNawoTkWSiZzWfg3b+SSdu6BcFvlrMNYgnmEoS/5O0eSB4dhnwFRRcV4dlwAEJjCZp44HyfBw88l9bCS1MTj1lJyt8detfsbhvIfyIuHOQeMomfpHrjSCPlj8paS7ejt53r7COAwQQJH/lvSLJXySLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDGeOF+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDGeOF+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE3FC4CEF5;
	Wed,  3 Dec 2025 15:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776872;
	bh=vNAEegTBAQCzm9NNPvjhjnr4OpBHIlkIWV872rOqHzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDGeOF+MVhFgPnVP/m4DmftYBSIPg9AQtZKCDMf4w7FCa/jG5pciy9C0YNpRFW8Rj
	 mAj9s88FEQPo+CcZweLx0mC6gph4/qJ9pX1aS34y3GjciXOpjZvPg/gzrJEkC0V/6W
	 m6n5N+KU0u3dtEn7o94W6BNtkiPC5u1iwS7mYBxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 013/146] platform/x86: intel: punit_ipc: fix memory corruption
Date: Wed,  3 Dec 2025 16:26:31 +0100
Message-ID: <20251203152346.952499091@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 9b9c0adbc3f8a524d291baccc9d0c04097fb4869 ]

This passes the address of the pointer "&punit_ipcdev" when the intent
was to pass the pointer itself "punit_ipcdev" (without the ampersand).
This means that the:

	complete(&ipcdev->cmd_complete);

in intel_punit_ioc() will write to a wrong memory address corrupting it.

Fixes: fdca4f16f57d ("platform:x86: add Intel P-Unit mailbox IPC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aSCmoBipSQ_tlD-D@stanley.mountain
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/punit_ipc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/punit_ipc.c b/drivers/platform/x86/intel/punit_ipc.c
index bafac8aa2baf6..14513010daadf 100644
--- a/drivers/platform/x86/intel/punit_ipc.c
+++ b/drivers/platform/x86/intel/punit_ipc.c
@@ -250,7 +250,7 @@ static int intel_punit_ipc_probe(struct platform_device *pdev)
 	} else {
 		ret = devm_request_irq(&pdev->dev, irq, intel_punit_ioc,
 				       IRQF_NO_SUSPEND, "intel_punit_ipc",
-				       &punit_ipcdev);
+				       punit_ipcdev);
 		if (ret) {
 			dev_err(&pdev->dev, "Failed to request irq: %d\n", irq);
 			return ret;
-- 
2.51.0



