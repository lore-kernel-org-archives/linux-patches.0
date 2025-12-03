Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71B135F8D1;
	Wed,  3 Dec 2025 16:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781011; cv=none; b=PRC2/eh6a7iObeg7XE7RAGunryct63ZSZ6EX/gAr8U1Em22nL23UEfpXWbTGJ15AqKVPLVC0rJKa228AB92Kk8lQaEtvivX9O9eGzSgUQHk86Lpn9szoBe6f8CilfW0ePJX2MWhpxZKB01WVUtECf+ukw5z48QL5gBtU8jqrcz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781011; c=relaxed/simple;
	bh=+xQAJu7MYHe8TZieV77Tk+0Cd8Ik0t0DFxexR9753ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rDSDWNA861Q/rFqdjL1LMYK07/Xo0AllqpYOFJt1hJtWEu99KwOiG+weKxvUid2MFVJWGgO5wn4hd9XXC8DFVWC0UttNhzfohQTwScNWs2v6KYzjCh56inWUBzwnYPEqvmO4+3o/FiXWg4bM8lcZyPapm68/Jj1n1/qORjzPjpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUNla0uT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUNla0uT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4324C4CEF5;
	Wed,  3 Dec 2025 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781011;
	bh=+xQAJu7MYHe8TZieV77Tk+0Cd8Ik0t0DFxexR9753ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUNla0uTUw8s5YlmoqsabLj5rn5yLPsnenHKFWJgx5jtNMyIAt0F3FUHDEpKgVOW3
	 Fp3DAg8BM9Sp3RsA5sRhu4wN0kMI5ANs2YcZS8lU0eM9KsIbtWcjZJxJFrJGiTpj5N
	 sc7k6qDkd0XtpxNQ7Sf4hNd4Wddq9cEMkSDXq490=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 08/93] platform/x86: intel: punit_ipc: fix memory corruption
Date: Wed,  3 Dec 2025 16:29:01 +0100
Message-ID: <20251203152336.814483760@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cd0ba84cc8e4a..9e48229538a5e 100644
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



