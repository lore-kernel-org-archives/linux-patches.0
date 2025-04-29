Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1625D2472AC;
	Tue, 29 Apr 2025 16:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945517; cv=none; b=a7dl0eNiLfTFcHhxdfVQR78n9G0BrexRw5XVuwm64ZIDOcsjnYz0A+vxVB7TvZQ4PaQ2bOWZFhQPRN6L6M+NT+3ATwEZz3iYEeD0o08vXtGbGA+UwWi/6KYqhlLBxXa47XiKQ58cUN0kJgZHr6E2t/iFklJayAF6LpZAux21OGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945517; c=relaxed/simple;
	bh=MAU4gN/9ShsmqotYmLAgbYlcPqAj9RAmkQjkXLwcB+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tz1uspaZ8AtZm34E/crJ8ycUOYLNxJYIiLt51ekn4pa6ZaAV4p/l3p1KbNt6L9k8Uc+uyfT8fiq02sCrHk60rz8l+emV2H7vQRmSQeqwlvZuqqwViKWCJ7WIXtcrwsmG2LR+ISfemydowSGtpCU/IfIiZR1pysJJJiYlOvLDb1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EC6oZxgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EC6oZxgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917C0C4CEE3;
	Tue, 29 Apr 2025 16:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945517;
	bh=MAU4gN/9ShsmqotYmLAgbYlcPqAj9RAmkQjkXLwcB+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EC6oZxgEncZotSWk9PeodsMS1kVe3PK1eYxgw8gwG9Hl145QIkcYP8KglUbXb0vCB
	 ttOb6gFigzvdY7MMDguc759gE9bCcS09c1eTfnYQeyArjp2sCpxLmMwdGyNkPbK+e9
	 qMb5Auht3r+uVaL9MR50DWu1Q8TAlvy0wd4q0g68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 139/179] misc: pci_endpoint_test: Fix displaying irq_type after request_irq error
Date: Tue, 29 Apr 2025 18:41:20 +0200
Message-ID: <20250429161055.019870723@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 919d14603dab6a9cf03ebbeb2cfa556df48737c8 ]

There are two variables that indicate the interrupt type to be used
in the next test execution, global "irq_type" and "test->irq_type".

The former is referenced from pci_endpoint_test_get_irq() to preserve
the current type for ioctl(PCITEST_GET_IRQTYPE).

In the pci_endpoint_test_request_irq(), since this global variable
is referenced when an error occurs, the unintended error message is
displayed.

For example, after running "pcitest -i 2", the following message
shows "MSI 3" even if the current IRQ type becomes "MSI-X":

  pci-endpoint-test 0000:01:00.0: Failed to request IRQ 30 for MSI 3
  SET IRQ TYPE TO MSI-X:          NOT OKAY

Fix this issue by using "test->irq_type" instead of global "irq_type".

Cc: stable@vger.kernel.org
Fixes: b2ba9225e031 ("misc: pci_endpoint_test: Avoid using module parameter to determine irqtype")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/20250225110252.28866-4-hayashi.kunihiko@socionext.com
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pci_endpoint_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index fcb7dc8e79d43..711db6667b087 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -230,7 +230,7 @@ static bool pci_endpoint_test_request_irq(struct pci_endpoint_test *test)
 	return true;
 
 fail:
-	switch (irq_type) {
+	switch (test->irq_type) {
 	case IRQ_TYPE_INTX:
 		dev_err(dev, "Failed to request IRQ %d for Legacy\n",
 			pci_irq_vector(pdev, i));
-- 
2.39.5



