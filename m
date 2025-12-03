Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFE93370E1;
	Wed,  3 Dec 2025 16:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778421; cv=none; b=Tj7fCWxiWKWT7W4hM20Nj1HA7F5vaEeqFFrbR5aSVxbroIsxqXLruDp3+R95aqspK5qwsDFtpPQeb39UlC1ll6SsbYGZYpJxfXKL6oS/iKZ31RFaOnJ7ZnDXn9MjmtFqXPEERkmhjxI66cd72SPoBTm/mIEx0Z2RyOqBxqq0WJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778421; c=relaxed/simple;
	bh=HDACurqQTXG6TtOBYw+9nYTujeXVqBIAfPH0WHgBGkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T02FV7lT+YZzjw8efnJfURSrWSR7sKpq1ULAwqcLs3f8J0tKmnt+t70DyATsKe5fd2vm86TtX5g5VrGRYw8ns4gXMHZCuszlkOl4qZ4S+XDfkDtBdAYQEPIzxwjwLsos/0WBH6ubU+0U6eAspjYG52P4CFJK5gdvOFRlaHPwp9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/dG6INl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/dG6INl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69EDC4CEF5;
	Wed,  3 Dec 2025 16:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778421;
	bh=HDACurqQTXG6TtOBYw+9nYTujeXVqBIAfPH0WHgBGkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/dG6INlu3OlEhBhvUBPJgfNQ/bkq8t2020qySQHi2GHMibPW+M70N7fbU5gnYC04
	 cu3V9AtRg95+8vgQuwgW9pepAzFFv6yPKNwH4MxJ1/Xu0voERl0EdJHibVdQ4AkZuB
	 DVrGLA4c1iIHwOLvjm39IE2SXqMRTvnVoMpenu64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 339/392] platform/x86: intel: punit_ipc: fix memory corruption
Date: Wed,  3 Dec 2025 16:28:09 +0100
Message-ID: <20251203152426.645897748@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 66bb39fd0ef90..8602f4175f123 100644
--- a/drivers/platform/x86/intel/punit_ipc.c
+++ b/drivers/platform/x86/intel/punit_ipc.c
@@ -283,7 +283,7 @@ static int intel_punit_ipc_probe(struct platform_device *pdev)
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



