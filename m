Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4412D10E0;
	Fri,  6 Dec 2024 14:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496333; cv=none; b=PJfHtD05P76v3WIyqDFk2yyNfQICCegzSMcEf8zuubf5iLalUeTGjV5cGL414PFXwYSqpJhM1OtcEnlM4DLgthY+3u37FMBrKwb2XRfWGf+r2hY34MLhqNaad/vcw/gVSX74VyW5pCDZLq0U90/jLqd2+clmuwyXwLcj5R+QCgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496333; c=relaxed/simple;
	bh=EVPMqNkwN7Ax0LluGM4TBT5cA00Ah2j/YNfgoBHVPE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7VkAs1hgW/pbIo/VSIE771p6vSMQ+LGx5qjPzczvix3dzQ3S7ObDggtKV/1z0oqNxxzUf67vg/HZIABiFeeIwaaQ98cdg1GtXnxKWN0KR92tAwaF9hFv9NrZ0JpEFnT4W+/EnK2pvhNH8L2wEZaz7qQm2bHlHZWU1lxZqstKuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQoY4F4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQoY4F4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92B5C4CEDC;
	Fri,  6 Dec 2024 14:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496333;
	bh=EVPMqNkwN7Ax0LluGM4TBT5cA00Ah2j/YNfgoBHVPE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQoY4F4A1TatG4w+TtoVZlhlTmget+dY4M+gTUfeB6GSq3c0T3y66+R1KX8DTgudE
	 HSFc6r/2T9NJcn+xS8wHA9WAAyeq4pzNCNWN9XnGIBgMmQkcGi/kEhrxDa8tx3+N4+
	 IqeAQGZigPDbVWK6JOAOqpoSo0rPTp2VBYP0MJgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.12 080/146] i3c: master: svc: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Fri,  6 Dec 2024 15:36:51 +0100
Message-ID: <20241206143530.740975074@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 18599e93e4e814ce146186026c6abf83c14d5798 upstream.

It is not valid to call pm_runtime_set_suspended() for devices
with runtime PM enabled because it returns -EAGAIN if it is enabled
already and working. So, call pm_runtime_disable() before to fix it.

Cc: stable@vger.kernel.org # v5.17
Fixes: 05be23ef78f7 ("i3c: master: svc: add runtime pm support")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20240930091913.2545510-1-ruanjinjie@huawei.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -1827,8 +1827,8 @@ static int svc_i3c_master_probe(struct p
 rpm_disable:
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 err_disable_clks:
 	svc_i3c_master_unprepare_clks(master);


