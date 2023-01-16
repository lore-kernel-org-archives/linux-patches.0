Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170F833EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68329C433D2;
	Mon, 16 Jan 2023 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884565;
	bh=wOjUQIm/KTlg+uAV5LlkY1FUxIHBQg/2Hq1IbpPB1pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvOmofh9YcXrJQj3AFRvh0Mg70d2U0x9Mpt+C4UxSO2zaoUurvCt7xudg2OskVSff
	 2SQTGW+2aSzOKq2vDwlNhCHkAzUFD4LIXRzqloTgX0vj/8R7D1gcZAfRSuww6VabNC
	 xb0i1TpuEJm6b7DIM435/1qunzWdDb0Pt5dQoaKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Marc Zyngier <maz@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 055/183] firmware/psci: Dont register with debugfs if PSCI isnt available
Date: Mon, 16 Jan 2023 16:49:38 +0100
Message-Id: <20230116154805.680573579@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

commit cef139299fd86098c6e3dbd389d1d0b2462d7710 upstream.

Contrary to popular belief, PSCI is not a universal property of an
ARM/arm64 system. There is a garden variety of systems out there
that don't (or even cannot) implement it.

I'm the first one deplore such a situation, but hey...

On such systems, a "cat /sys/kernel/debug/psci" results in
fireworks, as no invocation callback is registered.

Check for the invoke_psci_fn and psci_ops.get_version pointers
before registering with the debugfs subsystem, avoiding the
issue altogether.

Fixes: 3137f2e60098 ("firmware/psci: Add debugfs support to ease debugging")
Reported-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Hector Martin <marcan@marcan.st>
Acked-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20230105090834.630238-1-maz@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/psci/psci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index e7bcfca4159f..447ee4ea5c90 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -440,6 +440,9 @@ static const struct file_operations psci_debugfs_ops = {
 
 static int __init psci_debugfs_init(void)
 {
+	if (!invoke_psci_fn || !psci_ops.get_version)
+		return 0;
+
 	return PTR_ERR_OR_ZERO(debugfs_create_file("psci", 0444, NULL, NULL,
 						   &psci_debugfs_ops));
 }
-- 
2.39.0



