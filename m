Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301E1388868;
	Sat, 12 Sep 2026 08:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201469; cv=none; b=F1hQYaueYulaCdvF7Zu4VJK5wsp1KryVSbmbEluxbX14mz40yez2DlM2Zh2UZdkX5GAf9HRBpPQ1ZnH+TcLgh3nRMRDoV56IHj+iKeJRGGfp4rubmktknN+M8EP1knc9xVJ3DoATF7+1YpgcOJCjV5JBXgBcYhG/ZSRRs7Gqugk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201469; c=relaxed/simple;
	bh=V0bz25q1WrZiCbA2zzoex2nLlbFuVtzxjl/hR7pfECQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkGFRrTTJxDwYfRIR8Qf9hD0EySTIR0xZcSKxwB81usM5VY8ig2D56/DQbKBaKClHRq/MFHFRpLyBpN5tCAADx056MgVLMFo/0LFHIfg7sZp8fpN3CYoqpK4WyxJXJNyMoSW5tV42ViddCPozlCZzW3EEDnOewnw9S2wCbmS8L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDiCFihJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDiCFihJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3ED1F00893;
	Sat, 12 Sep 2026 08:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201466;
	bh=xOAKfz4pcEeQOqacjk5PZfWv/D8c3U5lM4W0T5Hddqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDiCFihJ5OuoSe3HnWPel78wRbxh1+V2l9srxQQhLoSO1cRB22zekYC2MrGP6+tOq
	 VIMlp+qeLYd5gfTGqytBEdok1oQBDb0pRE07wEjDgcac5ViGD8kRdrkCcl6ddesZ7h
	 PQUQZtxMgj4vxttP5lfXfwNxmQ4BiJUkDlHSB1Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1000/1815] misc: pci_endpoint_test: Check SUCCESS bit for doorbell status
Date: Sat, 12 Sep 2026 08:45:50 +0200
Message-ID: <20260912065712.483325257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 37ddcce6904c20c6a7debe4751f6a82f218c3bae ]

The pci-epf driver sets STATUS_DOORBELL_ENABLE_SUCCESS as the final step of
pci_epf_test_enable_doorbell(), and STATUS_DOORBELL_DISABLE_SUCCESS as the
final step of pci_epf_test_disable_doorbell(). A missing SUCCESS bit
therefore unambiguously means that the operation did not complete, whereas
the FAIL bit is only set on an explicit failure path.

The host side test in pci_endpoint_test_doorbell() currently keys off
the FAIL bit. That covers explicit failures but misses two cases.

The first case is when the wait for the completion IRQ times out. No IRQ
arrives, the Endpoint never updates STATUS, and neither SUCCESS nor FAIL
is set. The enable path already handles this correctly because it also
fails when the wait times out without an IRQ. The disable path does not
have that extra guard and would wrongly treat the timeout as success.

The second is a buggy EPC that raises two IRQs in response to a single
DOORBELL_ENABLE command. The second wait_for_completion_timeout()
returns immediately with 'left' non zero, but the endpoint has not yet
written STATUS, so SUCCESS is clear and FAIL is also clear. The current
FAIL only check treats this as success.

So check the SUCCESS bit instead. That matches the Endpoint's contract
because SUCCESS is the last write on the success path, and it correctly
reports failure for both timeouts and the spurious IRQ case without
relying on the FAIL bit being set.

Fixes: eefb83790a0d ("misc: pci_endpoint_test: Add doorbell test case")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260730122045.1382749-5-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pci_endpoint_test.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 3635741c3e7a7..26ab9252251f1 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -1071,6 +1071,7 @@ static int pci_endpoint_test_doorbell(struct pci_endpoint_test *test)
 	struct pci_dev *pdev = test->pdev;
 	struct device *dev = &pdev->dev;
 	int irq_type = test->irq_type;
+	int ret = 0;
 	enum pci_barno bar;
 	u32 data, status;
 	u32 addr;
@@ -1119,8 +1120,11 @@ static int pci_endpoint_test_doorbell(struct pci_endpoint_test *test)
 
 	status = pci_endpoint_test_readl(test, PCI_ENDPOINT_TEST_STATUS);
 
-	if (!left || !(status & STATUS_DOORBELL_SUCCESS))
+	if (!left || !(status & STATUS_DOORBELL_SUCCESS)) {
 		dev_err(dev, "Failed to trigger doorbell in endpoint\n");
+		/* Store error code, but continue to disable doorbell. */
+		ret = -EINVAL;
+	}
 
 	pci_endpoint_test_writel(test, PCI_ENDPOINT_TEST_COMMAND,
 				 COMMAND_DISABLE_DOORBELL);
@@ -1134,10 +1138,7 @@ static int pci_endpoint_test_doorbell(struct pci_endpoint_test *test)
 		return -EINVAL;
 	}
 
-	if (!(status & STATUS_DOORBELL_SUCCESS))
-		return -EINVAL;
-
-	return 0;
+	return ret;
 }
 
 static long pci_endpoint_test_ioctl(struct file *file, unsigned int cmd,
-- 
2.53.0



